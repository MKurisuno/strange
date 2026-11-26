# System-wide .bashrc file for interactive bash(1) shells.
# This file is bash_profile which sourced only for login shells.
#

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi


if [ -d "$HOME/.Aprilis/bin" ] ; then
    export PATH="$HOME/.Aprilis/bin:$PATH"
fi

#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/openssh_agent"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"


