#!/bin/bash

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'


alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# Some shortcuts for different directory listings
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ls='ls -hF'
alias ll='ls -l'
alias lla='ls -la'
alias remover='rm -rf'   #Remover deletes without prompt recurssively.
alias rmrf='rm -rf'

export EDITOR=vim

# Some more shortcuts for different directory listings
alias ll='ls -l'                               # long list
alias la='ls -lAhf --color=tty'                # all but . and ..
alias lla='ls -la'

LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

alias mysql='docker exec -it php-developer mysql -uroot -ppassword'

alias gitdiff='git diff --diff-cmd diffmerge > /dev/null"
