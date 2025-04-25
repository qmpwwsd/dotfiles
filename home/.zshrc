export TERM="xterm-256color"
export ZSH="$HOME/.config/zsh"

# Environment
export LANG=en_US.UTF-8
export VISUAL="nvim"
export EDITOR="$VISUAL"
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export AE_DEPLOYMENT_ENV="debug"

export PATH="$PATH:/run/current-system/sw/bin"
export PATH="$PATH:$HOME/.flutter/bin"
export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:$HOME/neovim/bin"
export PATH="$PATH:/opt/homebrew/opt/ruby/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/home/denys/.nvm/versions/node/v23.8.0/bin"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Antigen
source "$ZSH/plugins/antigen.zsh"

antigen bundle git
antigen bundle brew
antigen bundle docker
antigen bundle nvm
antigen bundle node
antigen bundle npm
antigen bundle pnpm
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle Aloxaf/fzf-tab

antigen apply

# Zoxide
eval "$(zoxide init zsh)"
# Atuin
eval "$(atuin init zsh)"
# Theming
eval "$(oh-my-posh init zsh --config $ZSH/themes/tokyonight.omp.toml)"
# Thefuck
eval "$(thefuck --alias)"

# Vim mode
set -o vi
bindkey -v

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Fzf tab configuration
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# for Tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# BAT
export BAT_THEME=tokyonight_night

# FZF 
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200'  "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"                          "$@" ;;
    ssh)          fzf --preview 'dig {}'                                    "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"                 "$@" ;;
  esac
}

source <(fzf --zsh)

# Aliases
alias ls="eza --icons=always"
alias bat="batcat"

alias v="nvim"

alias gst="lazygit"

alias cn="nvim ~/.config/nvim"
alias cz="nvim ~/.config/zsh"

alias visudo="sudo -E visudo"

alias d="ddgr"

alias jl="jless"

alias fk="thefuck"

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

. "$HOME/.atuin/bin/env"
. "$HOME/.local/bin/env"

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/asdf.sh"
fpath=("$HOME/.asdf/completions" $fpath)
autoload -Uz compinit && compinit
