# dotfiles

### "hey what's that program?"
* **OS:** Manjaro
* **WM:** Awesome
* **Terminal:** [my fork](https://github.com/lawsdontapplytopigs/st) of Luke Smith's build of st
* **Editor:** Vim
* **Browser:** Firefox
* **Launcher:** Piggyprompt (part of the AwesomeWM config)
* **Sidebar:** Trufflebar (part of the AwesomeWM config)

## Before you "install"
***VERY IMPORTANT***  
If you want to use my AwesomeWM config, **set your terminal first**.  

*Here, I'll guide you:*  

1. download the files
2. go to the `awesome/` directory and open up the `keys.lua` file.
3. And somewhere around line 23 you should see the `terminal` variable.
4. Change it to the literal comand that will be run. That will be executed when you press ``mod + ` ``  
Good, now we can continue.  


> "hey why was that so important?"  

Not even the program launcher will run if you don't have the `luafilesystem` package,
so you could potentially just run these files and get locked out and not even be able to
open a terminal 🤡🤡🤡

I don't yet have an install script, so you're pretty much going to have to get
the dependencies yourself like an epic gamer.
If there's a dependency missing please open an issue to let me know!  

### Known dependencies
* `luafilesystem` package for lua : used by the launcher ( [you can install it with luarocks](https://luarocks.org/modules/hisham/luafilesystem) )
* `top` : for cpu usage ( you surely have this )
* `jq` : cli tool for parsing json, used by weather widget
* `pulseaudio` : used by (entire system???) for sound outputting. also used by volume widget
* openweathermap ID : (you need their ID to use their API...) used by weather widget
* `mpd` : Music server application running locally
* mpc: Command line interface to mpd

## Installation
***VERY IMPORTANT***  
If you want to use the awesomewm config, set your terminal first. [here's how](#before-you-"install")

So once you set your terminal and got the dependencies, this is the easiest part:
* Clone the repository
* For the awesome-wm config, compton, fish and ncmpcpp config files:
    * Just put them in `~/.config` (make sure to back up your stuff first!)  
        so in the end your path to the files should look like:  
        ~/.config/awesome  
        ~/.config/compton  
        ~/.config/ncmpcpp  
        ~/.config/fish  
* For the `vim` directory:
    * put all the files from there in your home directory
* The X11 directory

## Keybinds
**I highly encourage you to set your own keybinds.**  
You can do so by modifying the `awesome/keys.lua` file.  

Note: You might have to learn a bit of the [AwesomeWM api](https://awesomewm.org/doc/api/index.html), and some lua.  
( and not to be mean, but if you're hesitant about learning lua or some of the AwesomeWM api, I'm highly uncertain using AwesomeWM is for you )  

Also, these might help:  
[my first awesome config](https://awesomewm.org/doc/api/documentation/07-my-first-awesome.md.html)  
[official default keybindings section](https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html#client_keybindings)

But for very brief navigation:

``mod + ` ``: open terminal  
`mod + shift + Escape`: Close AwesomeWM  
`mod + shift + t`: Restart AwesomeWM  
`mod + q`: go through workspaces, from right to left  
`mod + w`: go through workspaces, from left to right  
`mod + Tab`: focus forward through clients  
`mod + shift + Tab`: focus backwards through clients  
`mod + f`: fullscreen client  
`mod + shift + e`: switch through layouts (floating, tile, etc.)  
`mod + shift + r`: switch through layouts (floating, tile, etc.)  
`mod + [hjkl]`: focus clients by direction  
`mod + [yuio]`: swap/move clients  
`mod + [nm,.]`: resize clients  
`mod + (arrow keys)`: focus clients  
`mod + shift + (arrow keys)`: swap/move clients  
`mod + control + (arrow keys)`: resize clients  

## File structure
So if you do decide to hack on this thing, here's how things are organized:  
(I'll only be describing the things that are not so obvious)
* **awesome**
    * candypaint.lua    ( library for working with hex colors )
    * startup           ( startup programs )
    * rc.lua            ( main config file )
    * keys.lua          ( main global keybindings )
    * **piglets/**          ( my custom widgets )
        * **piggyprompt/**  ( Program launcher )
        * **porkerpanel/**  ( An exit panel )
        * **hogbar/**       ( The bar on top )
        * **trufflequest/** ( The to-do app I didn't get to finish ;;( )
        * **trufflebar/**   ( The bar on the right-hand side )
        * ...bunch_of_widgets.lua... ( These should've been in their own 
                                       directory along with the sidebar on the left.
                                       I just didn't know in the beginning )
        * sidebar.lua   ( the sidebar on the left-hand side )
    * **brickware/**        ( custom widgets library that respects the api of awesome )
        * pigprompt.lua ( bug-fixed and history-less replacement for awful.prompt )
        * **layout/**
            * menu.lua

## About widgets
**The sidebar**  
Well I actually have two:
One is basically a rip off of [elena's](https://github.com/elenapan/dotfiles) sidebar, where I have some stats
about the system.  
You can toggle it with `alt + s`

**The other sidebar**  
The other one is the one on the right, and you can toggle it with `alt + F10`  
*NOTE:*  
This sidebar has a `keygrabber`. It will take control of your keys,
but you can toggle it back away with `alt + F10`.

**About the program launcher ( piggyprompt )**  
If you installed the `luafilesystem` package,
you should be able to pop up the prompt with
`alt + r`

**About the exit screen**  
It doesn't look great, and I considered not even docummenting it.  
Also, the code is absolutely disgusting.  
`mod + F9` to make it show  
Note: you can navigate through it with vim keys


#### TODO
[ ] Properly check for the `luafilesystem` dependency in the `utils.get_files_recursively` function

### License
GPLv2
