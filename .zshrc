export ZSH="/Users/josh/.oh-my-zsh"

# zsh
ZSH_THEME="robbyrussell"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=20
plugins=(git git-open)
source $ZSH/oh-my-zsh.sh

alias cls="clear"

addcs() {
   git add "*.cs"
}

yankcommit() {
   git rebase -p --onto $1^ $1
}

pbcat() {
    cat $1 | pbcopy
}

alias gs="git status"
alias gd="git diff"
alias difffiles="git diff master HEAD  --compact-summary"
alias gpb='git push origin $(git branch --show-current)'
alias githash="git rev-parse --short HEAD"
alias plz='sudo $(fc -ln -1)'
alias gpullb='git pull origin $(git branch --show-current)' 
alias gitscrub='git clean -xdf'
alias git-repair-gitignore="git rm --cached `git ls-files -i --exclude-from=.gitignore`"

export PATH="/Users/josh/Library/Android/sdk/platform-tools:/Users/josh/Documents/flutter/bin:/usr/local/opt/ruby/bin:$PATH"
export THEOS=~/theos
