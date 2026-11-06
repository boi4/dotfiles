export NO_AT_BRIDGE=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python/"

export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/xcompose"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"

export GEM_HOME="$XDG_DATA_HOME/gem"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
if [[ "$OSTYPE" == "darwin"* ]] && [[ "$TERM" == "xterm-kitty" ]] && [[ -d "/Applications/kitty.app/Contents/Resources/kitty/terminfo" ]]; then
  export TERMINFO="/Applications/kitty.app/Contents/Resources/kitty/terminfo"
elif [[ -d "$XDG_DATA_HOME/terminfo" ]]; then
  export TERMINFO="$XDG_DATA_HOME/terminfo"
elif [[ -d "$HOME/.terminfo" ]]; then
  export TERMINFO="$HOME/.terminfo"
fi
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:$HOME/.terminfo:/opt/homebrew/share/terminfo:/usr/share/terminfo"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"

export LESSHISTFILE="-"


export LIBVIRT_DEFAULT_URI="qemu:///system"

# misc
export CALIBRE_USE_DARK_PALETTE=1
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ARCHFLAGS="-arch $(uname -m)"
else
  export ARCHFLAGS="-arch x86_64"
fi


export BROWSER="$HOME/.local/bin/urlopen.py"


# IMPORTANT: zsh needs this to find zshrc and zprofile
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ "$OSTYPE" != "darwin"* ]] && [[ ! -d /google ]]; then
  emulate zsh -o all_export -c 'source ~/.config/environment.d/ssh_askpass.conf 2>/dev/null || true'
  emulate zsh -o all_export -c 'source ~/.config/environment.d/ssh_auth_socket.conf 2>/dev/null || true'
fi
export OPENSSL_CONF=/dev/null
export OLLAMA_HOST=https://ollama.fecht.cc

if [[ "$OSTYPE" == "darwin"* ]]; then
    for brewprefix in /opt/homebrew /usr/local; do
        if [[ -x "$brewprefix/bin/brew" ]]; then
            export PATH="$brewprefix/bin:$brewprefix/sbin:$PATH"
            export MANPATH="$brewprefix/share/man:${MANPATH:-}"
            break
        fi
    done
    unset brewprefix
fi
