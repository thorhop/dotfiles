#!/run/current-system/sw/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -solid midnightblue

# icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
     --expand true --width 10 --transparent true --tint 0x191970 --height 16 &

# notifications
dunst&

dropbox&

export BROWSER=chromium

echo "Starting XMonad"
exec dbus-launch --exit-with-session xmonad
