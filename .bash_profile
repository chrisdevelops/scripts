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

# Manage Windows Hosts
function hosts
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

# Manage projects
function manage-project
{
  cd ~/workspace/projects/
  while [[ "$#" -gt 0 ]]
  do
    case $1 in
      -c|--create)
        mkdir ${2}
        cd ${2}
        ;;
      -g|--get)
        cd ${2}
        ;;
      -v|--view)
        ls -al ${2}
        ;;
      -d|--delete)
        rm -rf ~/workspace/projects/${2}
    esac
    shift
  done
}

# Manage bash config
function manage-config
{
  while [[ "$#" -gt 0 ]]
  do
    case $1 in
      -e|--edit)
        nano ~/.bash_profile
        ;;
      -r|--reload)
        source ~/.bash_profile
        ;;
      -v|--view)
        cat ~/.bash_profile | grep "${2}"
    esac
    shift
  done
}
alias mc="manage-config"
alias mp="manage-project"

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[38;5;118m\]\u\[\033[01;00m\]@\[\033[38;5;118m\]\h '
PS1=$PS1'\[\033[01;00m\]\W'
PS1=$PS1'\[\033[01;33m\]$(git_branch)\[\033[38;5;202m\] λ \[\033[01;00m\]'
MSYS2_PS1="$PS1"

PATH=$PATH:/c/"Program Files"/nodejs

cd $HOME
