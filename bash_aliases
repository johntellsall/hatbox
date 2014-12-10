# -*- shell-script -*-

# :::::::::::::::::::::::::::::::::::::::::::::::::: COMPLETIONS
. `brew --repository`/Library/Contributions/brew_bash_completion.sh
. /Users/johnm/src/hatbox/shell/django_bash_completion
. /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
. /usr/local/etc/bash_completion.d/git-flow-completion.bash
eval "$(grunt --completion=bash)"
# /usr/local/etc/bash_completion.d/npm

complete -o default -o nospace -W "$(/usr/bin/env ruby -ne 'puts $_.split(/[,\s]+/)[1..-1].reject{|host| host.match(/\*|\?/)} if $_.match(/^\s*Host\s+/);' < $HOME/.ssh/config)" scp sftp ssh


# :::::::::::::::::::::::::::::::::::::::::::::::::: ENV

export PATH=~/src/hatbox/bin:$PATH


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

