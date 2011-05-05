" TODO:
" 1. select better font type and size for GUI
" 2. a nicer language encoding detection


set nocompatible
set t_vb=

" english looks better for simple chinese windows
if v:lang =~ "zh_CN"
  language messages en_US
endif

" enable wrap in chinese text
set formatoptions+=mM

"###############################################################################################
" platform specific settings
"
let s:MSWIN = has("win16") || has("win32") || has("win64") || has("win95")
"
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

    " set backupdir i.e. hello.c~
    set backupdir=$HOME/vimfiles/vim_bkp,.
    " set dir for swap files
    set dir=$HOME/vimfiles/vim_bkp,.

    set columns=90 lines=65

    " set runtimepath=$HOME/vimfiles,$VIMRUNTIME,
    " to maximize the window
    au GUIEnter * simalt ~x
else
    "set encoding=utf-8
    "let &termencoding=&encoding
    set fileencodings=utf-8,cp936,gb18030,big5
    
    " set backupdir i.e. hello.c~
    set backupdir=$HOME/.vim/vim_bkp,.
    " set dir for swap files
    set dir=$HOME/.vim/vim_bkp,.

    if has('gui_running')
        set guifont=Andale\ Mono\ 9
	set guioptions=egma
    endif
endif


"###############################################################################################
" layout related settings, colorscheme must be placed before LineNr setting.
"
"set columns=90 lines=65
"set background=light
"set background=dark
"set t_Co=256
if has('gui_running')
    colorscheme desert
else
    colorscheme desert
endif

set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2
set ruler
set showcmd
hi LineNr guifg=#666666
set number
" showing more with tab
set wildmenu

"###############################################################################################
" editing options
" wrap on whole word which maybe help when text editing
set autochdir    " auto change directory according to current file
" set clipboard equal unnamed
"set clipboard=unnamed

"###############################################################################################
" search & replace 
set incsearch
"set gdefault

"###############################################################################################
" settings for development, preview will show you python doc when c-x c-o
set completeopt=longest,menu,preview
filetype plugin indent on
"set tags=
"syntax on
set showmatch
set smartindent

" PEP8 for python 
set expandtab
set textwidth=70
set tabstop=8
set softtabstop=4
set shiftwidth=4 " set linebreak
set autoindent

" autocompletion for python
autocmd FileType python set omnifunc=pythoncomplete#Complete

" functions key mapping
" <F2> is used by visual bookmark
nmap tt :TlistToggle<cr>
nnoremap <silent> <F3> :Rgrep<CR>
nmap <F4> :nohlsearch<cr>
nmap <F5> :copen<cr>
nmap <F6> :cclose<cr>
nnoremap <silent> <F8> :A<CR>
"nmap <F12> :cn<cr>    
"nmap <F11> :cp<cr>   
nmap <F12> :Project<cr>


"###############################################################################################
" settings for windows
nmap wv <C-w>v
nmap wc <C-w>c
nmap ws <C-w>s


"###############################################################################################
" plugin specific settings
"
" taglist 
if s:MSWIN
    let Tlist_Ctags_Cmd = 'D:\utils\ctags57\ctags.exe'
else
    let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
endif
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1

" cscope
"cs add $BTROOT/cscope.out $BTROOT
set cscopequickfix=s-,c-,d-,i-,t-,e-
"set cindent

" configure for miniBufExp plug-in
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1

" configuration for A.vim
let g:alternateSearchPath = 'sft:.,sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sft:./btnut/btnode/include,sft:./nut/include'

" configuration for grep.vim
if s:MSWIN
    let Grep_Path='D:\utils\GnuWin32\bin\grep.exe'
    let Fgrep_Path='D:\utils\GnuWin32\bin\fgrep.exe'
    let Egrep_Path='D:\utils\GnuWin32\bin\egrep.exe' 
    let Agrep_Path='D:\utils\GnuWin32\bin\egrep.exe' 
    let Grep_Find_Path='D:\utils\GnuWin32\bin\find.exe' 
    let Grep_Xargs_Path='D:\utils\GnuWin32\bin\xargs.exe'
    let Grep_Null_Device='NUL'
    let Grep_Shell_Quote_Char=''
    let Grep_Shell_Escape_Cha =''
    let Grep_Cygwin_Find=1
    let Grep_Skip_Dirs='CVS .svn' 
    "let Grep_Default_Options='-i' 
    let Grep_Skip_Files='*~' 
endif

" configuration for latex vim
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

" derive from minibufexpl
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" c.vim, turn off c-j and remap only in inert mode so that we can navigate by
" c-j
let g:C_Ctrl_j='off'
autocmd FileType cpp imap    <buffer>  <silent>  <C-j>    <C-R>=C_JumpCtrlJ()<CR>
autocmd FileType c imap    <buffer>  <silent>  <C-j>    <C-R>=C_JumpCtrlJ()<CR>

" enable syntax foldmethod in c/c++ code
autocmd FileType c set foldmethod=syntax
autocmd FileType cpp set foldmethod=syntax


