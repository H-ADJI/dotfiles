#!/usr/bin/env bash
set -euo pipefail

allow_token=""
for arg in "$@"; do
  if [[ "$arg" == "--allow-token" ]]; then
    allow_token="r"
  fi
done

labels=()
kinds=()
payloads=()

while read -r name x y w h; do
  labels+=("${name} (${w}x${h} at ${x},${y})")
  kinds+=("screen")
  payloads+=("$name")
done < <(hyprctl monitors -j | jq -r '.[] | "\(.name) \(.x) \(.y) \(.width) \(.height)"')

if [[ -n "${XDPH_WINDOW_SHARING_LIST:-}" ]]; then
  for token in $(printf '%s' "$XDPH_WINDOW_SHARING_LIST" | sed 's/\[HA>\]/\n/g'); do
    [[ -z "$token" ]] && continue
    id=${token%%\[HC>\]*}
    rest=${token#*\[HC>\]}
    class=${rest%%\[HT>\]*}
    rest=${rest#*\[HT>\]}
    title=${rest%%\[HE>\]*}
    labels+=("${class}: ${title}")
    kinds+=("window")
    payloads+=("$id")
  done
fi

labels+=("Select region...")
kinds+=("region")
payloads+=("region")

selection=""
if [[ ${#labels[@]} -gt 0 ]]; then
  selection=$(printf '%s\n' "${labels[@]}" | fuzzel --dmenu -p "Share... " -l 10 -w 45 || true)
fi
[[ -z "$selection" ]] && exit 1

for i in "${!labels[@]}"; do
  if [[ "${labels[$i]}" == "$selection" ]]; then
    case "${kinds[$i]}" in
      screen)
        printf '[SELECTION]%s/screen:%s\n' "$allow_token" "${payloads[$i]}"
        exit 0
        ;;
      window)
        printf '[SELECTION]%s/window:%s\n' "$allow_token" "${payloads[$i]}"
        exit 0
        ;;
      region)
        read -r sname rx ry rw rh <<< "$(slurp -f '%o %x %y %w %h')" || exit 1
        sx=0
        sy=0
        read -r sx sy <<< "$(hyprctl monitors -j | jq -r --arg n "$sname" '.[] | select(.name == $n) | "\(.x) \(.y)"')" || true
        printf '[SELECTION]%s/region:%s@%d,%d,%d,%d\n' "$allow_token" "$sname" $((rx - sx)) $((ry - sy)) "$rw" "$rh"
        exit 0
        ;;
    esac
    break
  fi
done

exit 1
