#!/run/current-system/sw/bin/bash

DOTFILES=~/dotfiles

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xrdb -merge $DOTFILES/xft.x11
xrdb -merge $DOTFILES/urxvt.x11

xsetroot -solid midnightblue
xsetroot -cursor_name left_ptr

redshift -l 52.3:4.9 &

pa-applet&

# icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
     --expand true --width 10 --transparent true --alpha 0 --tint 0x191950 --height 19 &

# notifications
dunst&

dropbox&

keepassx -min -lock&

export BROWSER=chromium

echo "Starting XMonad"
exec dbus-launch --exit-with-session xmonad
