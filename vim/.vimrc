

" first, clear autocommands
autocmd!

" VIM-PLUG EXAMPLE

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" call plug#begin('~/.vim/plugged')
" 
" Make sure you use single quotes
" 
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'
" 
" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" 
" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" 
" On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" 
" Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
" 
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }
" 
" Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
" 
" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" 
" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'
" 
" Initialize plugin system
" call plug#end()
" 
" Reload .vimrc and :PlugInstall to install plugins.


"setup vim-plug
call plug#begin('~/.vim/plugins')
"section for plugins
"at least this vimplug thing helps keep things organized
Plug 'lilydjwg/colorizer'
Plug 'junegunn/goyo.vim'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'haishanh/night-owl.vim'
call plug#end()


" set syntax highlighting on file opening
:syntax on
" TIPSanTRIX: cycle through colorschemes in vim:
" write ':colorscheme ' and press [TAB] to cycle through color schemes 

" set colorscheme and true colors in vim "
:colorscheme electric_metal
set termguicolors
" i actually don't have a clue what this does
" BUT if you modify the semicolons to colons
" in this thing (the way they were by default, 
" it doesn't work anymore. these still have to do
" with enabling true colors in vim in the terminal
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"  
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"  

" Configure Goyo "
let goyo_width = 140
let goyo_height = '85%'
nnoremap <S-y><S-y> :Goyo <CR>

" TOGGLING LINE NUMBERS "
" 'ctrl+n' twice to toggle line numbers on or off "
nmap <C-n><C-n> :set invnumber<CR>
noremap <C-m><C-m> :set invrelativenumber<CR>

" color the line numbers gray. 
" also, when both 'set number' and 'set relativenumber' are set, 
" make the relative number dark yellow

" INDENTATION "
filetype plugin indent off
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

autocmd FileType lua setlocal commentstring=\--%s
autocmd FileType vim setlocal commentstring=\"%s
autocmd FileType c, cpp, java, scala setlocal commentstring=\//%s
autocmd FileType sh, ruby, python setlocal commentstring=\#%s
autocmd FileType conf, fstab setlocal commentstring=\#%s
autocmd FileType tex setlocal commentstring=\%%s
autocmd FileType mail setlocal commentstring=\>%s

nnoremap <S-Tab> :Commentary<cr>
vnoremap <S-Tab> :Commentary<cr>


let g:indentLine_fileTypeExclude = ['md']
let g:indentLine_fileTypeExclude = ['markdown']
set conceallevel=0

set laststatus=2

let g:lightline = {
    \ 'colorscheme': 'black_cherries',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ }


