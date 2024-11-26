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
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"

export LESSHISTFILE="-"


export LIBVIRT_DEFAULT_URI="qemu:///system"

# misc
export CALIBRE_USE_DARK_PALETTE=1
export ARCHFLAGS="-arch x86_64"


export BROWSER="$HOME/.local/bin/urlopen.py"


# IMPORTANT: zsh needs this to find zshrc and zprofile
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

emulate zsh -o all_export -c 'source ~/.config/environment.d/ssh_askpass.conf'
emulate zsh -o all_export -c 'source ~/.config/environment.d/ssh_auth_socket.conf'
