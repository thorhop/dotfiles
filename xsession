#!/run/current-system/sw/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -solid midnightblue

# notifications
dunst&

export BROWSER=chromium

echo "Starting XMonad"
exec dbus-launch --exit-with-session xmonad
