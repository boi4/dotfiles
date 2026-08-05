#if command -v emacsclient > /dev/null && [ -d "$HOME/.doom.d" ]; then
#  export VISUAL="emacsclient -a '' --c"
#elif command -v nvim > /dev/null ; then
if command -v nvim > /dev/null ; then
  export VISUAL="nvim"
else
  export VISUAL="vim"
fi
export EDITOR="$VISUAL"

export PATH="$HOME/.local/bin:$PATH"
if [ -d "$HOME/.config/emacs/bin" ]; then
	export PATH="$HOME/.config/emacs/bin:$PATH"
fi

if [ -d "/snap/bin" ]; then
	export PATH="/snap/bin:$PATH"
fi

if [[ ! -d /google ]]; then
  if [ "$(hostnamectl hostname 2>/dev/null)" = "torbus" ]; then
    source "${ZDOTDIR:-${HOME}/.config/zsh}"/desktop
  else
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
  fi
fi

if [ -f "$HOME/.local/bin/dmenupass" ]; then
    export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
fi

if [ -f "$XDG_CONFIG_HOME/python/startup.py" ]; then
    export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
fi

export GPG_TTY="${TTY:-$(tty 2>/dev/null)}"


if [[ ! -d /google ]] && command -v go > /dev/null 2>&1; then
  export GOPATH="$HOME/.local/share/go"
  mkdir -p "$GOPATH"
  PATH="$(go env GOPATH)/bin:$PATH"
fi

if command -v cabal > /dev/null; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

if [[ -n "$DBUS_SESSION_BUS_ADDRESS" && -n "$XDG_RUNTIME_DIR" ]]; then
    systemctl --user set-environment PATH="$PATH"
fi



# ls colors
if whence dircolors >/dev/null; then
  local dircolors_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"
  if [[ ! -f "$dircolors_cache" ]]; then
    mkdir -p "${dircolors_cache:h}"
    dircolors -b >| "$dircolors_cache"
  fi
  source "$dircolors_cache"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls --color'
else
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi


#USEWAYLAND="false"
#if ! command -v sway > /dev/null; then
#    USEWAYLAND=
#fi

#if [[ ! ($DISPLAY || $WAYLAND_DISPLAY) && $XDG_VTNR -eq 1 && "$(tty)" = "/dev/tty1" ]]; then
#    # start arbtt time tracker
#    #command -v arbtt-capture && arbtt-capture &
#
#    export XAUTHORITY=~/.cache/Xauthority
#
#    if [ "$USEWAYLAND" = "true" ]; then
#        #https://discourse.ubuntu.com/t/environment-variables-for-wayland-hackers/12750
#        export _JAVA_AWT_WM_NONREPARENTING=1
#        export MOZ_ENABLE_WAYLAND=1
#        export KITTY_ENABLE_WAYLAND=1
#        export XDG_SESSION_TYPE=wayland
#        export QT_QPA_PLATFORM=wayland-egl
#        export GDK_BACKEND=wayland,x11
#
#        dbus-run-session sway 2>&1 > "$XDG_DATA_HOME/sway.log"
#    else # use x
#        startx -- -ardelay 180 -arinterval $((1000/60)) -logfile "$XDG_DATA_HOME/X.log" -quiet -core +iglx vt"$(tty | sed 's@^/dev/tty@@g')"
#        # https://unix.stackexchange.com/questions/85504/setting-repeat-rate-of-usb-keyboard-automatically
#    fi
#fi

#sudo -n loadkeys ~/.config/keystrings
