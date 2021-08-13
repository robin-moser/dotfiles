""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Robin Moser
"
" Sections:
"   General
"   Text, tab and indent related
"   Colors and Fonts
"   Moving around
"   Status line
"   Editing mappings
"   Spell checking
"   Misc
"   Helper functions

""""""""""""""""""""""""""""""""""""""""""""""
"   General
""""""""""""""""""""""""""""""""""""""""""""""

" Set the Leader Key to Space
let g:mapleader = "\<space>"

filetype plugin on

set nocompatible
set nobackup
set nowritebackup

set history=500
set scrolloff=5

set wrap
set wildmenu
set backspace=eol,start,indent
set whichwrap=<,>
set ignorecase
set smartcase

set noerrorbells
set novisualbell

set timeoutlen=500

""""""""""""""""""""""""""""""""""""""""""""""
"   Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""

" set tabstop=4
set breakindent
set number
set updatetime=40
set mouse=a
set ttymouse=xterm2
set nofixendofline

set list
set listchars=tab:\│\ "
set splitbelow
set splitright

""""""""""""""""""""""""""""""""""""""""""""""
"   Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""

syntax on

set t_Co=256
set synmaxcol=512
set lazyredraw

highlight  Comment                    ctermfg=242
highlight  Statement                  ctermfg=214

highlight  Visual                     ctermbg=237
highlight  Search                     ctermfg=15     ctermbg=23

highlight  DiffAdd                    ctermfg=40     ctermbg=none
highlight  DiffDelete                 ctermfg=88     ctermbg=none
highlight  DiffChange                 ctermfg=240    ctermbg=none
highlight  DiffText                   ctermfg=255    ctermbg=none

highlight  Pmenu                      ctermfg=254    ctermbg=238
highlight  VertSplit                  ctermfg=238    ctermbg=59
highlight  StatusLine                 ctermfg=240    ctermbg=255
highlight  StatusLineNC               ctermfg=238    ctermbg=59
highlight  SignColumn                 ctermfg=255    ctermbg=none
highlight  QuickFixLine               ctermbg=none
highlight  SyntasticErrorSign         ctermbg=none   ctermfg=9
highlight  SyntasticWarningSign       ctermbg=none   ctermfg=3
highlight  SyntasticStyleErrorSign    ctermbg=none   ctermfg=9
highlight  SyntasticStyleWarningSign  ctermbg=none   ctermfg=3
highlight  SyntasticWarning           ctermbg=3      ctermfg=16
highlight  MatchParen                 ctermbg=23
highlight  ExtraWhitespace            ctermbg=red
highlight  SpecialKey                 ctermfg=240

highlight CocErrorFloat               ctermfg=196
highlight CursorColumn                ctermbg=236

highlight Tabline                     ctermbg=36
highlight TablineSel                  ctermbg=240
highlight TablineFill                 ctermfg=238

highlight ToolbarButton               ctermbg=236
highlight ToolbarLine                 ctermbg=238

highlight EasyMotionMoveHL            ctermbg=none ctermfg=40 cterm=bold

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

""""""""""""""""""""""""""""""""""""""""""""""
"   Moving around
""""""""""""""""""""""""""""""""""""""""""""""

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

""""""""""""""""""""""""""""""""""""""""""""""
"   Plugins
""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

Plug 'darfink/vim-plist'
Plug 'beyondwords/vim-twig'
Plug 'cespare/vim-toml'
Plug 'chr4/nginx.vim'

Plug 'junegunn/limelight.vim'

Plug 'yggdroot/indentline'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'ntpeters/vim-better-whitespace'

Plug 'roryokane/detectindent'
Plug 'editorconfig/editorconfig-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf'

Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'terryma/vim-multiple-cursors'

call plug#end()

" fzf
""""""""""""""""
nnoremap <leader><space> :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fh :History:<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader>fb :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-d': 'vsplit'
  \ }

