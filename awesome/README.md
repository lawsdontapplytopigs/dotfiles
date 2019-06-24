# My awesome window manager config

## TODO
    <!--- 
    i still want the widgets from the wibar, but I don't like the wibar
    that's why I'll have to implement the widgets in some other way,
    before I can take the wibar out completely
    EDIT: I'll first try to make it look good and then maybe I won't take it out
    -->
    [ ] Redesign or remove the wibar
        [x] Clock widget
        [x] Taglist widget
        [ ] Networking widget
        [ ] Bluetooth widget
        [x] Exit widget
        [x] Layout widget
        [ ] Make it change appearance based on what color the background is

    [ ] Sidebar
        [x] Clock widget
        [x] Cpu widget
        [x] Ram widget
        [x] Audio widget
        [x] Weather widget
        [x] Mpd client widget
        [x] Temperature widget
        [ ] Diskspace widget
        [ ] Search widget
        [ ] Exit widget
        [ ] Fill the bottom part up with something (its pretty barebones right now)

    [x] Exit screen

    [x] Titlebars
        [x] Change the current button icons with round ones

    [x] Write some sort of scheduling wiget

    [ ] Clients
        [x] have each client show the same types of thin shlick borders that mac os has

    [ ] Client-managing bar (called tasklist in awesome)

    [ ] Notifications

    [ ] Menus (Have a menu with settings particular settings for most widgets)
        [ ] The hogbar
        [ ] The desktop files

    [ ] General
        [x] Clean up keybindings and implement additional ones
        [ ] Create 'muted' icon for the sidebar volume bar 
        [ ] Create a fire icon that's actually the color of the temperature bar
        [x] Make it so when you click an actual client window, that client gets focus
        [ ] Make it so when you press 'mod + shift + [qw]` the client will get sent
            to the previous tag or the next one, respectively
        [ ] Replace current cpu-indicator heart icon with a light bulb
        [ ] Change theme variables of the "aero-snap"-like feature implemented in awesome

    [ ] Cleaning up (setting theme colors universally, setting proper icons, etc)
        [ ] Making global variables that should be local local (most of them are done)
        [ ] Put the weather file somewhere in my awesome config files.
            It makes more sense for it to be there, instead of my home directory.
        [ ] Go back in the exitpanel and rename all of the stupidly named icons used there,
            along with the (few) stupidly named variable names used there

    [ ] Maybe (Things I'm not sure I'll implement)
        [ ] Write some sort of mpd frontend
        [ ] Write some sort of settings widget
        [ ] Hotplugging: automatically mounting devices when they get plugged in

    [ ] Refactoring
        [x] Piggyprompt
            [ ] Make it so when you type in too much text, the textbox scrolls
                along with where the cursor is
            [ ] Add a rectangular background behind the widget and make the
                background transparent so you get anti-aliased rounded corners
            [x] Fuck it, rewrite the whole thing
        [ ] Reimplement the way widget spacing for the sidebar works. At the moment it's
            an extemely hacky way of doing it, based on textboxes with
            a font that has the size '2'

    [ ] Bugs
        [ ] When the mpc client on the sidebar is stopped, nothing is shown as the song. fix that
        [ ] Make sidebar weather widget get data when the pc is first powered up too
        [ ] Sometimes(a lot of times, acutally, if you have a window maximized,
            after rebooting the pc, if you start that program again, 
            it starts maximized and occupies a half of the wibar
        [ ] Make the text in the titlebars discontinue at some point with 
            three dots at the end so it doensn't wrap and do weird stuff
        [ ] Set window minimum resizing values so the buttons never get resized
        [ ] Set a forced resize on sidebar weather widget icons, 
            and the preffered size along with it
        [ ] After suspending and resuming the pc, the audio controls do some sketchy
            things like uhhHHH not work anymore??? You have to restart awesome to
            continue to use them so I'll have to fix this.
        [ ] Sometimes, it seems that the exitscreen doesn't show up. I don't
            really know why.
        [ ] When testing with `Xephyr`, sometimes the audio bar from the
            bottom-right side doesn't work anymore. It just stops redrawing itself.

    [ ] Unorganized




