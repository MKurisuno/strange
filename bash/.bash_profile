# This file is sourced only for login shells
#  bash_profile is sourced as Login Shell at login.
#


if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


if [ -d "$HOME/.Aprilis/bin" ] ; then
    PATH="$HOME/.Aprilis/bin:$PATH"
fi

