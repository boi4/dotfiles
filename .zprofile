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
#export PYTHONSTARTUP="$HOME/.config/python/startup.py"
#echo "Set pythonstartup"
export IPYTHONDIR="~/.config/ipython"
export PATH=/home/fecht/.config/nvim/bundle/vim-live-latex-preview/bin:$PATH
#echo "included live-latex-preview to path"
export VISUAL="nvim -p "
export EDITOR="$VISUAL"
#echo "set up nvim as standard editor"

export XDG_DESKTOP_DIR="/home/fecht"


# for german keys in terminal
sudo loadkeys /home/fecht/.config/keystrings

PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH

RANGER_LOAD_DEFAULT_RC=false

test -r /home/fecht/.opam/opam-init/init.zsh && . /home/fecht/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


# setup i3 config
geni3conf

#
# setup ssh-agent
# http://mah.everybody.org/docs/ssh

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps ${SSH_AGENT_PID} #doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
    }
else
	echo a
     start_agent;
fi


# start x server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

