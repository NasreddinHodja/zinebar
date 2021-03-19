#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

killall lemonbar

# there must be a better way to do this
monitor_width=$(xrandr | grep connected | head -n 1 | cut -d " " -f 3 | cut -d "x" -f 1)

gap_top=10
gap_sides=400
width=$((1920 - $gap_sides*2))
height=25

# primary bar
./primary_feeder.sh | lemonbar -d \
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
