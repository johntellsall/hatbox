# -*- shell-script -*-

source `brew --repository`/Library/Contributions/brew_bash_completion.sh
eval "$(grunt --completion=bash)"
#. /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
# /usr/local/etc/bash_completion.d/npm

export PATH=~/src/hatbox/bin:$PATH

alias ap='ack --py'
alias c='commit.py'
alias ls='ls -CF'

alias gb='git branch'
alias gc='git commit'
alias gcb='git checkout -b'
alias gcm='git commit -am'
alias gd='git diff'
alias gdh='git diff HEAD^'
alias gds='git diff --stat'
alias gst='git status'

