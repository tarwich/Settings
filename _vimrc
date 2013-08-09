" VIM Settings for Sam


"  __________________________________________________ 
" / Vundle                                           \ {{{

" Setup Vundle:
"  $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/Dropbox/Vim/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Install Fuzzy Finder
Bundle 'L9'
Bundle 'FuzzyFinder'

" Install NERD Commenter
Bundle 'The-NERD-Commenter'

" \__________________________________________________/ }}} 

"  __________________________________________________
" / NERDTree                                         \ {{{ 

Bundle 'The-NERD-Tree'

" \__________________________________________________/ }}}

"  __________________________________________________
" / VTreeExplorer                                    \ {{{ 

" No settings as of yet

" \__________________________________________________/ }}}

"  __________________________________________________
" / Align plugin                                     \ {{{

" I actually don't know what these commands do, I 
" just put them in here because I was following 
" instructions
:set nocp
:filetype plugin on
" Load align plugin
Bundle 'Align'

" \__________________________________________________/ }}}

"  __________________________________________________
" / General Settings                                 \ {{{ 

" Ignore case in searches
:set ignorecase

" Move the swp files to personal directory
if !isdirectory($HOME . '/.swp') 
	:call mkdir($HOME . '/.swp')
:endif
:set backupdir=~/.swp
:set directory=~/.swp

" Disable the toolbar
:set guioptions-=T

" My font
:set guifont=Courier_New
":h8:cANSI

" Highlite the current line
:set cursorline
:highlight CursorLine guibg=#DDFFDD

" Automatically save files when executing make
:set autowrite

" Turn off Eclim
:let g:EclimMakeLCD=0

" \__________________________________________________/ }}}

"  __________________________________________________
" / Code cleanliness                                 \ {{{

" Turn on syntax highlighting
:filetype plugin on
:syntax enable

" Highlite search results
:set hlsearch
:highlight Search guibg=#E8E8FF

" Don't extend comments on newline
:au FileType * setl fo-=cro

" Tab spaces 
:set tabstop=4
	" This line is indented <num> spaces
:set shiftwidth=4
:set autoindent

" Set line numbering
:set number

" Set right-margin
" :highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
" :match OverLength /\%81v.\+/

" Allow folding
:set foldmethod=marker

" Disable wrapping by default
:set nowrap
:set textwidth=0
:let g:leave_my_textwidth_alone = 1

" Configure Vim to move the cursor to the end of the
" previous line, when the left arrow key is pressed 
" and the cursor is currently at the beginning of a 
" line
:set whichwrap+=<>[]

" Load Solarized bundle
Bundle 'Solarized'
" Set color scheme to Solarized
:set background=dark
:colorscheme solarized
" Load php bundle
Bundle 'php'
Bundle 'php.vim'

" \__________________________________________________/ }}}

"  __________________________________________________
" / Hotkeys                                          \ {{{

" CTRL+w is killing me
inoremap <C-w> <C-o>:echo "DO NOT PRESS THAT KEY!!!"<CR>
cnoremap <C-w> <Esc>:echo "DO NOT PRESS THAT KEY!!!"<CR>

" Backspace key
:set bs=2

" Map CTRL-S to save
nnoremap <C-s> :write<CR>
cnoremap <C-s> <Esc>:write<CR>
inoremap <C-s> <Esc>:write<CR>a

" Map CTRL-Z to undo
nnoremap <C-z> :undo<CR>
cnoremap <C-z> <Esc>:undo<CR>
inoremap <C-z> <Esc>:undo<CR>a

" Map CTRL+Backspace to delete word (backward)
inoremap <C-BS> <C-w>
cnoremap <C-BS> <C-w>
inoremap <M-BS> <C-w>
cnoremap <M-BS> <C-w>

" Map CTRL+Space to word completion
inoremap <C-Space> <C-n>

" Map CTRL+Delete to delete word (forward)
inoremap <C-Del> <C-o>dw
inoremap <M-Del> <C-o>dw

" Map SHIFT+arrows to extend selection
" - Up
nnoremap <S-Up> v<Up>
inoremap <S-Up> <C-o>v<Up><Right>
vnoremap <S-Up> <Up>
" - Down
nnoremap <S-Down> v<Down>
inoremap <S-Down> <C-o>v<Down>
vnoremap <S-Down> <Down>
" - Right
nnoremap <S-Right> v
inoremap <S-Right> <C-o>v
vnoremap <S-Right> <Right>
vnoremap <Right> <Esc><Right>
" - Left
nnoremap <S-Left> v<Left>
inoremap <S-Left> <C-o>v
vnoremap <S-Left> <Left>
vnoremap <Left> <Esc><Left>
" Map SHIFT+CTRL+arrows to extend selection
inoremap <CS-Right> <C-o>v<C-Right>
inoremap <CS-Left> <C-o>v<C-Left>

