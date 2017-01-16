" =======================
" Zaid's Config
" =======================

set nocompatible                                             " vim not vi
set encoding=utf-8
set spelllang=en_gb

" Call on Vundle packages from an external file
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Allow pasting
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  else
    return ''
  endif
endfunction

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Appearance and colours
colorscheme gruvbox                                          " Favourites: gruvbox, sourcerer, hybrid
set background=dark
set t_Co=256
set term=screen-256color

" My vim settings
set shell=$SHELL                                             " Default shell is ZSH
set noswapfile                                               " Don't create .swp files
set nobackup                                                 " Don't create <file>~ backup files
set showmatch                                                " Flashes matching brackets or parentheses
set history=50                                               " Just remember last 50 commands
set laststatus=2                                             " Always display the status line
set ruler                                                    " Show the cursor position all the time
set scrolloff=7                                              " Keep 7 lines at the top or bottom displayed while scrolling
set foldcolumn=0
set autoread                                                 " Refresh any unchanged files
set number                                                   " Show line numbers
set relativenumber                                           " Show relative line numbers
set showcmd                                                  " Display incomplete commands
set ignorecase                                               " Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase
set cursorline                                               " Highlight current cursor line
set backspace=2                                              " Backspace deletes like most programs in insert mode
set tabstop=2                                                " Tabs are always 2 spaces
set expandtab                                                " Expand tabs into spaces
set shiftwidth=2                                             " Reindent with 2 spaces (using <<)
set list                                                     " Show invisible chars
set listchars=""                                             " Reset listchars
set list listchars=tab:»·,trail:·                            " Set listchars for tabs and trailing spaces
set clipboard=unnamedplus                                    " Ubuntu Clipboard sharing, also run `sudo apt-get install vim-gtk`
set splitbelow                                               " Split panes to below
set splitright                                               " Split panes to right
set hlsearch
set incsearch
set statusline=%<%f\ %h%m%r%=\ %-14.(%l,%c%V%)\ %P%#warningmsg#%{SyntasticStatuslineFlag()}%*
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}

hi CursorColumn cterm=NONE ctermbg=black                     " Set a vertical bar for the cursor
set cursorcolumn

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md setlocal filetype=ghmarkdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" ---------------------
" Custom Options
" ----------------------

let mapleader = ","
let g:mapleader = ","
let base16colorspace=256

" Airline
let g:airline_theme                      = 'wombat' " base16_pop, base16_summerfruit, simple
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts            = 1

" NERDTree
let NERDTreeQuitOnOpen          = 1
let NERDChristmasTree           = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden          = 1

" rails.vim
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_javascript_checkers      = ['jshint']
let g:syntastic_html_checkers            = ['jshint']
let g:syntastic_ruby_checkers            = ['rubocop']
let g:syntastic_html_tidy_ignore_errors  = [
      \  '<html> attribute "lang" lacks value',
      \  '<a> attribute "href" lacks value',
      \  'trimming empty <span>',
      \  'trimming empty <h1>',
      \  'trimming empty <p>',
      \  'inserting implicit <p>'
      \ ]

" Ultisnips
let g:UltiSnipsEditSplit           = "vertical"
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
let g:UltiSnipsUsePythonVersion    = 3

" ---------------------
" Personal Mappings
" ----------------------

" Easier movements between splits
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-w>l

" Nerdtree
map <F2> :NERDTreeToggle<CR>
map <Tab> :NERDTreeFind<CR>

" Tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<ENTER>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nnoremap <space> gt

" RSpec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Silver Searcher
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" tComment
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" CtrlP + Ctags
nnoremap <leader>. :CtrlPTag<cr>

" ---------------------
" Abbreviations
" ----------------------

