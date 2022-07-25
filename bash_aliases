export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export EDITOR=/usr/bin/vim

alias rot13="tr a-zA-Z n-za-mN-ZA-M"
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation

alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias which='type -all'                     # which: Find executables
alias show_options='shopt'                  # Show_options: display bash options and settings
alias fix_stty='stty sane;'                 # fix_stty: Restore terminal settings when screwed up
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd: Makes new Dir and jumps inside
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--    +++/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias NetworkMiner='mono /opt/NetworkMiner_1-6-1/NetworkMiner.exe'

function cd {
    builtin cd "$@" && ls -F
}

#reload your profile with " source ~/.profile "
