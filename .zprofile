export VISUAL="emacsclient -nw"
export EDITOR="$VISUAL"
export LESSHISTFILE="$HOME/.local/share/lesshst"
export IPYTHONDIR="$HOME/.config/ipython"
export GOPATH="$HOME/prg/go"
export ARCHFLAGS="-arch x86_64"

# start x server
if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
  if [ -x "$(command -v startx)" ]; then
	  exec startx
  elif [ -x "$(command -v sway)" ]; then
	  exec sway
  fi
fi
