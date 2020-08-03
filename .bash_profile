#/usr/bin/env bash

function inspire
{
  showerthoughts=$(curl -s --connect-timeout 5 -A '/u/' \
  'https://www.reddit.com/r/showerthoughts/top.json?sort=top&t=week&limit=100' | \
  python3 -c 'import sys, random, json; randnum = random.randint(0,99); response = json.load(sys.stdin)["data"]["children"][randnum]["data"]; print("\n\"" + response["title"] + "\""); print("    -" + response["author"] + "\n");')

  echo $showerthoughts | cowsay | lolcat
}


function vm
{
  ( cd ~/workspace/servers/$1 && vagrant $2 )
}

function initvw
{
  export WORKON_HOME=~/.virtualenvs
  VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3.6'
  source /usr/local/bin/virtualenvwrapper.sh
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

PATH="$PATH:/home/chris/.local/bin"
PATH="$PATH:/home/chris/.config/composer/vendor/bin"

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[1;38;5;117m\]\u\[\033[1;00m\]@\[\033[1;38;5;117m\]\h '
PS1=$PS1'\[\033[1;00m\]\w'
PS1=$PS1'\[\033[1;38;5;218m\]$(gitbranch)\[\033[1;38;5;166m\] λ \[\033[1;00m\]'

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux
#fi

eval $(thefuck --alias)
