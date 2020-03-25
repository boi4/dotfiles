#export VISUAL="emacsclient -nw"
export VISUAL="vim"
export EDITOR="$VISUAL"
export LESSHISTFILE="$HOME/.local/share/lesshst"
export IPYTHONDIR="$HOME/.config/ipython"
export ARCHFLAGS="-arch x86_64"
export BROWSER=firefox

export PATH=$HOME/bin:$PATH

if [[ $(command -v go) ]]; then
    export GOPATH="$HOME/prj/go"
    PATH="$(go env GOPATH):$PATH"
fi

## start x server
#if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
#  if [ -x "$(command -v startx)" ]; then
#          systemctl --user set-environment DISPLAY=":0"
#	  exec startx
#  elif [ -x "$(command -v sway)" ]; then
#	  exec sway
#  fi
#fi



if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
    export LOCALE_ARCHIVE=/nix/store/k51wcq4lqkj3la51jlpnsnnly5wwhc8i-glibc-locales-2.30/lib/locale/locale-archive
    export QML2_IMPORT_PATH=/run/current-system/sw/lib/qt-5.12.7/qml
    export QT_PLUGIN_PATH=/run/current-system/sw/lib/qt-5.12.7/plugins
    export TZDIR=/nix/store/msbzkf26r6v5nypj1dspjk5jfnvl9l8y-tzdata-2019c/share/zoneinfo

    # https://unix.stackexchange.com/questions/85504/setting-repeat-rate-of-usb-keyboard-automatically
    exec startx -- -ardelay 180 -arinterval $((1000/50)) -logfile ~/.local/share/X.log -quiet
fi
