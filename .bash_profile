#/usr/bin/env bash

# Get Git branch
function git_branch
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Get author of Git branch
function git_author
{
  git reflog show --all | grep $1
}

# Manage VMs
function vm
{
  ( cd ~/workspace/servers/$1 && vagrant $2 )
}

# Additional listing info
function le
{
  while [[ "$#" -gt 0 ]]
  do
    case $1 in
      -f|--find)
        local LOC=${2}
        ;;
      -d|--depth)
        local DEPTH="-maxdepth ${2}"
        ;;
      -l|--list)
        local ARGOPT="-type d -print0"
        local ARGEXEC="| xargs -0 ls -al"
        ;;
      -o|--octal)
        local ARGOPT=""
        local ARGEXEC="-exec stat -c '%a %U %n' '{}' +"
    esac
    shift
  done

  eval "find $LOC $DEPTH $ARGOPT $ARGEXEC"
}

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[38;5;118m\]\u\[\033[01;00m\]@\[\033[38;5;118m\]\h '
PS1=$PS1'\[\033[01;00m\]\W'
PS1=$PS1'\[\033[01;33m\]$(git_branch)\[\033[38;5;202m\] λ \[\033[01;00m\]'
MSYS2_PS1="$PS1"

cd $HOME
