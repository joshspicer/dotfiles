
#export PS1="%m: %B%~%b $ "

# Source shared alias
. ~/.bash_aliases

export GPG_TTY=$(tty)


# -- prompt --

# --- Enable substitution in prompts ---
setopt prompt_subst

# --- Config ---
GIT_INFO_EXCLUDE_SUBSTRING="electron"

# --- Prompt Components ---
short_pwd() {
  local dir=${PWD/#$HOME/~}
  local parts=(${(s:/:)dir})
  local count=${#parts[@]}
  if (( count <= 2 )); then
    echo "$dir"
  else
    echo "…/${parts[-2]}/${parts[-1]}"
  fi
}

git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  echo " $branch"
}

show_venv() {
  [[ -n "$VIRTUAL_ENV" ]] && echo "(`basename \"$VIRTUAL_ENV\"`)"
}

# --- Helper to check if we're in an excluded path ---
should_show_git_info() {
  [[ "$PWD" != *"$GIT_INFO_EXCLUDE_SUBSTRING"* ]]
}

# --- PROMPT and RPROMPT ---
PROMPT='%F{green}$(show_venv)%f %F{blue}$(short_pwd)%f %# '
# PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '

RPROMPT='$(should_show_git_info && echo "%F{yellow}$(git_branch)%f")'


## -- end prompt --

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=/opt/homebrew/bin:/Users/jospicer/.yarn/bin:/Users/jospicer/.config/yarn/global/node_modules/.bin:/Users/jospicer/.yarn/bin:/Users/jospicer/.config/yarn/global/node_modules/.bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Applications/iTerm.app/Contents/Resources/utilities

. $HOME/.cargo/env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
