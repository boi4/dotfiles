#zmodload zsh/zprof
ZSHSCRIPTS=${ZDOTDIR:-${HOME}/.config/zsh}
mods=(parameter complist deltochar mathfunc)
lazymods=(stat)
funcs=(ranger-cd man d activate-freesurfer activate-conda activate-fsl)

HISTFILE="${HOME}/.history"
HISTSIZE=100000
SAVEHIST=100000
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
#setopt no_nomatch # disables globbing (also) for urls, use url-magic instead


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
if [[ -r ${ZDOTDIR:-${HOME}}/aliasrc ]]; then
  . ${ZDOTDIR:-${HOME}}/aliasrc
fi


# pacman install rehash hook
TRAPUSR1() { rehash }
#zprof
