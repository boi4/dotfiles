#zmodload zsh/zprof

ZSHSCRIPTS=$HOME/.config/zsh
mods=(parameter complist deltochar mathfunc)
lazymods=(stat)
funcs=(ranger-cd man)

HISTFILE="$HOME/.history"
HISTSIZE=10000
SAVEHIST=10000
REPORTTIME=5

# ----------- ZSH OPTIONS ------------
setopt noflowcontrol # crtl-s freezed nicht mehr
setopt append_history
setopt share_history
setopt inc_append_history
setopt extended_history
setopt histignorealldups
setopt hist_reduce_blanks
setopt hist_ignore_space # dont add lines to hist that start with space
setopt auto_cd
setopt multios # mehrere > + trotzdem | in einem, schlecht für stderr trennung
setopt extended_glob
setopt longlistjobs # display PID when suspending processes as well
setopt notify # report the status of backgrounds jobs immediately
setopt hash_list_all
setopt completeinword
setopt nohup
setopt auto_pushd
setopt pushd_ignore_dups
setopt nobeep
setopt noglobdots
setopt noshwordsplit
setopt unset


# ----------- RUN STUFF -------------
typeset -U path PATH fpath FPATH

if [ -d "$ZSHSCRIPTS" ]; then
    source $ZSHSCRIPTS/prompt
    source $ZSHSCRIPTS/zle
    
    fpath+=($ZSHSCRIPTS/zfns)
fi

for mod in $mods; do
    zmodload -i zsh/${mod} 2>/dev/null
done

for mod in $lazymods; do
    zmodload -a zsh/${mod} 2>/dev/null
done

for func in $funcs; do
    autoload ${funcs}  2>/dev/null
done

builtin unset mods lazymods mod funcs

# load aliases
if [[ -r ~/.aliasrc ]]; then
  . ~/.aliasrc
fi

# ls colors
if [ "$(command -v dircolors)" ]; then
	eval $(dircolors -b)
fi

# get hub autocompletion
if [ "$(command -v hub)" -a ! -f $ZSHSCRIPTS/hub.zsh_completion ]; then
    echo "Downloading hub zsh completion"
    wget https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion \
        -O $ZSHSCRIPTS/hub.zsh_completion
fi

#source $HOME/prg/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
#zprof
