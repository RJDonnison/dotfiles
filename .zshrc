if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:$HOME/.local/bin"

ZSH_THEME="powerlevel10k/powerlevel10k"

prompt='$ '

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# lf config
lf() {
    command lf "$@"
    if [ -f ~/.cache/lf_lastdir ]; then
        cd "$(cat ~/.cache/lf_lastdir)" || return
        rm -f ~/.cache/lf_lastdir
    fi
}

export BAT_THEME="base16-256"

# gum styling
export GUM_INPUT_CURSOR_FOREGROUND="#fff"
export GUM_INPUT_PROMPT_FOREGROUND="#6a97ff"

export GUM_CONFIRM_PROMPT_FOREGROUND="#6a97ff"
export GUM_CONFIRM_SELECTED_FOREGROUND="#d8d8d8"
export GUM_CONFIRM_SELECTED_BACKGROUND="#6a97ff"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="#6f718b"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="#474f71"


# User configuration

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'

alias zsrc='nvim ~/.zshrc'
alias reload='source ~/.zshrc'

alias c='clear'

alias gD='cd ~/Documents'
alias gd='cd ~/Downloads'
alias gc='cd ~/.config'
alias gr='cd ~/Repos'
alias gs='cd ~/.local/bin'
alias gdot='cd ~/.dotfiles'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias lg='lazygit'

alias pm='sudo pacman'

alias dota='dotfiles-add'
alias dotu='dotfiles-update'

alias makeb='make clean && bear -- make'
