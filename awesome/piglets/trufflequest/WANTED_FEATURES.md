
Just so I don't forget why of them, or just so it's easier for me to know what
to do next with the development of this app, I'll jot down the features I want
(or at least I think I want) here. Also, maybe there'll be some other stuff here too.

## General
[ ] Undo:
    [ ] you open up the panel, you mark certain tasks as done, and then
        while the panel is still open, you can still undo the tasks you
        then marked as done. Once you close the panel, the tasks are marked
        as done for good.
[ ] Have the ability to add tasks on the spot
[ ] Have the ability to switch between time-bound mode into time-less mode 
    on the spot
[ ] Add the ability to drag tasks around with the mouse
[ ] Have the data be written to the database WHEN you close the bar 
    (or when you write the command ":w")

## Keyboard support
[ ] Vim Functionality
    [ ] "Cut" a row with "dd"
    [ ] "paste" a row with "p"
    [ ] "visual select" multiple rows with v and V
    [ ] "w", "b" and "e" for (((((uhhhhh??)))))
    [ ] Should I add "q" command-recording support?? (In the first implementation sure as hell not but maybe later)
    [ ] "j" and "k" for going up and down the rows (of course)
    [ ] "h" and "l" for going to previous day and next day, respectively
    [ ] "i" for ((( I'm really not sure yet )))
    [ ] "u" to undo changes, that have been made from the moment the bar was open,
        until the bar was closed. After closing, you can't undo stuff. (or should you be able to?? not sure)
    [ ] "/" to search for a task (or maybe hour too)
    [ ] "N" and "n" to look for the previous and next occurence of the pattern 
        written in "/", respectively
    [ ] ":" for commands TODO: I'll have to documment commands 
        (but first settle on what the commands will be)
    [ ] "c" for ???
    [ ] "x" for ??
    [ ] "gg" to go at the top of the rows
    [ ] "G" to go at the bottom of the rows
    [ ] "H" to go to the top-most task of the ones that are visible
    [ ] "L" to go to the bottom-most task of the ones that are visible
    [ ] "o" to add a new task, below the one currently selected
    [ ] "O" to add a new task, above the one currently selected
    [ ] number support (so you can perform actions `number` times automatically)
        e.g. "3dd" would delete the currently selected row, and the next two below it

## Mysteries
    [ ] what the frikk should "i" do?????
    [ ] How should the tasks be postponed exactly? Should all tasks ( after the 
        hour of the selected task ) be set back by the same amount or should only 
        the one modified be postponed? So many questions...

## To consider
[ ] If I am to store data in a database, how will changing things on the spot
    affect how I store the data?
[ ] Will the tasks automatically "flush" once the day is done? Also, when is
    a day "done"? Is it at midnight? Is it when I go to sleep?
[ ] What will I do when it comes to a calendar? I should have the app also
    track my to-do activities or events, not just habits.
[ ] What about going back to the tasks of the previous day? If I did that, it'd
    be pretty easy to also figure out when to "flush" tasks that aren't marked
    as done. I'd also need a calendar for this.
[ ] What kind of buttons should each task have?
    [ ] Postpone
    [ ] Cancel
    [ ] Done
[ ] What kind of data am I going to collect exactly?
[ ] Each of the three main actions of tasks ( postpone, delete, done ) should
    not require that you first go into some sort of "insert" mode. You should
    be able to do those things from "normal" mode.

## Unorganized
[ ] When you open up the bar, have it always show your current day
[ ] Make sure I don't add something stupid like the ability to go *forward* to 
    "tomorrow" or beyond

