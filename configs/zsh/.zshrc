# Red Team Workstation Bootstrap zsh configuration

export ZSH="${HOME}/.oh-my-zsh"
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-${EDITOR}}"
export PAGER="${PAGER:-less}"
export GOPATH="${HOME}/go"
export PATH="${HOME}/.local/bin:${GOPATH}/bin:${PATH}"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

plugins=(
  git
  sudo
  history
  extract
  colored-man-pages
  docker
  kubectl
  python
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

if [[ -r "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
fi

setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt full-upgrade -y'
alias ll='eza -lah --group-directories-first --icons=auto 2>/dev/null || ls -lah'
alias la='eza -la --group-directories-first --icons=auto 2>/dev/null || ls -la'
alias cat='batcat --paging=never 2>/dev/null || bat --paging=never 2>/dev/null || cat'
alias grep='grep --color=auto'
alias ports='ss -tulpen'
alias myip='curl -fsSL https://ifconfig.me && echo'
alias serve='python3 -m http.server'
alias pythonserver='python3 -m http.server 8000'
alias dns='dig +short'
alias listen='sudo lsof -i -P -n | grep LISTEN'
alias weather='curl wttr.in'
alias path='echo -e ${PATH//:/\\n}'
alias please='sudo $(fc -ln -1)'

extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: file not found: $1" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "extract: unsupported archive: $1" >&2; return 1 ;;
  esac
}

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if command -v starship >/dev/null 2>&1 && [[ ! -r "${ZSH}/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  eval "$(starship init zsh)"
fi

[[ -r "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
