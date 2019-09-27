#/usr/bin/env bash

# Manage VMs
function vm
{
  ( cd ~/workspace/servers/$1 && vagrant $2 )
}

# Manage projects
function projects
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

function count {
  total=$1
  for ((i=total; i>0; i--));
    do
      sleep 1;
      printf "Time remaining $i secs \r";
    done
  echo -e "\a"
}

function up {
  lvl=$1
  while [ "$lvl" -gt "0" ]; do
    cd ..
    lvl=$(($lvl - 1))
  done
}

function extract {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xvjf $1;;
      *.tar.gz)    tar xvzf $1;;
      *.tar.xz)    tar Jxvf $1;;
      *.bz2)       bunzip2 $1;;
      *.rar)       rar x $1;;
      *.gz)        gunzip $1;;
      *.tar)       tar xvf $1;;
      *.tbz2)      tar xvjf $1;;
      *.tgz)       tar xvzf $1;;
      *.zip)       unzip -d `echo $1 | sed 's/\(.*\)\.zip/\1/'` $1;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1;;
      *)           echo "cannot extract '$1'";;
    esac
  else
    echo "'$1' does not exist"
  fi
}

function gitbranch
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[38;5;118m\]\u\[\033[01;00m\]@\[\033[38;5;118m\]\h '
PS1=$PS1'\[\033[01;00m\]\w'
PS1=$PS1'\[\033[01;33m\]$(gitbranch)\[\033[38;5;202m\] λ \[\033[01;00m\]'
