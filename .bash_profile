alias statc="stat -c '%a %G:%U %n'"
eval $(thefuck --alias)

function up
{
    LIMIT=$1
    P=$PWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=$P/..
    done
    cd $P
    export MPWD=$P
}

function back
{
    LIMIT=$1
    P=$MPWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=${P%/..}
    done
    cd $P
    export MPWD=$P
}

function parse_git_branch
{
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function show_git_author
{
    git reflog show --all | grep $1
}

function vm
{
    ( cd ~/boxes/$1 && vagrant $2 )
}

# Override prompt
PS1='\[\033]0;${PWD//[^[:ascii:]]/?}\007\]'                                           # set window title
PS1=$PS1'\[\033[01;32m\]\[\033[01m\033[01;32m\]\u\[\033[01;00m\]@\[\033[01;32m\]\h '  # user @ host
PS1=$PS1'\[\033[01;00m\]\W'                                                           # current working directory
PS1=$PS1'\[\033[01;33m\]$(parse_git_branch)'                                          # git branch
PS1=$PS1'\n\[\033[01;32m\]└─\[\033[01m\033[0;00m\] \$\[\033[00m\] '                   # newline prompt
MSYS2_PS1="$PS1"                                                                      # for detection by MSYS2 SDK's bash.basrc
