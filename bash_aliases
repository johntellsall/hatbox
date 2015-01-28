# -*- shell-script -*-

# :::::::::::::::::::::::::::::::::::::::::::::::::: COMPLETIONS
if [[ "$USER" = 'johnm' ]] ; then
    . `brew --repository`/Library/Contributions/brew_bash_completion.sh
    . /Users/johnm/src/hatbox/shell/django_bash_completion
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
    . /usr/local/etc/bash_completion.d/git-flow-completion.bash
    eval "$(grunt --completion=bash)"
fi
# /usr/local/etc/bash_completion.d/npm

if which ruby > /dev/null ; then
    complete -o default -o nospace -W "$(/usr/bin/env ruby -ne 'puts $_.split(/[,\s]+/)[1..-1].reject{|host| host.match(/\*|\?/)} if $_.match(/^\s*Host\s+/);' < $HOME/.ssh/config)" scp sftp ssh
fi


# :::::::::::::::::::::::::::::::::::::::::::::::::: ENV

if [[ -d ~/src/hatbox/bin ]] ; then
    export PATH=~/src/hatbox/bin:$PATH
fi


# :::::::::::::::::::::::::::::::::::::::::::::::::: ALIASES

alias ap='ack --py'
alias c='commit.py'
alias ls='ls -CF'

alias gb='git branch'
alias gc='git commit'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gd='git diff'
alias gdh='git diff HEAD^'
alias gds='git diff --stat'
alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias gst='git status'

# :::::::::::::::::::::::::::::::::::::::::::::::::: DOCKER ALIASES
#
# see http://www.kartar.net/2014/03/some-useful-docker-bash-functions-and-aliases/
# TODO: docker logs $(docker ps -a | awk '/docker-gen/ {print $1; exit}')

function dent {
docker exec -i -t $1 /bin/bash
}
complete -F _docker_exec dent

# TODO: make work with more/less than single match
function denti {
docker exec -i -t $(docker ps | awk '/'$1'.*Up/ {print $1}') /bin/bash
}
complete -F _docker_exec denti
# TODO: make work with more/less than single match
function dentic {
docker exec -i -t $(docker ps | awk '/'$1'.*Up/ {print $1}') $2 $3 $4 $5
}
complete -F _docker_exec dentic

# run bash for any image
function dbash {
docker run --rm -i -t -e TERM=xterm --entrypoint /bin/bash $1 
}
complete -F _docker_images dbash
alias dps='docker ps'
