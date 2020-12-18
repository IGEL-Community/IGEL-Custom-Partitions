#! /bin/bash
#set -x
#trap read debug

# Use iio-sensor-proxy to flag screen rotation
# Call xrandr to rotate screen
LOGFILE=/tmp/iio-sensor.log

monitor-sensor >> ${LOGFILE} 2>&1 &

while inotifywait -e modify ${LOGFILE}; do
  ORIENTATION=$(tail -n 1 ${LOGFILE} | grep 'orientation' | grep -oE '[^ ]+$')

  case ${ORIENTATION} in
    normal )
      xrandr -o normal
      ;;
    left-up )
      xrandr -o left
      ;;
    right-up )
      xrandr -o right
      ;;
    bottom-up )
      xrandr -o inverted
      ;;
  esac
done
