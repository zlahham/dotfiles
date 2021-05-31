" =====================================================================
"                              Zaid's neovimrc
" =====================================================================

" Author: Zaid Al Lahham [http://zaidlahham.me]
" Source: https://github.com/zlahham/dotfiles

" ---------------------------------------------------------------------

set nocompatible            " disable compatibility to old-time vi
set spelllang=en_gb
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set smartcase               " ignore above if the search has upcase characters
set tabstop=2               " number of columns occupied by a tab character
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " :eindent with 2 spaces (using <<)
set list                    " show invisible chars
set number                  " add line numbers
set relativenumber          " add relative line numbers
set showtabline=2           " show tab line at top
set termguicolors           " enables 24-bit RGB color in the TUI
set cursorline              " highlights current cursorline
set noswapfile              " don't create .swp files
set nobackup                " don't create <file>~ backup files
set scrolloff=7             " keep 7 lines at top/bottom while scrolling
set clipboard=unnamed       " macOS X Clipboard sharing
set splitbelow              " split panes to below
set splitright              " split panes to right
set foldmethod=indent       " folding performance
set foldlevelstart=999      " only auto-fold if file > 999 levels
set browsedir=current       " make the file browser always open the current directory.

set rtp+=/usr/local/opt/fzf " list of dirs to be searched for these runtime files

filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

" ---------------------------------------------------------------------
"                                Plugins
" ---------------------------------------------------------------------

call plug#begin('~/.config/nvim/plugged')
  Plug 'tyrannicaltoucan/vim-quantum'                           " color scheme
  Plug 'vim-airline/vim-airline'                                " nicer status bar
  Plug 'vim-airline/vim-airline-themes'
  Plug '/usr/local/opt/fzf'                                     " fzf through homebrew
  Plug 'junegunn/fzf.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " completion engine
  Plug 'tpope/vim-haml'                                         " haml support
  Plug 'tpope/vim-endwise'                                      " ends methds in ruby
  Plug 'tpope/vim-rails'                                        " rails support
  Plug 'thoughtbot/vim-rspec'                                   " rspec support
  Plug 'neomake/neomake'                                        " syntax support
  Plug 'ntpeters/vim-better-whitespace'                         " tracks whitespace
  Plug 'jiangmiao/auto-pairs'                                   " insert/delete {[( in pairs
  Plug 'vim-scripts/tComment'                                   " commenting on lines
  Plug 'tpope/vim-surround'                                     " modify surroundings with cs
  Plug 'tpope/vim-fugitive'                                     " git wrapper
  Plug 'airblade/vim-gitgutter'                                 " Show git diff on the left
  Plug 'scrooloose/nerdtree'                                    " better project tree
  Plug 'ryanoasis/vim-devicons'                                 " dev icons
  Plug 'pangloss/vim-javascript'                                " javaScript support
  Plug 'hashivim/vim-terraform'                                 " terraform support
call plug#end()

colorscheme quantum

" ---------------------------------------------------------------------
"                                Options
" ---------------------------------------------------------------------
"
let mapleader = ","
let g:mapleader = ","
let base16colorspace=256

" Native netrw Tree
" let g:netrw_liststyle=3     " Tree
" let g:netrw_banner=0        " Removes banner
" let g:netrw_browse_split=4  " Not sure yet
" let g:netrw_winsize=30      " Width of Tree

" Neomake
" When writing a buffer (no delay).
call neomake#configure#automake('w')
let g:neomake_open_list = 2

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Rspec-vim
let g:rspec_runner = "os_x_iterm"

" Airline theme for status bar
let g:airline_theme='quantum'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts            = 1

" NERDTree
let NERDTreeQuitOnOpen          = 1
let NERDChristmasTree           = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden          = 1
let NERDTreeMapActivateNode     = '<CR>'

" Terraform
let g:terraform_align=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save=1

" ---------------------------------------------------------------------
"                                Mappings
" ---------------------------------------------------------------------

" Use Esc to exit in Terminal mode
tnoremap <Esc> <C-\><C-n>

" CTRL P uses fzf
" let dir = finddir('.git/..', expand('%:p:h').';')
nnoremap <C-p> :GFiles<CR>

" Access first character in line
nmap 0 ^

" Toggle relative line number
nmap <C-n> :set rnu<CR>
nmap <C-n> :set rnu!<CR>

" Easier movements between splits
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-w>l

" Exit insert mode
imap jk <esc>
imap kj <esc>

" Movement up and down virtual lines (wrapped lines)
nmap j gj
nmap k gk

" RSpec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Silver Searcher
" nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap \ :Ag<SPACE>

" Search for # of occurances
map <leader># #<C-O>:%s///gn<CR>
map <leader><CR> :noh<CR>

" Tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<ENTER>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nnoremap <Space> gt

" tComment
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" NERDTreeFind
nnoremap <silent> <Tab> :NERDTreeToggle<CR>
nnoremap <silent> <Leader><Tab> :NERDTreeFind<CR>
