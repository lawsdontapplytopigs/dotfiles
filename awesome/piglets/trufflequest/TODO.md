
Here I'll just mark down everything that I know I need to do regarding the app.

[ ] ESSENTIAL
    [ ] make the file system operations on tasks possible
    [ ] make going from day to day possible
    [ ] Make it so when you go in the future to edit (or add) tasks, the tasks for
        those days get created only if you actually change something. We don't want
        to bloat up our file system too much for nothing
    [ ] if you mark tasks as done, make them change in some sort of way so that
        you can still edit or "unmark" them right there in the trufflebar
    [ ] Add priority property to tasks that get saved in the filebase
    [ ] When displaying tasks, order the tasks according to this priority scheme:
        [ ] Split in two: done or not
            > the not done tasks are at the top, 
            > the done tasks are at the top.

        [ ] In each of the groups, split again: bound by time or not
            > tasks that are bound by time are at the top
            > tasks that are not bound by time are at the bottom

        [ ] then, if bound by time, they get ordered according to the time
        [ ] if not bound by time, they get ordered according to their 
            "priority ranking"

[ ] Refactor
    [ ] In the `make_trufflebar` function (last checked in the file 
        `trufflequest.trufflebar.make_trufflebar`, refactor the
        height variables that are hardcoded
