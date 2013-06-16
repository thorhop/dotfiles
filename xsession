#!/run/current-system/sw/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
#xpmroot ~/background.xpm &

echo "Starting XMonad"
exec dbus-launch --exit-with-session xmonad
