export VISUAL="emacsclient -nw"
export EDITOR="$VISUAL"
export LESSHISTFILE="$HOME/.local/share/lesshst"
export IPYTHONDIR="$HOME/.config/ipython"
export GOPATH="$HOME/Programs/go"
export ARCHFLAGS="-arch x86_64"

#for dir in ~/.local/bin ~/bin ~/.config/nvim/bundle/vim-live-latex-preview/bin $GOPATH/bin; do
#	if [[ -z ${path[(r)$dir]} ]]; then
#		path+=($dir)
#	fi 
#done


#export PYTHONSTARTUP="$HOME/.config/python/startup.py"
#export XDG_DESKTOP_DIR="$HOME"
#export XDG_DATA_HOME="$HOME"

# start x server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
  if [ -x "$(command -v startx)" ]; then
	  exec startx
  elif [ -x "$(command -v sway)" ]; then
	  exec sway
  fi
fi
