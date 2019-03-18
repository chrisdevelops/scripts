#/usr/bin/env bash

alias statc="stat -c '%a %G:%U %n'"

function git_branch
{
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function git_author
{
    git reflog show --all | grep $1
}

function vm
{
    ( cd ~/workspace/servers $1 && vagrant $2 )
}

PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[38;5;118m\]\u\[\033[01;00m\]@\[\033[38;5;118m\]\h '
PS1=$PS1'\[\033[01;00m\]\W'
PS1=$PS1'\[\033[01;33m\]$(git_branch)\[\033[38;5;202m\] λ \[\033[01;00m\]'
MSYS2_PS1="$PS1"
