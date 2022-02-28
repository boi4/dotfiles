#export VISUAL="emacsclient -nw"
export PATH=$HOME/.local/bin:$PATH

if command -v lvim > /dev/null ;then 
  export VISUAL="lvim"
elif command -v nvim > /dev/null ; then
  export VISUAL="nvim"
else
  export VISUAL="vim"
fi
export EDITOR="$VISUAL"
export LESSHISTFILE="$HOME/.local/share/lesshst"
export IPYTHONDIR="$HOME/.config/ipython"
export ARCHFLAGS="-arch x86_64"
export BROWSER="firefox"

export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="$HOME/.config/wget/wgetrc"
export INPUTRC="$HOME/.config/inputrc"

export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"

export PYTHONSTARTUP="$HOME/.config/python/startup.py"
export PYTHONPYCACHEPREFIX="$HOME/.cache/python/"



if [[ $(command -v go) ]]; then
    export GOPATH="$HOME/prj/go"
    PATH="$(go env GOPATH)/bin:$PATH"
fi

if [[ $(command -v cabal) ]]; then
    export PATH=$HOME/.cabal/bin:$PATH
fi

systemctl --user set-environment PATH="$PATH"

## start x server
#if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
#  if [ -x "$(command -v startx)" ]; then
#          systemctl --user set-environment DISPLAY=":0"
#	  exec startx
#  elif [ -x "$(command -v sway)" ]; then
#	  exec sway
#  fi
#fi

if [ "$(mount | grep 'on / ' | awk '{print $1}')" = "/dev/vg/root" ]; then
    ln -svf ~/.config/spotifyarch ~/.config/spotify
elif [ "$(mount | grep 'on / ' | awk '{print $1}')" = "/dev/vg/gentoo" ]; then
    ln -svf ~/.config/spotifgentoo ~/.config/spotify
fi

if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
    #export LOCALE_ARCHIVE=/nix/store/k51wcq4lqkj3la51jlpnsnnly5wwhc8i-glibc-locales-2.30/lib/locale/locale-archive
    #export QML2_IMPORT_PATH=/run/current-system/sw/lib/qt-5.12.7/qml
    #export QT_PLUGIN_PATH=/run/current-system/sw/lib/qt-5.12.7/plugins
    #export TZDIR=/nix/store/msbzkf26r6v5nypj1dspjk5jfnvl9l8y-tzdata-2019c/share/zoneinfo
    export XAUTHORITY=~/.cache/Xauthority

    # https://unix.stackexchange.com/questions/85504/setting-repeat-rate-of-usb-keyboard-automatically
    #exec startx -- -ardelay 180 -arinterval $((1000/60)) -logfile ~/.local/share/X.log -quiet -core +iglx vt"$(tty | sed 's@^/dev/tty@@g')"
    startx -- -ardelay 180 -arinterval $((1000/60)) -logfile ~/.local/share/X.log -quiet -core +iglx vt"$(tty | sed 's@^/dev/tty@@g')"
fi

#sudo -n loadkeys ~/.config/keystrings
