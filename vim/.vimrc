call plug#begin('~/.vim/bundle')
Plug 'preservim/nerdtree'
Plug 'haya14busa/incsearch.vim'
Plug 'doums/darcula', { 'as': 'darcula' }
call plug#end()

filetype plugin on
filetype indent on
syntax on
set number
set ruler
set autoread
set backspace=eol,start,indent
set wildmenu
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set wrap
set pastetoggle=<F2>
set mouse=a
set ignorecase
set noerrorbells
set novisualbell
set foldcolumn=1
set background=dark
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>
map ,v :vs <C-R>=expand("%:p:h") . "/" <CR>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map <C-t> :NERDTreeToggle<CR>

colorscheme darcula
