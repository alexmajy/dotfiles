"---- base ----"

set nocompatible
set t_vb=

set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2
set ruler
set showcmd
set number
set wildmenu

" enable wrapping chinese text
set formatoptions+=mM

"---- colorscheme ----"

set background=dark
if has('gui_running')
    colorscheme desert
else
    set t_Co=256
    colorscheme ir_black
endif

"---- platform specific settings: encoding, font ----"

let s:MSWIN = has("win16") || has("win32") || has("win64") || has("win95")
if s:MSWIN
    " since the default encoding under win32 is cp936(gb2312), we prefer that
    set fileencodings=cp936,utf-8,gb18030,utf-16,big5
    set termencoding=cp936
    set fileformat=unix
    if has("gui_running")
	" Try to use a smaller font, geeks like more lines in their screen!
	set guifont=Consolas:h10,ProggyTiny:h10,Luxi_Mono:h12:cANSI
	set guioptions=egm
    endif
    set backupdir=$HOME/vimfiles/vim_bkp,.
    set dir=$HOME/vimfiles/vim_bkp,.

    set columns=90 lines=65

    " english looks better 
    if v:lang =~ "zh_CN"
        language messages en_US
    endif

    " maximize the window
    au GUIEnter * simalt ~x
else
    set fileencodings=utf-8,cp936,gb18030,big5
    set backupdir=$HOME/.vim/vim_bkp,.
    set dir=$HOME/.vim/vim_bkp,.

    if has('gui_running')
        set guifont=Andale\ Mono\ 9.5
	set guioptions=egma
    endif
endif

"---- file ----"

set autochdir 
syntax on
filetype plugin indent on
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


"---- search & format ----"

set incsearch
set hlsearch
set showmatch
set iskeyword+=:

set listchars=tab:›\ ,eol:¬

" according to PEP8 
set expandtab
set textwidth=70
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

"---- folding ----"

set foldenable
set foldmethod=marker

" enable syntax foldmethod in c/c++ code
autocmd FileType c set foldmethod=syntax
autocmd FileType cpp set foldmethod=syntax

"---- map ----"

let mapleader=','

" <F2> is used by visual bookmark
nmap tt :TlistToggle<cr>
nnoremap <silent> <F3> :Rgrep<CR>
nmap <F4> :nohlsearch<cr>
nmap <F5> :copen<cr>
nmap <F6> :cclose<cr>
nmap <F12> :Project<cr>

" windwos splitting
nmap <leader>wv <C-w>v
nmap <leader>ws <C-w>s
nmap <leader>wc <C-w>c

" windows navigation, see also after/plugin/hacks.vim
nmap <C-h> <C-w>h
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
"---- completion ----"

set completeopt=longest,menu,preview

" c-x c-o
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

"---- plugin specific settings ----"

"-- taglist --"

if s:MSWIN
    let Tlist_Ctags_Cmd = 'D:\utils\ctags57\ctags.exe'
else
    let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
endif
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1

"-- cscope: cs add $BTROOT/cscope.out $BTROOT --"

set cscopequickfix=s-,c-,d-,i-,t-,e-

"-- A.vim --"

let g:alternateSearchPath = 'sft:.,sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sft:./btnut/btnode/include,sft:./nut/include'

"-- latex --"

if s:MSWIN
    " IMPORTANT: win32 users will need to have 'shellslash' set so that latex
    " can be called correctly.
    set shellslash
    let g:Tex_DefaultTargetFormat='pdf'
    let g:Tex_CompileRule_pdf='texify --pdf $*'
endif
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'

"-- c.vim hacks --"

" turn off c-j and remap only in inert mode so that we can navigate by " c-j
let g:C_Ctrl_j='off'
autocmd FileType cpp imap    <buffer>  <silent>  <C-j>    <C-R>=C_JumpCtrlJ()<CR>
autocmd FileType c imap    <buffer>  <silent>  <C-j>    <C-R>=C_JumpCtrlJ()<CR>


