# dotfiles

### Tasklist

  So there's still a lot to do, but currently these are roughly the things 
  that I'm trying to implement. The ones (mostly) completed will have a
  ' x ' in the checkbox

    [x]  Terminal configuration
    [x]  Good colorscheme and overall consistent "theme"
    [ ]  Configure awesome-wm
    [ ]  Configure plank
    [ ]  Other trivial functionality through the 'alt' modifier
    [ ]  Anti-aliased rounded corners af
    [ ]  Custom mpv frontend
    [x]  ncmpcpp (nincompoop) configuration
    [ ]  Youtube-to-mp3 with a keybind [1] [2]
    [ ]  Clean things up
        [ ] Change the name of the timer global variable in `volumectl`

[1]: https://stackoverflow.com/questions/46079716/firefox-webextension-api-how-to-get-the-url-of-the-active-tab
[2]: https://stackoverflow.com/questions/41940986/get-tab-url-from-page-action-webextensions-android

### Known dependencies
* `luafilesystem` rock(package) for lua : used by the launcher
* `top` : for cpu usage
* `jq` : cli tool for parsing json, used by weather widget
* `pulseaudio` : used by (entire system???) for sound outputting. also used by volume widget
* openweathermap ID : (you need their ID to use their API...) used by weather widget
* `xclip` : utility to access X clipboards. Used by porkerprompt.
