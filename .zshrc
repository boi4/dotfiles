##zmodload zsh/zprof
source $HOME/Programs/zsh/prompt
source $HOME/Programs/zsh/zle

typeset -U path PATH fpath FPATH

mods=(parameter complist deltochar mathfunc)

for mod in $mods; do
    zmodload -i zsh/${mod} 2>/dev/null
done


lazymods=(stat)
for mod in $lazymods; do
    zmodload -a zsh/${mod} 2>/dev/null
done

builtin unset mods lazymods mod


fpath+=($HOME/Programs/zfns)

# load aliases
if [[ -r ~/.aliasrc ]]; then
  . ~/.aliasrc
fi


# ----------- ZSH OPTIONS ------------
#setopt sh_word_split # expand to several words except to one
#setopt glob_subst # expand variable wildcards
#setopt no_bg_nice # does not increase niceness of bg jobs
#setopt no_notify # notifies if bg job is done
#setopt no_hub # do not send signal to jobs, if shell quits
#setopt prompt_substitution # PS1='${PWD}% ' is possible
#setopt hist_verify # verfify !! substituions
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
setopt correct_all # did you mean...?
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
#setopt ignore_eof # ctrl+d macht kein exit
#setopt no_chase_links # use new path as pwd after following symlinks


HISTFILE="$HOME/.history"
HISTSIZE=10000
SAVEHIST=10000

REPORTTIME=5

#PS1=' %1~ > '
#RPS1='%~'
#PS1='%30<...<%~ %# '
#PS1='%(2L.+.)%# '
#PS1="%{${fg[yellow]}${bg[black]}%}%# "
#PS1=$'\e[0;31m %30<...<%~ %# \e[0m'

autoload insert-numeric
zle -N ins-num insert-numeric

# !! for last command, !!n for nth word, !!m-n for m-n words, !!$ for last word !!* for all but command !!3:t gives tail, :h head of path
# ${foo:h} # head von variable foo, :r removed suffix, :s/a/b substitutes, :u/:l upper/lowercase, ^a^b short for :s/a/b
#bindkey -v' # vim mode
# autoload fn -> search in $fpath for file fn and register it as a function
# trap 'print I caught a SIGINT' INT
# rehash um pfad neu zu durchsuchen
# print -z ..., damit ... im zle erscheint
# fn() {...;} funktion
# cd - without args to ~, cd 0.8 1.1 -> search pwd for 0.8 and replace with 1.1, use cdpath for paths to check for folders for cd 
# pushd, popd, dirs
#ls() {
#  command ls "$[@]"
#}
# difference where, whence, whereis, which, type, whence -w shows type
# typeset var=val sets var only for the current scope
# typeset -a var -> create empty array called var
# typeset -i/ integer i -> create integer, ((i = 10 ** 2))
# typeset -i 16 i -> base 16 if $i
# typeset -E/-F -> floats
# typeset -Fg -> global float
# typeset -A assoc -> assoc=(k1 v1 k2 v2 ...)
# print ${(k)assoc}
# print ${(kv)assoc}
# read var
# set a b c -> set a b c as $1 $2 $3..
# shift array/without array
# stty susp '^]', stty for settings
# trap "echo I\\'m trapped." INT
# TRAPINT() {
#   print I\'m trapped.
#}
#if [[ biryani = b* ]] is possible (pattern)
# -eq -lt -le for numbers $? - retval, $# num args, #* args as array
# zcompile
# cat < <(echo moin), echo moin> >(cat) 
# ./a.out 2> >(cat) | cat
# diff =(./myscript1) =(./myscript2)
# {first,second}'term' # kein leerzeichen
# print {now,th{en,ere{,abouts}}}
# print **/*.c
#bindkey -me # m für meta (gibt probleme)
bindkey -e # -v für vim
bindkey '\e[3~' delete-char # del löscht unter cursor, alternativ ctrl+d
bindkey '\e#' copy-prev-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '\eq' ins-num
# keybindings:
# c-u -> delete line
# c-x-u -> undo
# e-x -> execute command
# c-spc -> set mark
# e-p, e-n -> next history line match
# c-x-c-x -> mark all between point and mark
# c-o beim history scrollen -> ausführen, nächste hist line anzeigen
# c-e -> setze letztes wort der history lines ein
# e-a -> ausführen und zeile neu editieren
# c-j oder c-m statt enter
# c-enter -> nächste Zeile ohne enter
# c-a/c-e -> start -> end of line
# c-k -> del till end of line
# e-p -> circle trhough history for curr command
# bindkey zeigt alle keybindings
# zle -N widget-name function-name um neues commando für bindkey zu erstellen
# zle -l -> show widgets
WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' # dinger die als wort erkannt werden
#
# command:




# do not create ugly zcompdump files in home dir
#export ZSH_COMPDUMP=$ZSH

#source ~/.antibody/zsh_plugins.sh
#source ~/.antibody/zsh_themes.sh
##source <(antibody init)
#
#
## FZF
FZF=$HOME/Programs/cli/fzf
source "$FZF/shell/completion.zsh" 2
source "$FZF/shell/key-bindings.zsh"

## opam configuration
##test -r /home/fecht/.opam/opam-init/init.zsh && . /home/fecht/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
##zprof

eval $(dircolors -b)
