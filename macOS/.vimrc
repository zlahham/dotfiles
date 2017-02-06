" =====================================================================
"                              Zaid's vimrc
" =====================================================================

" Author: Zaid Al Lahham [http://zaidlahham.me]
" Source: https://github.com/zlahham/dotfiles

" ---------------------------------------------------------------------

set nocompatible                                             " vim not vi
set encoding=utf-8
set spelllang=en_gb

" ---------------------------------------------------------------------
"                                Vundle
" ---------------------------------------------------------------------

" Call on Vundle packages from an external file
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" ---------------------------------------------------------------------
"                           Appearance & Colour
" ---------------------------------------------------------------------

colorscheme gruvbox                                          " Favourites: gruvbox, sourcerer, hybrid
set background=dark
set t_Co=256
set term=screen-256color

set cursorline                                               " Highlight current cursor line
set cursorcolumn                                             " Highlight current cursor column
hi CursorColumn cterm=NONE ctermbg=black                     " Set a vertical bar for the cursor

set hlsearch
set incsearch
hi Search ctermfg=green ctermbg=NONE cterm=underline         " Search results are coloured and underlined

" ---------------------------------------------------------------------
"                              vim Settings
" ---------------------------------------------------------------------

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
set backspace=2                                              " Backspace deletes like most programs in insert mode
set tabstop=2                                                " Tabs are always 2 spaces
set expandtab                                                " Expand tabs into spaces
set shiftwidth=2                                             " Reindent with 2 spaces (using <<)
set list                                                     " Show invisible chars
set listchars=""                                             " Reset listchars
set list listchars=tab:»·,trail:·                            " Set listchars for tabs and trailing spaces
set clipboard=unnamed                                        " Mac OS X Clipboard sharing
set splitbelow                                               " Split panes to below
set splitright                                               " Split panes to right
set statusline=%<%f\ %h%m%r%=\ %-14.(%l,%c%V%)\ %P%#warningmsg#%{SyntasticStatuslineFlag()}%*
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}


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

" ---------------------------------------------------------------------
"                            Plugin Options
" ---------------------------------------------------------------------

" Call on custom plugin options from an external file
if filereadable(expand("~/.vimrc.options"))
  source ~/.vimrc.options
endif

" ---------------------------------------------------------------------
"                                Commands
" ---------------------------------------------------------------------

" Call on commands from an external file
if filereadable(expand("~/.vimrc.commands"))
  source ~/.vimrc.commands
endif

" ---------------------------------------------------------------------
"                              Mappings
" ---------------------------------------------------------------------

" Call on mappings from an external file
if filereadable(expand("~/.vimrc.mappings"))
  source ~/.vimrc.mappings
endif
