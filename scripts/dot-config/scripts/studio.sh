#!/bin/bash

GUITAR_SCARLET="alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7AYP1C4A7D8BB-00.HiFi__Mic2__source:capture_MONO"
SPEAKER_L="bluez_output.10_94_97_36_C7_15.1:playback_FL"
SPEAKER_R="bluez_output.10_94_97_36_C7_15.1:playback_FR"
GUITARIX_AMP_IN="gx_head_amp:in_0"
GUITARIX_AMP_OUT="gx_head_amp:out_0"
GUITARIX_FX_IN="gx_head_fx:in_0"
GUITARIX_FX_OUT_L="gx_head_fx:out_0"
GUITARIX_FX_OUT_R="gx_head_fx:out_1"

guitarix &
echo "-> Wiring everything together..."
sleep 0.5
echo "Guitar -> Guitarix amp"
pw-link "$GUITAR_SCARLET" "$GUITARIX_AMP_IN"

sleep 0.5
echo "Guitarix amp -> GUITARIX fx"
pw-link "$GUITARIX_AMP_OUT" "$GUITARIX_FX_IN"
sleep 0.5
echo "Guitarix fx -> speakers"
pw-link "$GUITARIX_FX_OUT_L" "$SPEAKER_L"
sleep 0.5
pw-link "$GUITARIX_FX_OUT_R" "$SPEAKER_R"
