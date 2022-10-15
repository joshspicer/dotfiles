alias dot='cd ~/.dotfiles'

transfer() {
    local file
    declare -a file_array
    file_array=("${@}")

    if [[ "${file_array[@]}" == "" || "${1}" == "--help" || "${1}" == "-h" ]]
    then
        echo "${0} - Upload arbitrary files to \"transfer.sh\"."
        echo ""
        echo "Usage: ${0} [options] [<file>]..."
        echo ""
        echo "OPTIONS:"
        echo "  -h, --help"
        echo "      show this message"
        echo ""
        echo "EXAMPLES:"
        echo "  Upload a single file from the current working directory:"
        echo "      ${0} \"image.img\""
        echo ""
        echo "  Upload multiple files from the current working directory:"
        echo "      ${0} \"image.img\" \"image2.img\""
        echo ""
        echo "  Upload a file from a different directory:"
        echo "      ${0} \"/tmp/some_file\""
        echo ""
        echo "  Upload all files from the current working directory. Be aware of the webserver's rate limiting!:"
        echo "      ${0} *"
        echo ""
        echo "  Upload a single file from the current working directory and filter out the delete token and download link:"
        echo "      ${0} \"image.img\" | awk --field-separator=\": \" '/Delete token:/ { print \$2 } /Download link:/ { print \$2 }'"
        echo ""
        echo "  Show help text from \"transfer.sh\":"
        echo "      curl --request GET \"https://transfer.sh\""
        return 0
    else
        for file in "${file_array[@]}"
        do
            if [[ ! -f "${file}" ]]
            then
                echo -e "\e[01;31m'${file}' could not be found or is not a file.\e[0m" >&2
                return 1
            fi
        done
        unset file
    fi

    local upload_files
    local curl_output
    local awk_output

    du --total --block-size="K" --dereference "${file_array[@]}" >&2
    # be compatible with "bash"
    if [[ "${ZSH_NAME}" == "zsh" ]]
    then
        read $'upload_files?\e[01;31mDo you really want to upload the above files ('"${#file_array[@]}"$') to "transfer.sh"? (Y/n): \e[0m'
    elif [[ "${BASH}" == *"bash"* ]]
    then
        read -p $'\e[01;31mDo you really want to upload the above files ('"${#file_array[@]}"$') to "transfer.sh"? (Y/n): \e[0m' upload_files
    fi

    case "${upload_files:-y}" in
        "y"|"Y")
            # for the sake of the progress bar, execute "curl" for each file.
            # the parameters "--include" and "--form" will suppress the progress bar.
            for file in "${file_array[@]}"
            do
                # show delete link and filter out the delete token from the response header after upload.
                # it is important to save "curl's" "stdout" via a subshell to a variable or redirect it to another command,
                # which just redirects to "stdout" in order to have a sane output afterwards.
                # the progress bar is redirected to "stderr" and is only displayed,
                # if "stdout" is redirected to something; e.g. ">/dev/null", "tee /dev/null" or "| <some_command>".
                # the response header is redirected to "stdout", so redirecting "stdout" to "/dev/null" does not make any sense.
                # redirecting "curl's" "stderr" to "stdout" ("2>&1") will suppress the progress bar.
                curl_output=$(curl --request PUT --progress-bar --dump-header - --upload-file "${file}" "https://transfer.sh/")
                awk_output=$(awk \
                    'gsub("\r", "", $0) && tolower($1) ~ /x-url-delete/ \
                    {
                        delete_link=$2;
                        print "Delete command: curl --request DELETE " "\""delete_link"\"";

                        gsub(".*/", "", delete_link);
                        delete_token=delete_link;
                        print "Delete token: " delete_token;
                    }

                    END{
                        print "Download link: " $0;
                    }' <<< "${curl_output}")

                # return the results via "stdout", "awk" does not do this for some reason.
                echo -e "${awk_output}\n"

                # avoid rate limiting as much as possible; nginx: too many requests.
                if (( ${#file_array[@]} > 4 ))
                then
                    sleep 5
                fi
            done
            ;;

        "n"|"N")
            return 1
            ;;

        *)
            echo -e "\e[01;31mWrong input: '${upload_files}'.\e[0m" >&2
            return 1
    esac
}

transfer-enc() {
	cat $1 | gpg -ac -o- | curl -X PUT --upload-file "-" https://transfer.sh/$(basename $1)
}

addcs() {
   git add "*.cs"
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


function revshell() {
    cd ~/dev/vsclk-core/tools/Powershell/
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
    dockershellhere mcr.microsoft.com/vscode/devcontainers/base:bionic
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

# Docker
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

alias rm-imgs='docker rmi -f $(docker images -a -q)'
alias rm-containers-force='docker ps -q | xargs docker rm -f'

alias rm-docker-nuclear="rm-containers-force || : && rm-imgs || :  && docker system prune || : && docker builder prune || :"

alias cdnewest='cd $(ls -1tr | tail -n 1)'
alias h='cdnewest'

