const ESC = 0x1b;
const BEL = 0x07;
const CAN = 0x18;
const SUB = 0x1a;
const C1_DCS = 0x90;
const C1_CSI = 0x9b;
const C1_ST = 0x9c;
const C1_OSC = 0x9d;
const C1_SOS = 0x98;
const C1_PM = 0x9e;
const C1_APC = 0x9f;

function consumeCsi(value: string, start: number): number {
	for (let index = start; index < value.length; index++) {
		const code = value.charCodeAt(index);
		if (code === CAN || code === SUB) return index + 1;
		if (code >= 0x40 && code <= 0x7e) return index + 1;
	}
	return value.length;
}

function consumeControlString(value: string, start: number, allowBel: boolean): number {
	for (let index = start; index < value.length; index++) {
		const code = value.charCodeAt(index);
		if (code === CAN || code === SUB) return index + 1;
		if (allowBel && code === BEL) return index + 1;
		if (code === C1_ST) return index + 1;
		if (code === ESC && value.charCodeAt(index + 1) === 0x5c) return index + 2;
	}
	return value.length;
}

function consumeEscape(value: string, start: number): number {
	if (start + 1 >= value.length) return value.length;
	const next = value.charCodeAt(start + 1);
	if (next === 0x5b) return consumeCsi(value, start + 2);
	if (next === 0x5d) return consumeControlString(value, start + 2, true);
	if (next === 0x50 || next === 0x58 || next === 0x5e || next === 0x5f) {
		return consumeControlString(value, start + 2, false);
	}

	let index = start + 1;
	while (index < value.length) {
		const code = value.charCodeAt(index);
		if (code >= 0x20 && code <= 0x2f) {
			index += 1;
			continue;
		}
		return code >= 0x30 && code <= 0x7e ? index + 1 : index;
	}
	return value.length;
}

function isNormalizedWhitespace(code: number): boolean {
	return (
		code === 0x09 ||
		code === 0x0a ||
		code === 0x0b ||
		code === 0x0c ||
		code === 0x0d ||
		code === 0x85 ||
		code === 0x2028 ||
		code === 0x2029
	);
}

export function sanitizeEditorMetadataText(value: string): string {
	let sanitized = "";
	for (let index = 0; index < value.length; ) {
		const code = value.charCodeAt(index);
		if (code === ESC) {
			index = consumeEscape(value, index);
			continue;
		}
		if (code === C1_CSI) {
			index = consumeCsi(value, index + 1);
			continue;
		}
		if (code === C1_OSC) {
			index = consumeControlString(value, index + 1, true);
			continue;
		}
		if (code === C1_DCS || code === C1_SOS || code === C1_PM || code === C1_APC) {
			index = consumeControlString(value, index + 1, false);
			continue;
		}
		if (isNormalizedWhitespace(code)) {
			sanitized += " ";
			do index += 1;
			while (index < value.length && isNormalizedWhitespace(value.charCodeAt(index)));
			continue;
		}
		if (code < 0x20 || (code >= 0x7f && code <= 0x9f)) {
			index += 1;
			continue;
		}
		sanitized += value[index];
		index += 1;
	}
	return sanitized;
}
