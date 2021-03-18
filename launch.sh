##!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

killall lemonbar

monitor_width=1920

gap_top=10
gap_sides=50
width=$((1920 - $gap_sides*2))
height=25

# main bar
./main_feeder.sh | lemonbar -d \
    -f 'Source Code Pro:size=10' \
    -f 'FontAwesome' \
    -p \
    -B '#282a36' -F '#f8f8f2' \
    -g "${width}x${height}+$gap_sides+$gap_top" &

# secondary bar
./secondary_feeder.sh | lemonbar -d \
    -f 'Source Code Pro:size=10' \
    -f 'FontAwesome' \
    -p \
    -B '#282a36' -F '#f8f8f2' \
    -g "${width}x${height}+$(($gap_sides + $monitor_width))+$gap_top" &

sleep 0.5s
xdo above -t $(xwininfo -root -children | egrep -o "0x[[:xdigit:]]+" | tail -1) $(xdo id -a bar)
