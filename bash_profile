# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#     . $(brew --prefix)/etc/bash_completion
# fi

# XX pgrep something -- $(boot2docker shellinit)
$(boot2docker shellinit)

. ~/.bash_aliases

# export PS1='\h:\W \u\$ ' => 'new-host-14:theblacktux johnm$ '
export PS1='\W\$ '
