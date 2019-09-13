#/usr/bin/env bash

# Get Git branch
function git_branch
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Manage VMs
function vm
{
  ( cd ~/workspace/servers/$1 && vagrant $2 )
}

# Manage Windows Hosts
function winhosts
{
  HOSTFILE=/c/Windows/System32/drivers/etc/hosts
  while [[ "$#" -gt 0 ]]
  do
    case $1 in
      -c|--create)
        echo "${2}        ${3}" >> ${HOSTFILE}
        ;;
      -v|--view)
        cat ${HOSTFILE} | grep "${2}"
        ;;
      -d|--delete)
        sed -i '/${1}/d' ${HOSTSFILE}
    esac
    shift
  done
}

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[38;5;118m\]\u\[\033[01;00m\]@\[\033[38;5;118m\]\h '
PS1=$PS1'\[\033[01;00m\]\W'
PS1=$PS1'\[\033[01;33m\]$(git_branch)\[\033[38;5;202m\] λ \[\033[01;00m\]'
MSYS2_PS1="$PS1"
