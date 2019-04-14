
local package = {
    -- there are some things done in this function that makes the prompt work ok.
    -- Just giving the importer this function will not be as flexible, but 
    -- what else would you want to do with a prompt except running it?
    launch = require("piglets.piggyprompt.piggyprompt").launch 
}
return package
