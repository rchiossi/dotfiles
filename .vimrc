" Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'rchiossi/spellcheck-ptbr.vim'
Plug 'rchiossi/twilight-theme.vim'
Plug 'rchiossi/lightline-twilight-theme.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/gv.vim'
Plug 'Kris2k/Zoomwin-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'alfredodeza/pytest.vim'
Plug 'pixelneo/vim-python-docstring'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'brentyi/isort.vim'
Plug 'andviro/flake8-vim'
"Plug 'github/copilot.vim'
Plug 'rust-lang/rust.vim'
Plug 'hashivim/vim-terraform'
Plug 'google/vim-jsonnet'
Plug 'martinda/Jenkinsfile-vim-syntax'
call plug#end()

"enable 256 colors in gnome-terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" cursor line (slow scrolling)
set cursorline

" When searching, always keep 5 visible lines above and bellow
set scrolloff=5

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

" more powerful backspacing
set backspace=indent,eol,start

" fast scrolling and painting
set ttyfast
set lazyredraw

" Show options on autocomplete for : commands
set wildmenu wildmode=list:longest,full

" Use system clipboard
" Linux
" set clipboard=unnamedplus
" Mac
set clipboard=unnamed

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
set backupdir=/Users/rchiossi/.vim_tmp

" tell vim where to put swap files
set dir=/Users/rchiossi/.vim_tmp

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

"MAC
noremap § `
noremap ± ~

" Use new regular expression engine - Solve slowness for .ts files
set re=0

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

" Plugins -------------------------------------------------------------------

" English spellcheck
nmap <F6> :setlocal spell! spelllang=en<cr>
" Portuguese spellcheck
nmap <F7> :setlocal spell! spelllang=pt<cr>

" lightline plugin configuration
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

" fzf to crtlp
"map <c-p> :FZF -i <CR>
map <c-p> :Files <CR>
map <C-s> :Lines <CR>

" coc plugin - (Run after install - :CoCInstall coc-pyright coc-json coc-rust-analyzer)
let g:coc_disable_startup_warning = 1
hi CocErrorHighlight ctermbg=167

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! ScanErrors()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        :CocDiagnostics
    else
        lclose
    endif
endfunction

nnoremap <silent> <F4> :call ScanErrors()<cr>

" Pytest
nnoremap <silent> <F5> :Pytest file<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Black
nnoremap <F9> :Black<CR>
"autocmd BufWritePre *.py execute ':Black'

"Isort
nnoremap <F10> :Isort<CR>
"autocmd BufWritePre *.py execute ':Isort'

"Flake8
nnoremap <F3> :PyFlake<CR>
"autocmd BufWritePre *.py execute ':PyFlake'

" Copilot
" imap <leader>n <Plug>(copilot-next)
" imap <leader>p <Plug>(copilot-previous)

" jsonnet
let g:jsonnet_fmt_on_save=0