" indentline
""""""""""""""""

let g:vim_json_conceal=0

let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_color_term = 239
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_first_char = '│'
let g:indentLine_char = '│'

autocmd FileType help,nerdtree,coc-explorer,diff :IndentLinesDisable
autocmd FileType help,nerdtree,coc-explorer,diff :LeadingSpaceDisable

" gitgutter
""""""""""""""""
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_removed = '✖'

" limelight
""""""""""""""""
let g:limelight_conceal_ctermfg = 242
let g:limelight_conceal_ctermfg = 240

nmap <Leader>l :Limelight!!<Enter>
xmap <Leader>l :Limelight!!<Enter>


" tcomment
""""""""""""""""
noremap <Leader>c<space> :TComment<Enter>
noremap <Leader>cb :TCommentBlock<Enter>

" detectindent
""""""""""""""""
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_when_mixed = 1
let g:detectindent_preferred_indent = 4

autocmd BufWinEnter * :DetectIndent

" detectindent
""""""""""""""""
autocmd BufWinEnter * :EditorConfigReload

" syntastic
""""""""""""""""
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 10
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_error_symbol = ">"
let g:syntastic_warning_symbol = ">"
let g:syntastic_style_error_symbol = '>'
let g:syntastic_style_warning_symbol = '>'

let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_python_checkers = ['python3', 'pylint']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_go_checkers = ['golint']

let g:syntastic_php_phpcs_args = '--standard=psr2 --export=csv'
let g:syntastic_php_phpmd_post_args = 'cleancode,codesize,controversial,design,unusedcode'

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1

" nerdtree
""""""""""""""""
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

let g:NERDTreeHijackNetrw = 1

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore = ['\.png$','\.jpg$','\.gif$','\.mp3$','\.flac$', '\.ogg$', '\.mp4$','\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$', '\.rar$']

nnoremap <Leader>f :NERDTreeToggle<Enter>

" easymotion
""""""""""""""""
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys ='asdfjklcvbnmqwertuiopzxgh'

map <Leader> <Plug>(easymotion-prefix)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

nmap s <Plug>(easymotion-overwin-f)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

vmap * y<Plug>(easymotion-sn)<C-R>"
nmap * lbvey<Plug>(easymotion-sn)<C-R>"

" vimspector
""""""""""""""""
fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>dR <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

" <Plug>VimspectorStop
" <Plug>VimspectorPause
" <Plug>VimspectorAddFunctionBreakpoint

