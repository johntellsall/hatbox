# -*- shell-script -*-

# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#     . $(brew --prefix)/etc/bash_completion
# fi

export PATH=${PATH}":${HOME}/.gem/ruby/2.0.0/bin"

if command -v boot2docker >& /dev/null ; then
    $(boot2docker shellinit) 2> /dev/null
fi

. ~/.bash_aliases

# export PS1='\h:\W \u\$ ' => 'new-host-14:theblacktux johnm$ '
export PS1='\W\$ '

# infinite timestamped history
export HISTTIMEFORMAT='%F %T '
export HISTSIZE=''

export WORKON_HOME=~/Envs

[[ -d ~/src/theblacktux/ ]] && cd ~/src/theblacktux/
