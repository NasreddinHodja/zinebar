#!/usr/bin/env bash

# colors
bg_color="#282a36"
fg_color="#f8f8f2"

clock() {
    time=$(date "+%Y %b %d (%a) %I:%M%p")
    echo -e "%{F${bg_color}}%{B${fg_color}}  $time %{F-}%{B-}"
}

battery() {
    percent=""
    for battery in /sys/class/power_supply/BAT?
    do
        # Get its remaining capacity and charge status.
        capacity=$(cat "$battery"/capacity) || exit
        status=$(cat "$battery"/status)

        # If it is discharging and 25% or less, we will add a ❗ as a warning.
        [ "$status" = "Discharging" ] && [ "$capacity" -le 25 ] && warn="!!!"

        # Print the battery status (replaced by a cooresponding emoji with
        # sed), the percentage left and the warning if there is one.
        out=$(printf " %s%s \n" "$warn" "$(echo "$capacity" | sed -e 's/$/%/')")
        percent+=$out
        unset warn
    done

    echo -e "%{F${bg_color}}%{B${fg_color}} $percent%{F-}%{B-}"
}

brightness() {
    case $BLOCK_BUTTON in
        # right click
        # set to `20
        3) STATUS="$(/home/nasredd1n/.local/src/brightlight-master/brightlight -p -w 50)" ;;

        # scroll up
        # raise brightness
        4) STATUS="$(/home/nasredd1n/.local/src/brightlight-master/brightlight -p -i 10)" ;;

        # scroll down
        # lower brightness
        5) STATUS="$(/home/nasredd1n/.local/src/brightlight-master/brightlight -p -d 10)" ;;
    esac

    STATUS="$(/home/nasredd1n/.local/src/brightlight-master/brightlight -p | tail -c 5 | rev | cut -c 2- | rev)"

    printf -v intstatus '%d' "$STATUS"

    echo -e "%{F$bg_color}%{B$fg_color} $STATUS% %{F-}%{B-}"
}

volume() {
    # # input response
    # case $BLOCK_BUTTON in
    #     1) setsid "$TERMINAL" -e pulsemixer & ;;
    #     2) amixer sset Master toggle ;;
    #     4) amixer sset Master 2%+ >/dev/null 2>/dev/null ;;
    #     5) amixer sset Master 2%- >/dev/null 2>/dev/null ;;
    #     # 3) pgrep -x dunst >/dev/null && notify-send "📢 Volume module" "\- Shows volume 🔊, 🔇 if muted.
    # # - Middle click to mute.
    # # - Scroll to change."
    # esac

    mute="amixer sset Master toggle"
    vol_up="amixer sset Master 2%+ >/dev/null 2>/dev/null"
    vol_down="amixer sset Master 2%- >/dev/null 2>/dev/null"

    volstat="$(amixer get Master)"

    echo "$volstat" | grep "\[off\]" >/dev/null && printf "muted\\n" && exit

    vol=$(echo "$volstat" | grep -o "\[[0-9]\+%\]" | sed "s/[^0-9]*//g;1q")

    echo "%{A:$mute:}%{F$bg_color}%{B$fg_color}  $vol% %{F-}%{B-}%{A}"
    # echo "%{A:$mute}%{A4:$vol_up}%{A5:$vol_down}%{F$bg_color}%{B$fg_color}  $vol% %{F-}%{B-}%{A}%{A}%{A}"
    # echo "%{F$bg_color}%{B$fg_color}  $vol% %{F-}%{B-}"
}

internet() {
    # # click response
    # case $BLOCK_BUTTON in
    #     1) $TERMINAL -e nmtui ;;
    #     3) pgrep -x dunst >/dev/null && notify-send "🌐 Internet module" "\- Click to connect
    # 📡: no wifi connection
    # 📶: wifi connection with quality
    # ❎: no ethernet
    # 🌐: ethernet working
    # " ;;
    # esac

    [ "$(cat /sys/class/net/w*/operstate)" = 'down' ] && wifiicon="" ||
        wifiicon="\uf1eb"$(grep "^\s*w" /proc/net/wireless | awk '{ int($3 * 100 / 70) "%" }')

    out=$(echo -e "$wifiicon ~ $(sed "s/down//;s/up//" /sys/class/net/e*/operstate)")
    echo "%{F$fg_color}%{B$bg_color}$out %{F-}%{B-}"
}

ram() {
    out=$(free -h | awk '/^Mem:/{print " " $3 "/" $2 ""}')
    echo "$out"
}

storage() {
    echo $(disk /mnt/nasHDD )
}

home() {
    echo $(disk /home )
}

workspaces() {
    echo -e "$(./workspaces.py HDMI-0)"
}

bar_out() {
    echo -e "%{l}$(workspaces)%{r}$(home) $(storage) $(ram) $(internet) $(volume) $(brightness) $(battery) $(clock)"
}

# # multiple monitors
# monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")

# while true; do
#     tmp=0
#     barout=""
#     for monitor in $(echo $monitors); do
#         barout+="%{S${tmp}}$(bar_out)"
#         ((tmp++))
#     done

#     echo $barout

#     sleep 0.1s
# done

while true; do
    bar_out
    sleep 0.1s
done
