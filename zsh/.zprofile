# /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


if [ -d "$HOME/.Aprilis/bin" ] ; then
    PATH="$HOME/.Aprilis/bin:$PATH"
fi

