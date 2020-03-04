#!/bin/zsh

case "$1" in
	--speakers)
    local SINK="alsa_output.pci-0000_0a_00.3.analog-stereo"
    pacmd set-default-sink "$SINK"
    pacmd list-sink-inputs | grep index | while read line; do
      pacmd move-sink-input `echo $line | cut -f2 -d' '` "$SINK"
    done
		notify-send "Switched to speakers!"
		;;
  --headphones)
    local SINK="alsa_output.usb-Logitech_Logitech_G430_Gaming_Headset-00.analog-stereo"
    pacmd set-default-sink "$SINK"
    pacmd list-sink-inputs | grep index | while read line; do
      pacmd move-sink-input `echo $line | cut -f2 -d' '` "$SINK"
    done
    notify-send "Switched to headphones!"
    ;;
  --middle)
    notify-send "Middle click!"
    ;;
	*)
		echo "שׂ"
		;;
esac