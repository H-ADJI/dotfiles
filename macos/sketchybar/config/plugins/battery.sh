#!/usr/bin/env sh

# Battery is here bcause the ICON_COLOR doesn't play well with all background colors

PERCENTAGE=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
    exit 0
fi

case ${PERCENTAGE} in
[8-9][0-9] | 100)
    ICON=""
    ICON_COLOR=0xff2ec27e
    ;;
7[0-9])
    ICON=""
    ICON_COLOR=0xffd98019
    ;;
[4-6][0-9])
    ICON=""
    ICON_COLOR=0xffe66100
    ;;
[1-3][0-9])
    ICON=""
    ICON_COLOR=0xffe01b24
    ;;
[0-9])
    ICON=""
    ICON_COLOR=0xffe01b24
    ;;
esac

if [[ $CHARGING != "" ]]; then
    ICON=""
    ICON_COLOR=0xff2ec27e
fi

sketchybar --set $NAME \
    icon=$ICON \
    label="${PERCENTAGE}%" \
    icon.color=${ICON_COLOR}
