# setup keyboard
setxkbmap eu -option caps:swapescape
#xset r rate 180 60

#xrdb -merge ~/.Xresources
#xrandr --dpi 160

#xrandr --output eDP1 --off --output DP1 --mode 3840x2160 --pos 0x0 --rotate normal 2>&1 > ~/t

# setup session lock
xset s 300 50 # ten minutes until screensaver (dpms)
xss-lock -n $(dirname $(readlink $(which xsecurelock)))/../libexec/xsecurelock/dimmer -l -- /home/fecht/.local/bin/lock.sh &

#export $(dbus-launch)
#dbus-update-activation-environment --systemd --all


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

systemctl --user import-environment

#xrandr | grep -w connected | grep 3840x2160 && {
	#xrandr --dpi 160
	#gsettings set org.gnome.desktop.interface text-scaling-factor $((90.0/160))
#}

# start wm
session=${2:-i3}

#exec startplasma-x11
#exit
case $session in
    #i3|i3wm           ) exec i3 -V -d all &>> "$XDG_DATA_HOME"/i3.log;;
    #i3|i3wm           ) exec i3 -V &>> "$XDG_DATA_HOME"/i3.log;;
    i3|i3wm           ) exec i3 &>> "$XDG_DATA_HOME"/i3.log;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    #sway              ) exec sway;;
    # No known session, try to run it as command
    *                 ) exec $session;;
esac
