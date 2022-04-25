let mapleader = " "

"Settings
"filetype plugin indent on
set ignorecase
set smartcase
"set spelllang=en,es,cjk
"set spell
set nospell
set encoding=utf-8
set fileencoding=utf-8
set updatetime=200
set timeoutlen=500
set noerrorbells
set number relativenumber
set mouse=a
set hidden
set termguicolors
set wrap
set incsearch
"set cursorline
set splitright
set splitbelow
"Snek case...
set iskeyword-=_
set iskeyword-=-
"Don't comment on CR
set formatoptions-=cor
"Lightline already shows mode
set noshowmode
"Breathing space
set scrolloff=8
set sidescrolloff=5
"Avoid splitting words when wrapping lines
set linebreak
"Set title to current file instead of terminal emulator name
set title
"History
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
"Tab be gud
set autoindent
set softtabstop=2
set expandtab
set shiftwidth=4
set smartindent

set completeopt="menuone, noselect"
set pumheight=10
set signcolumn=yes
set numberwidth=4
set conceallevel=0

" --------------------------------Keymap--------------------------------"
"Kinda scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

"Sensible copy-pasting to and from system clipboard
vnoremap <C-y> "+y <bar> :echom 'Copied to system clipboard!'<CR>
nnoremap <C-y> "+yiw <bar> :echom 'Copied to system clipboard!'<CR>
nnoremap <C-p> "+p <bar> :echom 'Pasted from system clipboard!'<CR>
vnoremap <C-p> "+p <bar> :echom 'Pasted from system clipboard!'<CR>
inoremap <C-p> <Esc>"+p <bar> :echom 'Pasted from system clipboard!'<CR>A

"Y like you V or C
nnoremap Y y$

"Paste over selected text without screwing the reg
vnoremap p "_dP
vnoremap P "_dP

"Select all
nnoremap <C-a> ggVG

"Increment number
nnoremap <A-a> <C-a>

"Esc+Esc to turn off search highlighting
nnoremap <Esc> :noh<return><Esc>

"Center search selection
nnoremap n nzzzv
nnoremap N Nzzzv

"Search selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

"Dumb-replace word in Normal mode and selection in Visual mode
nnoremap <silent> rp *``cgn
vnoremap <silent> rp y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn
"FUCKS UP REG

"Close tab
nnoremap <C-w> :q<CR>

"Indent
vnoremap <a-h> <gv
vnoremap <a-l> >gv
vnoremap < <gv
vnoremap > >gv
nnoremap <a-h> <<
nnoremap <a-l> >>

"Move current line and selected lines
noremap <a-j> :m .+1<cr>==
noremap <a-k> :m .-2<cr>==
vnoremap <a-j> :m '>+1<cr>gv=gv
vnoremap <a-k> :m '<-2<cr>gv=gv

"Save all 
nnoremap <C-s> :wa <CR>

"Split right
nnoremap <c-a-O> <cmd>vsp %<cr>

"Resize vertical splits
nnoremap + :vertical resize +2<CR>
nnoremap - :vertical resize -2<CR>

"Navigate splits
nnoremap <C-M-l> <cmd>wincmd l<cr>
nnoremap <C-M-h> <cmd>wincmd h<cr>
nnoremap <C-M-j> <cmd>wincmd j<cr>
nnoremap <C-M-k> <cmd>wincmd k<cr>

"Add Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u

"Add number and half page jumps to jumplist
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <c-u> <c-u>m'
nnoremap <c-d> <c-d>m'
