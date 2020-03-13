#/usr/bin/env bash

eval $(thefuck --alias)


alias ccat="pygmentize -g"
alias gdp="gulp default --production"

alias elastica="bash /home/chris/elasticsearch-1.7.6/bin/elasticsearch"

alias ssh-pastview-live="ssh ec2-user@ec2-54-72-129-74.eu-west-1.compute.amazonaws.com"
alias ssh-pastview-staging="ssh ec2-user@ec2-52-16-167-94.eu-west-1.compute.amazonaws.com"
alias ssh-pastview-elasticsearch="ssh ec2-user@ec2-54-72-129-74.eu-west-1.compute.amazonaws.com"

function ssh-internal
{
  ssh "it@internal$1.internal.townswebarchiving.com"
}


alias ssh-alpha-live="ssh root@alpha.servers.townswebarchiving.com"
alias ssh-bravo-live="ssh root@bravo.servers.townswebarchiving.com -p 222"

function inspire
{
  showerthoughts=$(curl -s --connect-timeout 5 -A '/u/DrDoctor13' \
  'https://www.reddit.com/r/showerthoughts/top.json?sort=top&t=week&limit=100' | \
  python2.7 -c 'import sys, random, json; randnum = random.randint(0,99); response = json.load(sys.stdin)["data"]["children"][randnum]["data"]; print "\n\"" + response["title"] + "\""; print "    -" + response["author"] + "\n";')

  echo $showerthoughts | cowsay | lolcat

}

# Manage VMs
function vm
{
  ( cd ~/workspace/servers/$1 && vagrant $2 )
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

export PATH="$PATH:/usr/local/bin/postman/"

# Bash prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'
PS1=$PS1'\[\033[1;38;5;118m\]\u\[\033[1;00m\]@\[\033[1;38;5;118m\]\h '
PS1=$PS1'\[\033[1;00m\]\w'
PS1=$PS1'\[\033[1;38;5;166m\]$(gitbranch)\[\033[1;00m\] λ \[\033[1;00m\]'
