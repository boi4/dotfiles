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

# start x server
if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
  if [ -x "$(command -v startx)" ]; then
          systemctl --user set-environment DISPLAY=":0"
	  exec startx
  elif [ -x "$(command -v sway)" ]; then
	  exec sway
  fi
fi
