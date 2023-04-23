export LANG=ja_JP.UTF-8
export EDITOR=vim
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
if command -v go > /dev/null; then
  GOPATH=$(go env GOPATH)
  export GOPATH
  export PATH=$PATH:$GOPATH/bin
fi

bindkey -e
bindkey "^[u" undo
bindkey "^[r" redo
bindkey "^[[Z" reverse-menu-complete

HISTFILE=~/.zsh_history
SAVEHIST=1000000
HISTSIZE=$SAVEHIST
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt extended_history

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt pushd_ignore_dups
setopt list_types
setopt list_packed
setopt print_eight_bit
setopt interactive_comments
setopt no_flow_control
setopt no_beep

case $OSTYPE in
  darwin*)
    alias ls='ls -GF'
    ;;
  linux*)
    alias ls='ls -F --color=auto'
    ;;
esac
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias la='ls -aF'
alias ll='ls -laF'
alias grep='grep --color=auto'

# asdf
export ASDF_DIR="$XDG_DATA_HOME/asdf"
export ASDF_DATA_DIR="$ASDF_DIR"
source "$ASDF_DIR/asdf.sh"
[ -d "$ASDF_DIR/completions" ] && fpath=("$ASDF_DIR/completions" "${fpath[@]}")

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_TMUX_OPTS='-h 70% -w 70% --reverse'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
fi
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# ghq
ghq_list() {
  cd "$(ghq list --full-path | fzf-tmux "${=FZF_TMUX_OPTS}")" || exit
}
zle -N ghq_list_widget ghq_list
bindkey "^G" ghq_list_widget

# zsh-syntax-highlighting
source "$XDG_DATA_HOME"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## prompt
TERM=xterm-256color
[ -f ~/.zsh_prompt ] && source "$HOME/.zsh_prompt"

autoload -Uz compinit && compinit