""""""""""""""""""""""""""""""""""""""""""""""
"   Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""""""

" write with sudo privileges
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" quick insert before and after
noremap <Leader>i i_<Esc>r
noremap <Leader>a a_<Esc>r

" block selection, when ctrl-v cant be used
noremap <Leader>v <C-v>

" copy to system clipboard
noremap Y "+y

" paste from system clipboard (before/after)
noremap <Leader>p "+p
noremap <Leader>P "+P

inoremap jk <ESC>

" natural indenting (normal/visual)
noremap > <<
noremap < >>
vnoremap > <gv
vnoremap < >gv

""""""""""""""""""""""""""""""""""""""""""""""
"   Custom Functions
""""""""""""""""""""""""""""""""""""""""""""""

" go to line number, where the file was left
au BufReadPost * call GoBackToLine()

" Shortcut SC for ShellCheck
command -nargs=+ SC call ShellCheck(<f-args>)

" Double-@ triggers macro for visual range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function GoBackToLine()
  if line("'\"") > 1 && line("'\"") <= line("$")
    exe "normal! g'\""
  endif
endfunction

" Search string on Google
function GoogleSearch(...)
  let q = substitute(join(a:000, " "), ' ', "+", "g")
  exe '!google-chrome https://encrypted.google.com/search?q=' . q
endfunction

" Get the ShellCheck github page from a SC number
function ShellCheck(...)
  let q = substitute(join(a:000, " "), ' ', "+", "g")
  exe '!google-chrome https://github.com/koalaman/shellcheck/wiki/SC' . q
endfunction

" Execute macro for each line in visual range
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  endif
  return ''
endfunction

""""""""""""""""""""""""""""""""""""""""""""""
"   Statusbar
""""""""""""""""""""""""""""""""""""""""""""""

function! ModeColors(mode)
  " Normal mode
  if a:mode == 'n'
    hi pl_primary_text ctermfg=237 ctermbg=36
    hi pl_primary_icon ctermfg=36 ctermbg=237
    hi pl_primary_icon_l ctermfg=36 ctermbg=239
    hi pl_secondary_text ctermfg=43 ctermbg=237
    hi pl_secondary_text_l ctermfg=49 ctermbg=239
  " Insert mode
  elseif a:mode == 'i'
    hi pl_primary_text ctermfg=237 ctermbg=178
    hi pl_primary_icon ctermfg=178 ctermbg=237
    hi pl_primary_icon_l ctermfg=178 ctermbg=239
    hi pl_secondary_text ctermfg=178 ctermbg=237
    hi pl_secondary_text_l ctermfg=178 ctermbg=239
  " Replace mode
  elseif a:mode == 'R'
    hi pl_primary_text ctermfg=237 ctermbg=212
    hi pl_primary_icon ctermfg=212 ctermbg=237
    hi pl_primary_icon_l ctermfg=212 ctermbg=239
    hi pl_secondary_text ctermfg=212 ctermbg=237
    hi pl_secondary_text_l ctermfg=212 ctermbg=239
  " Visual mode
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == ""
    hi pl_primary_text ctermfg=237 ctermbg=107
    hi pl_primary_icon ctermfg=107 ctermbg=237
    hi pl_primary_icon_l ctermfg=107 ctermbg=239
    hi pl_secondary_text ctermfg=107 ctermbg=237
    hi pl_secondary_text_l ctermfg=107 ctermbg=239
  endif

  hi powerline_b ctermfg=239 ctermbg=237
  return ''
endfunction

" Return a nice mode name
function! ModeName(mode)
  if a:mode == 'n'
    return ' NORMAL '
  elseif a:mode == 'i'
    return 'INSERT'
  elseif a:mode == 'R'
    return 'REPLACE'
  elseif a:mode == 'v'
    return 'VISUAL'
  elseif a:mode == 'V'
    return "V-LINE"
  elseif a:mode == ""
    return "V-BLOCK"
  elseif a:mode == 't'
    return 'TERMINAL'
  endif
endfunction

function! Modified(modified)
  if a:modified == 1
    hi modified_fgc ctermfg=167 ctermbg=237
    return '●'
  else
    hi modified_fgc ctermfg=235 ctermbg=237

    return ''
  endif
endfunction

function! LineColNum()
  return line(".") . " - " . virtcol(".")
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

set noshowmode
set laststatus=2
set statusline=

set statusline+=%{ModeColors(mode())}
" Mode
set statusline+=%#pl_primary_text#\ %{ModeName(mode())}%#pl_primary_icon_l#"
" Filename
set statusline+=%#powerline_b#%#pl_secondary_text_l#\ %.20f\ \ %#powerline_b#\ "
" Right Side
set statusline+=%=
" Modified
set statusline+=%#modified_fgc#%{Modified(&modified)}\ "
" Line / Cols
set statusline+=%#pl_secondary_text#%{LineColNum()}\ "
" Fileformat / Filetype
set statusline+=%#powerline_b#%#pl_secondary_text_l#\ %{&ff}\ -\ %{&ft!=#''?&ft:'generic'}\ "

""""""""""""""""""""""""""""""""""""""""""""""
"   Coc Settings
""""""""""""""""""""""""""""""""""""""""""""""

set updatetime=100
set shortmess+=c
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> ög <Plug>(coc-diagnostic-prev)
nmap <silent> äg <Plug>(coc-diagnostic-next)

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
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