" Map SHIFT+HOME,END
" - Home
nnoremap <S-Home> v<Home>
inoremap <S-Home> <C-o>v<Home>
" - End
nnoremap <S-End> v<End>
inoremap <S-End> <C-o>v<End>

" Copy and paste
" - Ctrl+INS = Copy
vnoremap <C-Ins> y
" - Shift+INS = Paste
vnoremap <S-Ins> <Esc><Esc>p
nnoremap <S-Ins> p
inoremap <S-Ins> <Left><C-o>p

" Map <F8> to make
nnoremap <F8> :make<CR>
inoremap <F8> <ESC>:make<CR>

" Map <F5> to make run
nnoremap <F5> :wa<CR>:!make run<CR>
inoremap <F5> <ESC>:wa<CR><C-o>:!make run<CR>

" Map ^L to clear search
nnoremap <C-l> :let @/ = ""<CR>
inoremap <C-l> <C-o>:let @/ = ""<CR>
vnoremap <C-l> :let @/ = ""<CR>

" Map D-J to join
vnoremap <D-j> :join<CR>

" \__________________________________________________/ }}}

"  __________________________________________________ 
" / Eclipse Keybindings                              \ {{{

" Map SHIFT+CR to END,CR
nnoremap <S-CR> o
inoremap <S-CR> <C-o>o
vnoremap <S-CR> <Esc><Esc>o
nnoremap <CS-CR> O
inoremap <CS-CR> <C-o>O
vnoremap <CS-CR> <Esc><Esc>O
" Map C-D to delete line
nnoremap <C-d> dd
inoremap <C-d> <C-o>dd
vnoremap <C-d> :delete<CR>
nnoremap <D-d> dd
inoremap <D-d> <C-o>dd
vnoremap <D-d> :delete<CR>
"" Map M-Down to move line
nnoremap <M-DOWN> :move +1<CR>
nnoremap <M-UP> :move -2<CR>
inoremap <M-DOWN> <C-o>:move +1<CR>
inoremap <M-UP> <C-o>:move -2<CR>
vnoremap <M-DOWN> :move '>+1<CR>gv
vnoremap <M-UP> :move -2<CR>gv
" Map CM-Down to clone line
nnoremap <CM-DOWN> :copy +0<CR>
nnoremap <CM-UP> :copy -1<CR>
inoremap <CM-DOWN> <C-o>:copy +0<CR>
inoremap <CM-UP> <C-o>:copy -1<CR>
vnoremap <CM-DOWN> :copy '>+0<CR>gv
vnoremap <CM-UP> :copy -1<CR>gv
" Map CMD+/ to toggle line comment(s) (Plugin: The-NERD-Commenter)
nnoremap <D-/> :call NERDComment(0, "toggle")<CR>
vnoremap <D-/> :call NERDComment(0, "toggle")<CR>
inoremap <D-/> <C-o>:call NERDComment(0, "toggle")<CR>

"  __________________________________
" /---------- Fuzzy Finder ----------\ "{{{

	inoremap <F3> <ESC>:FufFile **/*<CR>
	nnoremap <F3> :FufFile **/*<CR>
	vnoremap <F3> :FufFile **/*<CR>
	cnoremap <F3> <C-u>FufFile **/*<CR>

	inoremap <F4> <ESC>:FufLine function{;<CR>
	nnoremap <F4> :FufLine function{;<CR>
	vnoremap <F4> :FufLine function{;<CR>
	cnoremap <F4> <C-u>:FufLine function{;<CR>
" \__________________________________/"}}}

" \__________________________________________________/ }}}

"  __________________________________________________ 
" / File Types                                       \ {{{

" *
au FileType * set formatoptions-=ro

" C#
au FileType cs set errorformat=\ %#%f(%l\\\,%c):\ error\ CS%n:\ %m
au FileType cs match OverLength //  " Disable the long line highlight 

" haXe
au BufRead,BufNew *.hx set filetype=haxe

" \__________________________________________________/ }}} 

"  __________________________________________________ 
" / UltiSnips                                        \ {{{

" Tell UltiSnips to edit configuration file in a split window
let g:UltiSnipsEditSplit           = 'vertical'
let g:UltiSnipsExpandTrigger       = '<tab>'
let g:UltiSnipsListSnippets        = '<c-j>'
let g:UltiSnipsJumpForwardTrigger  = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" Load UltiSnips
Bundle 'UltiSnips'

" \__________________________________________________/ }}} 

