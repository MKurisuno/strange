#
#  MSYS2 .bashrc 
#

# 履歴を便利に
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth              #空白を履歴に追記しない、重複履歴を保存しない
export HISTIGNORE="fg*:bg*:history*:cd*"   #よく使うコマンドは履歴保存対象から外す。
HISTTIMEFORMAT='%Y%m%d %T';
export HISTTIMEFORMAT                      #historyに時刻を入れる

shopt -s histappend
shopt -s checkwinsize



case "$MSYSTEM" in
    UCRT64)
    #export PATH="/ucrt64/bin:$PATH"
    #export MY_BUILD_ENV=ucrt64
    ;;
    CLANG64)
    #export PATH="/clang64/bin:$PATH"
    #export MY_BUILD_ENV=clang64
    ;;
esac



#---------------------------------------------------------------------
#  PS1 の設定
#---------------------------------------------------------------------
#wrap関数の方が綺麗ではあるが、フォークが増えると思いのでScratchで書く。
#--- color palette ---
_red=$'\e[38;2;255;85;85m'       # #FF5555
_orange=$'\e[38;2;255;184;108m'  # #FFB86C
_green=$'\e[38;2;80;250;123m'    # #50FA7B
_pink=$'\e[38;2;255;121;198m'    # #FF79C6
_purple=$'\e[38;2;189;147;249m'  # #BD93F9
_cyan=$'\e[38;2;139;233;253m'    # #8BE9FD
_yellow=$'\e[38;2;241;250;140m'  # #F1FA8C
_RED=$'\e[1;38;2;255;85;85m'       # #FF5555 bold 
_ORANGE=$'\e[1;38;2;255;184;108m'  # #FFB86C bold
_GREEN=$'\e[1;38;2;80;250;123m'    # #50FA7B bold
_PINK=$'\e[1;38;2;255;121;198m'    # #FF79C6 bold
_PURPLE=$'\e[1;38;2;189;147;249m'  # #BD93F9 bold
_CYAN=$'\e[1;38;2;139;233;253m'    # #8BE9FD bold
_YELLOW=$'\e[1;38;2;241;250;140m'  # #F1FA8C bold
_reset=$'\e[0m'
#---------------------
red="\[$_red\]"
orange="\[$_orange\]"
green="\[$_green\]"
pink="\[$_pink\]"
purple="\[$_purple\]"
cyan="\[$_cyan\]"
yellow="\[$_yellow\]"
RED="\[$_RED\]"
ORANGE="\[$_ORANGE\]"
GREEN="\[$_GREEN\]"
PINK="\[$_PINK\]"
PURPLE="\[$_PURPLE\]"
CYAN="\[$_CYAN\]"
reset="\[$_reset\]"

# \001 \002 で包んだ版(PS1内の変数展開用)
# git status をチャックする ✔/✘ 用
_R=$'\001'"$_red"$'\002'
_G=$'\001'"$_green"$'\002'
_Z=$'\001'"$_reset"$'\002'

# Arrow_icon
#ARROW_ICON="->λ "
ARROW_ICON="➡ "

git_prompt() {
  local out branch
  GIT_INFO=
  out=$(git status --porcelain --branch 2>/dev/null) || return
  branch=${out%%$'\n'*}
  branch=${branch#\#\# }
  branch=${branch%%...*}
  branch=${branch#No commits yet on }

  if [[ $out == *$'\n'* ]]; then
    GIT_INFO=" (${branch}) ${_R}✘${_Z}"
  else
    GIT_INFO=" (${branch}) ${_G}✔${_Z}"
  fi
}
PROMPT_COMMAND=git_prompt
PS1="${green}\D{%y/%m/%d %H:%M}${reset} ${PURPLE}\w${reset}${CYAN}\${GIT_INFO}${reset}\n${orange}[${MSYSTEM:-Bash}]${reset} ${green}${ARROW_ICON}${reset} "



#---------------------------------------------------------------------
#  Completion 
#---------------------------------------------------------------------
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

#---------------------------------------------------------------------
# alias
#---------------------------------------------------------------------
alias lo='exit'
alias bd='cd $OLDPWD'
alias dir='dir --color=auto'
export GREP_COLORS="mt=1;38;2;255;85;85:fn=38;2;255;121;198:ln=38;2;80;250;123:bn=38;2;80;250;123:se=38;2;139;233;253"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rgrep='egrep --color=auto'
alias grep='grep --color=auto'
export LS_COLORS='di=01;38;5;141:ln=01;38;5;117:so=01;38;5;212:pi=38;5;215:ex=01;38;5;84:bd=38;5;215:cd=38;5;215:*.tgz=01;38;5;203:*.gz=01;38;5;203:*.zip=01;38;5;203:*.bz2=01;38;5;203:*.xz=01;38;5;203:*.jpg=01;38;5;212:*.jpeg=01;38;5;212:*.png=01;38;5;212:*.gif=01;38;5;212:*.mp3=01;38;5;215:*.mp4=01;38;5;215:*.mkv=01;38;5;215:*.pdf=01;38;5;141:*.md=01;38;5;117:*.txt=38;5;255'
alias ls='/bin/ls --color=auto'
alias l='/bin/ls --color=auto -lF'
alias la='/bin/ls --color=auto -a'
alias ll='/bin/ls --color=auto -alF'
alias lx='/bin/ls --color=auto -aF'

#---------------------------------------------------------------------
# fzf の設定
#---------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS='--border --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
  eval "$(fzf --bash)"
fi

#---------------------------------------------------------------------
# less --> bat : cat clone with syntax highlight.
#---------------------------------------------------------------------
if command -v bat >/dev/null 2>&1; then
    alias less='bat'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v batcat >/dev/null 2>&1; then
    alias less='batcat'
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
else 
    echo "not found \'bat.\' \n"
fi
export LESS="-R"


# ディレクトリ移動後に中身を表示
function cdl() {
  cd "$@" && ls
}
