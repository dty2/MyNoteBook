"-----------------------------------------------------------------------"
"       __  __            __               _    ___                     "
"      / / / /_  ______  / /____  _____   | |  / (_)___ ___  __________ "
"     / /_/ / / / / __ \/ __/ _ \/ ___/   | | / / / __ `__ \/ ___/ ___/ "
"    / __  / /_/ / / / / /_/  __/ /       | |/ / / / / / / / /  / /__   "
"   /_/ /_/\__,_/_/ /_/\__/\___/_/        |___/_/_/ /_/ /_/_/   \___/   "
"                                                                       "
"-----------------------------------------------------------------------"

"-------------------"
"   Plugin config   "
"-------------------"

"install plugin by ssh
let g:plug_url_format = 'git@github.com:%s.git'

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion'
Plug 'morhetz/gruvbox'
Plug 'mg979/vim-visual-multi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'suan/vim-instant-markdown'
call plug#end()

"------------"
"  settings  "
"------------"

"line number
set number
set relativenumber

set background=dark
set wildmenu
set showcmd
set title
set wrap
set hlsearch
set scrolloff=5
set backspace=indent,eol,start
set laststatus=2
colorscheme gruvbox

"cursor light
set cursorline
set cursorcolumn

"manager indent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set clipboard=unnamedplus

"let the cursor at the sameline for last place to leave when you open the file which is opened before
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"-------"
"  map  "
"-------"
let mapleader= ' '
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>t :vertical terminal<CR>
nnoremap <leader>ti :terminal<CR>
nnoremap <leader>] :v<C-w><C-]><CR>
nnoremap <leader>]i :v<C-]><CR>
nnoremap <leader><CR> :nohlsearch<CR>

nnoremap <c-f> <c-f>zz
nnoremap <c-b> <c-b>zz
nnoremap n nzz
nnoremap ; :
nnoremap N Nzz
inoremap jj <Esc>
nnoremap R :source $MYVIMRC<CR>

"split window 
nnoremap sl :set splitright<CR>:vsplit<CR>
nnoremap sj :set splitbelow<CR>:split<CR>

"change split window size
nnoremap <leader>sh :vertical resize -5<CR>
nnoremap <leader>sl :vertical resize +5<CR>
nnoremap <leader>sj :res -5<CR>
nnoremap <leader>sk :res +5<CR>

"move cursor between split window
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"-----------------"
"    nerd tree    "
"-----------------"
nnoremap <leader>n :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeWinSize = 20
let NERDTreeShowHidden = 1

"---------------"
"    airline    "
"---------------"
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
let g:airline_symbols = {}
let g:airline_theme="gruvbox" 
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.dirty='⚡'
endif

"-------------"
"    tagbar   "
"-------------"
nnoremap <leader>m :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_width = 20
let g:tagbar_autoclose = 1

"---------------"
"   easymotion  "
"---------------"
nnoremap <Leader><leader> <Plug>(easymotion-s)

"------------------"
"   visual-multi   "
"------------------"
let g:VM_theme = 'iceblue'
let g:EasyMotion_leader_key = '\'
let g:VM_maps = {}
let g:VM_maps['Add Cursor Up'] = '<C-k>'
let g:VM_maps['Add Cursor Down'] = '<C-j>'

"----------------------"
"   instant markdown   "
"----------------------"
autocmd Filetype markdown inoremap ,, <Esc>:MarkdownPreviewToggle<CR>
autocmd Filetype markdown nnoremap ,, :MarkdownPreviewToggle<CR>
autocmd Filetype markdown inoremap ,1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,4 ####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,q ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
autocmd Filetype markdown inoremap ,w `` <++><Esc>F`i
autocmd Filetype markdown inoremap ,e ** <++><Esc>F*i
autocmd Filetype markdown inoremap ,r **** <++><Esc>F*hi
autocmd Filetype markdown inoremap ,t ~~~~ <++><Esc>F~hi  
autocmd Filetype markdown inoremap ,a [](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,s - [](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,d **********************

