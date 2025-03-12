alias dot-local='cd ~/.dotfiles'
alias dot-codespace='cd /workspaces/.codespaces/.persistedshare/dotfiles'

if [ -d .git ]; then
    git config pull.rebase false
fi

transfer() {
    if [ $# -eq 0 ]; then 
        echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;
	return 1;
	fi;
	if tty -s; then file="$1";
    file_name=$(basename "$file");
	if [ ! -e "$file" ];
	then echo "$file: No such file or directory">&2;
	return 1;
	fi;
    DOMAIN=''
    if [ -e ~/.transfer_domain ]; then
        DOMAIN=$(cat ~/.transfer_domain)
    else
        echo "Enter domain (eg: 'files.example.com')"
        read DOMAIN
        echo $DOMAIN > ~/.transfer_domain
    fi
    BASIC_USERNAME=''
    if [ -e ~/.transfer_username ]; then
        BASIC_USERNAME=$(cat ~/.transfer_username)
    else
        echo "Enter basic auth username:"
        read BASIC_USERNAME
        echo $BASIC_USERNAME > ~/.transfer_username
    fi
    PASSWORD=''
    if [ -e ~/.transfer_password ]; then
        PASSWORD=$(cat ~/.transfer_password)
    else
        echo "Enter basic auth password:"
        read -s PASSWORD
        echo $PASSWORD > ~/.transfer_password
    fi

	if [ -d "$file" ];
	then file_name="$file_name.zip",;
	(cd "$file"&&zip -r -q - .)|curl  -u "$BASIC_USERNAME:$PASSWORD" --progress-bar --upload-file "-" "https://$DOMAIN/$file_name"|tee /dev/null,;
	else cat "$file"|curl -u "$BASIC_USERNAME:$PASSWORD" --progress-bar --upload-file "-" "https://$DOMAIN/$file_name"|tee /dev/null;
	fi;
	else file_name=$1;
	curl  -u "$BASIC_USERNAME:$PASSWORD" --progress-bar --upload-file "-" "https://$DOMAIN/$file_name"|tee /dev/null;
	fi;
}

transfer-enc() {
       cat $1 | gpg -ac -o- | curl -X PUT --upload-file "-" https://transfer.sh/$(basename $1)
}


addExt() {
   git add "*.$1"
}

ipaddr() {
    ip=$(curl --silent ifconfig.io)
    echo $ip    
    echo $ip | pbcopy
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

function socat-sendfile() {
    # $1 = file_path
    # $2 = remote_server_with_port
    socat -u FILE:$1 TCP:$2
}

function socat-recvfile() {
    # $1 = port_to_listen_on
    # $2 = output_file_name
    socat -u TCP-LISTEN:$1,reuseaddr OPEN:$2,creat
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

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}

function mcr() {
    dockershellhere mcr.microsoft.com/devcontainers/base
}

function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}

# Search git history for the removal of a given string ($1)
function pickaxe() {
	git log -S $1
}

function brew-installed() {
	 brew leaves | xargs -n1 brew desc
}

json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

json_unescape() {
    echo "$1" | jq '. | fromjson'
}

# Given a URL, follow redirects and print what the final URL is (don't actually fetch)
follow_redirects() {
	curl $1 -s -L -I -o /dev/null -w '%{url_effective}'
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
alias changed="git log --name-only"
alias ducks='du -cks * | sort -rn | head -n 10'
alias epoch='date +%s%3N'
alias git-resign="git rebase --exec 'git commit --amend --no-edit -n -S' -i" # Follow with what you rebase on, (eg: HEAD)
alias git-resign-branch="git-resign HEAD"

alias clear-scrollback="clear && printf '\e[3J'"

# Codespaces
function new-cs () {
   NAME=$(gh api -X POST repos/$1/codespaces -F 'location=WestUs2' -F 'vscs_target=ppe' | jq -r .name)
   echo $NAME
   gh cs ssh -c $NAME
}

function new-cs-cxc () {
   NAME=$(gh api -X POST repos/github/codespaces-service/codespaces -F 'location=WestUs2' -F 'vscs_target=ppe' -F 'machine=largePremiumLinux' | jq -r .name)
   echo $NAME
   gh cs ssh -c $NAME
}

function new-cs-dev-test () {
   NAME=$(gh api -X POST repos/joshspicer/almost-empty/codespaces -F 'location=WestUs2' -F 'vscs_target=development' | jq -r .name)
   echo $NAME
   gh cs ssh -c $NAME
}

# Dev Containers 

function inspect-dev-container-metadata-from-image() {
  docker image inspect "$1" | jq '.[0].Config.Labels."devcontainer.metadata" | fromjson'
}

# Docker
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

alias rm-imgs='docker rmi -f $(docker images -a -q)'
alias rm-containers-force='docker ps -q | xargs docker rm -f'

alias rm-docker-nuclear="rm-containers-force || : && rm-imgs || :  && docker system prune || : && docker builder prune || :"

alias cdnewest='cd $(ls -1tr | tail -n 1)'
alias n='cdnewest'

alias yt-dl='docker run \
                  --rm -i \
                  -e PGID=$(id -g) \
                  -e PUID=$(id -u) \
                  -v "$(pwd)":/workdir:rw \
                  mikenye/youtube-dl'


function grck() {
  # Get a random short word (<= 5 characters) from the system dictionary using sort -R
  local dict=$(grep -E '^[a-z]{1,5}$' /usr/share/dict/words | sort -R) 
  local q=$(echo $dict | tail -n 1)
  local p=$(echo $dict | head -n 1)
  local branch_name="joshspicer/${q}-${p}"

  #echo $branch_name
  git checkout -b "$branch_name"
}

