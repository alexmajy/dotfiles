set nocompatible
source $VIMRUNTIME/vimrc_example.vim
set t_vb=
"source $VIMRUNTIME/mswin.vim

"set diffexpr=MyDiff()
"function MyDiff()
  "let opt = '-a --binary '
  "if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  "if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  "let arg1 = v:fname_in
  "if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  "let arg2 = v:fname_new
  "if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  "let arg3 = v:fname_out
  "if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  "let eq = ''
  "if $VIMRUNTIME =~ ' '
    "if &sh =~ '\<cmd'
      "let cmd = '""' . $VIMRUNTIME . '\diff"'
      "let eq = '"'
    "else
      "let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    "endif
  "else
    "let cmd = $VIMRUNTIME . '\diff'
  "endif
  "silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

" Languages settings, the setting assume you are working with windows xp
" simple chinese edition.
if v:lang =~ "zh_CN"
  language messages en_US
endif
set guioptions=egm
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set termencoding=cp936
set encoding=utf-8

set fileencodings=utf-8,gb18030,utf-16,big5


" vim-latex pluging settyings
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'



" my vim settings start here
syntax on
"set background=light
"set background=dark
colorscheme evening
set number
set incsearch

" showing more with tab
set wildmenu

" to maximize the window
"au GUIEnter * simalt ~x
set laststatus=2

" set backupdir
set backupdir=$HOME/.vim/vim_bkp,.
set dir=$HOME/.vim/vim_bkp,.

" set clipboard equal unnamed
set clipboard=unnamed

let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
set cscopequickfix=s-,c-,d-,i-,t-,e-

" configure for winmanager
let g:winManagerWindowsLayout = 'FileExplorer,TagList'
"nmap wm :WMToggle<cr>
"nmap nt :NERDTreeToggle<cr>

" functions key mapping
" <F2> is used by visual bookmark
nmap <F3> :nohlsearch<cr>
nmap <F4> :TlistToggle<cr>
nmap <F5> :NERDTreeToggle<cr>
nmap <F6> :copen<cr>
nmap <F7> :cclose<cr>

" cscope
:cs add $BTROOT/cscope.out $BTROOT
set cindent

" configure for miniBufExp plug-in
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1

" configure for A.vim
let g:alternateSearchPath = 'sft:.,sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sft:./btnut/btnode/include,sft:./nut/include'


