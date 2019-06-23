
# TODO
[ ] Main
    [x] when changing the command, select the first result automatically

    [x] also, set up the right exit points for the function, so that 
        when you press a `modifier`+`key`, if the command doesn't change,
        `changed_callback` doesn't get called

    [x] Implement proper ranking algorithm for found executables
        [x] make it so when you don't have enough matches for the number of rows,
            you can't go up and down past the number of rows available
        [x] if there are more commands by the same name, keep just one
        [x] Everytime you power up the prompt, reset the text in the rows
        [x] Make the `Control + Up` and `Control + Down` do something

    [ ] Uhhhhh make the buttons work???

[ ] Refactoring TODO TODO (I'll do it when I get done with the whole thing)
    [ ] Separate the prompt from the widgets I made
    [ ] Separate the widgets I made and put them into functions
    [ ] put underscores in front of variables that should be private (EDIT: VERY rarely should variables be private, idiot)
    [ ] refactor the `update` functions that make the row selection happen

[ ] Bugs
    [ ] It only happened once, and somehow it went away, but at some point,
        You could make it so pressing `Shift + (letter)` would not give you
        the capital letter. in fact anything beginning with shift and then text
        wouldn't work anymore. Observed on 12 Apr, 2019
    [ ] The pasting in the prompt currently acceses the 'selection' clipboard, 
        which in X i think is the `PRIMARY` clipboard. But the prompt should 
        access the `CLIPBOARD` selection. I don't know if awesome can do this though.
        Found on 12 Apr, 2019
        EDIT: Apparently it can't be done in this version of Awesome, but there are plans
        for implementing it in a future release
