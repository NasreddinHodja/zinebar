#!/usr/bin/env bash

source ./feeder.sh

workspaces() {
    echo -e "$(./workspaces.py HDMI-0)"
}

bar_out() {
    echo -e "%{l}$(workspaces)%{r}$(home) $(storage) $(ram) $(internet) $(volume) $(brightness) $(battery) $(clock)"
}

while true; do
    bar_out
    sleep 0.1s
done
