#!/bin/bash
#
# rotate_desktop.sh
#
# Rotates modern Linux desktop screen and input devices to match. Handy for
# convertible notebooks. Call this script from panel launchers, keyboard
# shortcuts, or touch gesture bindings (xSwipe, touchegg, etc.).
#
# Using transformation matrix bits taken from:
#   https://wiki.ubuntu.com/X/InputCoordinateTransformation
#

# Configure these to match your hardware (names taken from `xinput` output).
TOUCHSCREEN='silead_ts'

# Create Pipe
pipe=/tmp/rotatepipe
trap "rm -f $pipe" EXIT
if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

#Start Accelerator Monitor
monitor-sensor >> /tmp/rotatepipe 2>&1 &

# Read position change
while true
do
    if read line < $pipe; then

DIRECTION=$(echo $line|grep 'Accelerometer orientation changed'|awk '{print $4}')
echo "DIRECTION: $DIRECTION"
function do_rotate
{

  TRANSFORM='Coordinate Transformation Matrix'

  case "$2" in
    left-up)
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 1 0 1 0 0 0 0 1
      xrandr --output $1 --rotate normal
      ;;
    right-up)
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 -1 1 -1 0 1 0 0 1
      xrandr --output $1 --rotate inverted
      ;;
    bottom-up)
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" -1 0 1 0 1 0 0 0 1
      xrandr --output $1 --rotate left
      ;;
    normal)
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 1 0 0 0 -1 1 0 0 1
      xrandr --output $1 --rotate right
      ;;
  esac
}

XDISPLAY=`xrandr --current | grep primary | sed -e 's/ .*//g'`
XROT=`xrandr --current --verbose | grep primary | egrep -o ' (normal|left|inverted|right) '`

do_rotate $XDISPLAY $DIRECTION

fi
done

