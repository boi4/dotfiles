export VISUAL="nvim"
export EDITOR="$VISUAL"
export LESSHISTFILE="$HOME/.local/share/lesshst"
export IPYTHONDIR="$HOME/.config/ipython"
export GOPATH="$HOME/Programs/go"
export ARCHFLAGS="-arch x86_64"

typeset -U path fpath
for dir in ~/.local/bin ~/bin ~/.config/nvim/bundle/vim-live-latex-preview/bin $GOPATH/bin; do
	if [[ -z ${path[(r)$dir]} ]]; then
		path+=($dir)
	fi 
done


#export PYTHONSTARTUP="$HOME/.config/python/startup.py"
#export XDG_DESKTOP_DIR="$HOME"
#export XDG_DATA_HOME="$HOME"
# Compilation flags
# for caps<->esc in terminal
#PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH"
#RANGER_LOAD_DEFAULT_RC=false
#test -r /home/fecht/.opam/opam-init/init.zsh && . /home/fecht/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

sudo loadkeys $HOME/.config/keystrings

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
     start_agent;
fi


# start x server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 && $(tty)="/dev/tty1" ]]; then
  # setup i3 config
  geni3conf
  exec startx
fi
