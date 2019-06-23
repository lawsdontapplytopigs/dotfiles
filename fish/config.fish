# set keyboard to US !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# setxkbmap us
# set alias for lua
alias lua lua5.3
# in elementary os outside-programs are installed in /usr/bin, such as ranger, the file manager.
# since ranger is written in python, python needs to find ranger.
# however python doesn't look in the /usr/bin path by default.
# This is why we do this
set PYTHONPATH /usr/bin

set fish_greeting
set PATH /usr/local/go/bin $PATH
set PATH /usr/local/nodejs/ $PATH
