 ─────────────────────────────────────────────
"  minimal vimrc — clean & dark
" ─────────────────────────────────────────────

" === Core ===
set nocompatible
filetype plugin indent on
syntax enable

" === UI ===
set number
#set relativenumber          " relative line numbers (great for jumps)
sed -i '/set relativenumber/d' ~/.vimrc
set cursorline              " highlight current line
set signcolumn=yes          " always show sign column (no layout shift)
set scrolloff=8             " keep 8 lines above/below cursor
set sidescrolloff=8
set wrap                    " soft wrap long lines
set showmatch               " flash matching bracket
set wildmenu                " enhanced command completion
set wildmode=longest:full,full
set laststatus=2            " always show statusline
set noshowmode              " mode shown in statusline, not cmdline
set showcmd                 " show partial command in bottom right
set termguicolors           " 24-bit colour

" === Search ===
set ignorecase
set smartcase               " case-sensitive only when uppercase used
set hlsearch
set incsearch
nnoremap <Esc> :nohlsearch<CR>  " clear search highlight with Esc

" === Indentation ===
set tabstop=4
set shiftwidth=4
set expandtab               " spaces, not tabs
set smartindent

" === Splits ===
set splitbelow
set splitright

" === Files ===
set noswapfile
set nobackup
set undofile                " persistent undo across sessions
set undodir=~/.vim/undodir

" === Perf ===
set updatetime=100
set timeoutlen=400

" ─────────────────────────────────────────────
"  Colour scheme — tokyonight-inspired hand-rolled
"  (no plugin needed, works in 256 + truecolour)
" ─────────────────────────────────────────────
set background=dark

hi clear
if exists("syntax_on")
  syntax reset
endif

" Core
hi Normal           guifg=#c0caf5  guibg=#1a1b26  ctermfg=189  ctermbg=234
hi NormalNC         guifg=#c0caf5  guibg=#16161e
hi LineNr           guifg=#3b4261  guibg=NONE
hi CursorLineNr     guifg=#7aa2f7  guibg=NONE     gui=bold
hi CursorLine       guifg=NONE     guibg=#1f2335
hi SignColumn       guibg=NONE
hi ColorColumn      guibg=#1f2335
hi VertSplit        guifg=#1d202f  guibg=#1d202f
hi EndOfBuffer      guifg=#1a1b26

" Syntax
hi Comment          guifg=#565f89  gui=italic
hi Constant         guifg=#ff9e64
hi String           guifg=#9ece6a
hi Character        guifg=#9ece6a
hi Number           guifg=#ff9e64
hi Boolean          guifg=#ff9e64
hi Float            guifg=#ff9e64
hi Identifier       guifg=#7dcfff
hi Function         guifg=#7aa2f7
hi Statement        guifg=#bb9af7
hi Keyword          guifg=#bb9af7  gui=italic
hi Conditional      guifg=#bb9af7  gui=italic
hi Repeat           guifg=#bb9af7  gui=italic
hi Label            guifg=#bb9af7
hi Operator         guifg=#89ddff
hi Exception        guifg=#f7768e
hi PreProc          guifg=#7dcfff
hi Include          guifg=#7dcfff
hi Define           guifg=#7dcfff
hi Macro            guifg=#7dcfff
hi Type             guifg=#2ac3de  gui=italic
hi StorageClass     guifg=#2ac3de
hi Structure        guifg=#2ac3de
hi Typedef          guifg=#2ac3de
hi Special          guifg=#89ddff
hi SpecialChar      guifg=#89ddff
hi Tag              guifg=#f7768e
hi Delimiter        guifg=#89ddff
hi SpecialComment   guifg=#565f89  gui=italic
hi Error            guifg=#f7768e  guibg=NONE  gui=undercurl
hi Todo             guifg=#e0af68  guibg=NONE  gui=bold,italic
hi Underlined       guifg=#7aa2f7  gui=underline

" Search & Selection
hi Search           guifg=#1a1b26  guibg=#e0af68
hi IncSearch        guifg=#1a1b26  guibg=#ff9e64  gui=bold
hi Visual           guibg=#2d3f76
hi VisualNOS        guibg=#2d3f76

" Popups & Menus
hi Pmenu            guifg=#c0caf5  guibg=#1f2335
hi PmenuSel         guifg=#1a1b26  guibg=#7aa2f7
hi PmenuSbar        guibg=#1f2335
hi PmenuThumb       guibg=#3b4261

" Diffs
hi DiffAdd          guifg=NONE  guibg=#1e3a2f
hi DiffChange       guifg=NONE  guibg=#152a37
hi DiffDelete       guifg=#f7768e  guibg=#2d1b1e
hi DiffText         guifg=NONE  guibg=#1c4360

" Messages
hi ErrorMsg         guifg=#f7768e  guibg=NONE
hi WarningMsg       guifg=#e0af68  guibg=NONE
hi ModeMsg          guifg=#c0caf5  gui=bold
hi MoreMsg          guifg=#9ece6a

" Status line — minimal two-tone
hi StatusLine       guifg=#c0caf5  guibg=#1f2335  gui=NONE
hi StatusLineNC     guifg=#3b4261  guibg=#1a1b26  gui=NONE

" Matching brackets
hi MatchParen       guifg=#ff9e64  guibg=NONE  gui=bold,underline

" Folds
hi Folded           guifg=#565f89  guibg=#1f2335  gui=italic
hi FoldColumn       guifg=#3b4261  guibg=NONE

" Spelling
hi SpellBad         guisp=#f7768e  gui=undercurl
hi SpellWarn        guisp=#e0af68  gui=undercurl

" ─────────────────────────────────────────────
"  Status line (no plugin)
" ─────────────────────────────────────────────
hi User1 guifg=#1a1b26 guibg=#7aa2f7 gui=bold    " mode block
hi User2 guifg=#7aa2f7 guibg=#1f2335             " filename
hi User3 guifg=#565f89 guibg=#1f2335             " right side meta

function! ModeLabel()
  let m = mode()
  let labels = {'n':'NORMAL','i':'INSERT','v':'VISUAL','V':'V-LINE',
        \"\<C-v>":'V-BLOCK','c':'COMMAND','R':'REPLACE','s':'SELECT',
        \'t':'TERMINAL'}
  return get(labels, m, m)
endfunction

set statusline=
set statusline+=%1*\ %{ModeLabel()}\ %*   " mode
set statusline+=%2*\ %f%m%r\ %*           " file
set statusline+=%=                         " separator
set statusline+=%3*\ %y\ \|\ %l:%c\ \|\ %p%%\ %*  " type / pos / pct

" ─────────────────────────────────────────────
"  Keymaps
" ─────────────────────────────────────────────
let mapleader = " "

" faster window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move lines up/down (like most editors)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" stay in visual after indent
vnoremap < <gv
vnoremap > >gv

" quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" open netrw file browser
nnoremap <leader>e :Explore<CR>

" yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" ─────────────────────────────────────────────
"  Undo dir bootstrap
" ─────────────────────────────────────────────
if !isdirectory(expand("~/.vim/undodir"))
  call mkdir(expand("~/.vim/undodir"), "p")
endif
