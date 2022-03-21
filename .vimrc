" Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'rchiossi/spellcheck-ptbr.vim'
Plug 'rchiossi/twilight-theme.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'Kris2k/Zoomwin-vim'
Plug 'itchyny/lightline.vim'
Plug 'rchiossi/lightline-twilight-theme.vim'
Plug 'tpope/vim-fugitive'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

"enable 256 colors in gnome-terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" cursor line (slow scrolling)
set cursorline

" Numbers and Errors
set number
set signcolumn=number

"load colorscheme
colorscheme twilight

" Key bindings
inoremap jk <ESC>
let mapleader = ","

" Proper Tabs
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set fillchars+=stl:\ ,stlnc:\

" Improper Tabs
"set list
"set listchars=tab:>-
"set softtabstop=0 noexpandtab

" Highlight Tabs
 function! HiTabs()
    syntax match TAB /\t/ containedin=ALL
    hi TAB ctermbg=186 ctermfg=blue
endfunction
au BufEnter,BufRead * call HiTabs()

"highligh whitespaces
highlight RedundantSpaces term=standout ctermbg=red guibg=red
autocmd BufEnter,WinEnter * :match RedundantSpaces /\s\+$\| \+\ze\t/

" UI
filetype plugin indent on
syntax on
set ruler
set laststatus=2

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Show matching brace
set showmatch
set matchtime=1

"prevent automatic new-line to be added to files
set fileformats+=dos

"expand %% to local path
cabbr <expr> %% expand('%:p:h')

"for kdev
":set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

" fzf to crtlp
map <c-p> :FZF -i <CR>

" English spellcheck
nmap <F6> :setlocal spell! spelllang=en<cr>
" Portuguese spellcheck
nmap <F7> :setlocal spell! spelllang=pt<cr>

" Enter to select autocomplete
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Select first item in autocomplete list
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" Select longest common match in autocomplete
set completeopt=longest,menuone

" Don't enter EX mode by accident
nnoremap Q <nop>

" tell vim to keep a backup file
set backup

" tell vim where to put its backup files
set backupdir=/tmp/rodrigo/vim

" tell vim where to put swap files
set dir=/tmp/rodrigo/vim

let g:lightline = {
      \ 'colorscheme': 'twilight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"RO":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" View diff while writing commit message

" BufRead seems more appropriate here but for some reason the final `wincmd p` doesn't work if we do that.
autocmd VimEnter COMMIT_EDITMSG call OpenCommitMessageDiff()
function OpenCommitMessageDiff()
    " Save the contents of the z register
    let old_z = getreg("z")
    let old_z_type = getregtype("z")

    try
        call cursor(1, 0)
        let diff_start = search("^diff --git")
        if diff_start == 0
            " There's no diff in the commit message; generate our own.
            let @z = system("git diff --cached -M -C")
        else
            " Yank diff from the bottom of the commit message into the z register
            :.,$yank z
            call cursor(1, 0)
        endif

        " Paste into a new buffer
        vnew
        normal! V"zP
        wincmd r
    finally
        " Restore the z register
        call setreg("z", old_z, old_z_type)
    endtry

    " Configure the buffer
    set filetype=diff noswapfile nomodified readonly
    silent file [Changes\ to\ be\ committed]

    " Get back to the commit message
    wincmd p
endfunction

" hexedit
" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin,*.rpm let &bin=1
  au BufReadPost *.bin,*.rpm if &bin | %!xxd
  au BufReadPost *.bin,*.rpm set ft=xxd | endif
  au BufWritePre *.bin,*.rpm if &bin | %!xxd -r
  au BufWritePre *.bin,*.rpm endif
  au BufWritePost *.bin,*.rpm if &bin | %!xxd
  au BufWritePost *.bin,*.rpm set nomod | endif
augroup END

" more powerful backspacing
set backspace=indent,eol,start

" coc
let g:coc_disable_startup_warning = 1
hi CocErrorHighlight ctermbg=167

"MAC
noremap § `
noremap ± ~

" Use new regular expression engine - Solve slowness for .ts files
set re=0

" Reduce update time
set updatetime=750

" Update cursor when changing modes
if &term == 'xterm-256color' || &term == 'screen-256color'
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[3 q"
endif

if exists('$TMUX')
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
endif
