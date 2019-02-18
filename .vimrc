

" first, clear autocommands
autocmd!



" set syntax highlighting on file opening
:syntax on

" true colors in terminal "

:colorscheme BlackCherriesExperiments
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"  " i actually don't have a clue what this does
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"  " BUT if you modify the semicolons to colons
                                        " in this thing (the way they were by default, 
                                        " it doesn't work anymore

" TIPSanTRIX: cycle through colorschemes in vim:
" write ':colorscheme ' and press [TAB] to cycle through color schemes 


" TOGGLING LINE NUMBERS "
" 'ctrl+n' twice to toggle line numbers on or off "
nmap <C-n><C-n> :set invnumber<CR>
noremap <C-m><C-m> :set invrelativenumber<CR>
" color the line numbers gray. 
" also, when both 'set number' and 'set relativenumber' are set, 
" make the relative number dark yellow
":highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" INDENTATION "
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab




" Commenting/uncommenting code automatically with Shift + Tab"

let s:comment_map = { 
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%',
    \ }




function! ToggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
		if getline('.') =~ '\v^\s*' . comment_leader
            " Uncomment the line
            execute 'silent s/\v\s*\zs' . comment_leader . '\s*\ze//'
        else
            execute 'silent s/\v^(\s*)/\1' . comment_leader . ' /'
        endif
    else
        echo "No comment leader found for filetype"
    endif
endfunction

nnoremap <S-Tab> :call ToggleComment()<cr>
vnoremap <S-Tab> :call ToggleComment()<cr>








