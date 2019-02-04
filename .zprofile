# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export LESSHISTFILE="~/.config/lesshst"
#echo "Set less history file"
export PYTHONSTARTUP="$HOME/.config/python/startup.py"
#echo "Set pythonstartup"
export PATH=/home/fecht/.vim/bundle/vim-live-latex-preview/bin:$PATH
#echo "included live-latex-preview to path"
#export GIT_CONFIG="$HOME/.config/gitconfig" (does not work rn)
export VISUAL="vim -p "
export EDITOR="$VISUAL"
#echo "set up vim as standard editor"

export XDG_DESKTOP_DIR="/home/fecht"


# for german keys in terminal
sudo loadkeys /home/fecht/.config/keystrings

PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH

RANGER_LOAD_DEFAULT_RC=false

test -r /home/fecht/.opam/opam-init/init.zsh && . /home/fecht/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

eval $(ssh-agent)


# setup i3 config
geni3conf


# start x server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi


# the following does not work in login shell
#xkbcomp -w 0 ~/.config/xkb/xkbmap $DISPLAY
#sleep 1
#
#if [ -f "/etc/hostname" ]
#then
#	xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
#	echo "hallo"
#else
#	xinput set-prop "DLL0704:01 06CB:76AE Touchpad" 287 1
#	echo "hallo2"
#fi
#
