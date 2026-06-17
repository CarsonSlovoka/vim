" `ln -siv $(realpath vimrc) ~/.vimrc`

let mapleader = '\'

if has("syntax") " vi --version | grep syntax " 要是+syntax才能用
  syntax on
  "set foldmethod=syntax
endif

" 顯示列號
" set nu
set relativenumber

" 取消列號
" set nonu

" 顯示這個才可以曉得當前的模式是插入還是指令的模式
set showcmd

set showmatch

set cursorline
set cursorcolumn

" scrolloff=999 保持在畫面中間
set scrolloff=999


set hlsearch
set incsearch  " 邊搜尋的時候，就會出現結果，而不需要等到enter才會有結果

set noswapfile
set nobackup

set nowrap  " 禁止長行自動換行

set ignorecase  " 搜尋不分大小寫, 可以用\C讓該次搜尋有區分

set foldcolumn=0  " 不顯示, 要的時候再自己設定. 比較常用的是2
" 設定 foldlevel 0~9
for i in range(0, 9)
    execute printf('nnoremap <leader>fl%d :set foldlevel=%d<CR>', i, i)
    execute printf('nnoremap <leader>fc%d :set foldcolumn=%d<CR>', i, i)
endfor

" set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:␣  " Note: tab要有兩個, 第二個可以用空白
set listchars=tab:\|\ ,trail:·,multispace:\ ,nbsp:␣  " https://github.com/CarsonSlovoka/nvim/blob/f0eb3965cd3f0dd63e962ce256477a308f4c71a6/lua/config/options.lua#L190-L205
set list  " 這也要加上 listchars 才會有用

" 🟧 tabline
set tabline=%!MyTabLine()
function! MyTabLine()
  let s = ''
  for i in range(1, tabpagenr('$'))
    if i == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    "let s .= '%' . i . 'T'         " 滑鼠點擊用
    let s .= ' ' . i . ' '          " ← 顯示 tab 數字
    let winnr = tabpagewinnr(i)
    let buflist = tabpagebuflist(i)
    let buf = buflist[winnr -1] " vim 下標從0開始, 而如果是lua是從1開始(不需要減1)
    let filename = fnamemodify(bufname(buf), ':t')
    if filename == ''
      let filename = '[No Name]'
    endif
    let s .=  filename . ' '

    if getbufvar(buf, '&modified')
      let s .= '[+] ' " 可以曉得是不是被修改過(還沒有存檔)
    endif
  endfor

  let s .= '%#TabLineFill#%T'
  return s
endfunction

" 🟧 indent_size, indent_style
set tabstop=4         " Tab鍵等於2個空白
set softtabstop=4     " 在插入模式下，Tab鍵也等於2空白
set shiftwidth=4      " 自動縮進時使用 2 個空白
set foldmethod=indent " 如果上面的沒設定，只設indent也沒用


" 🟧 status line

" 1. Force the statusline to always remain visible at the bottom
set laststatus=2

" 2. Clear any existing configuration string
set statusline=

" 3. Build the left side of the statusline (concatenated with +=)
set statusline=[%{mode()}]              " `:help mode()`
set statusline+=\ %F                    " Full file path
set statusline+=%m                      " Modified flag [+]
set statusline+=%r                      " Read-only flag [RO]
set statusline+=%h                      " Help buffer flag [help]
set statusline+=%w                      " Preview window flag [Preview]

" 4. Divider: everything after this character moves to the right side
set statusline+=%=

" 5. Build the right side of the statusline
set statusline+=%{indent('.')/&tabstop} " indent('.') 是當前列的縮進是幾個空白. 可以曉得要一口氣縮進多少. 可以直接除上tabstop就會曉得要縮進幾個
set statusline+=\ TS:%{&tabstop}
set statusline+=\ %{\ &fileencoding\ !=\ ''\ ?\ &fileencoding\ :\ &encoding\ }
set statusline+=\ [%{&fileformat}]      " File format/Line endings (e.g., [unix])
set statusline+=\ [%Y]                    " File type (e.g., [PYTHON])
"set statusline+=\ %p%%                 " Percentage through the file
set statusline+=\ %p%%(%L)              " Percentage through the file (Total lines)
"set statusline+=\ %l/%L                " Current line number / Total lines
"set statusline+=\ col:%c               " Current column number
set statusline+=\ %l:%c                 " Current {line, column} number

if exists('+termguicolors')
  set termguicolors    " 這如果沒有設定，有的顏色看起來不好看
endif
hi StatusLine       ctermbg=DarkGray cterm=NONE              " 用Blue也不錯
hi StatusLineNC     ctermbg=NONE     guifg=Gray cterm=NONE   " 非選中的顏色

" termnial的status line也要設定, 兩者可以不同
hi StatusLineTerm   ctermbg=DarkGray cterm=NONE
hi StatusLineTermNC ctermbg=NONE     cterm=NONE


" 🟧 highlight
" 預設的主題顏色, 都不太好, 使用自定
" set background=dark
" colorscheme wildcharm   " darkblue, habamax, slate, unokai, wildcharm " 能與CursorLine, CursorColumn匹配

" :help hi
" Warn: 是用NONE而不是None
" highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=white
" highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=white
 "highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=NONE " ctermfg 用None才不會影響到syntax的突顯
 "highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=NONE
highlight CursorLine     cterm=NONE guibg=#333333  ctermfg=NONE
highlight CursorColumn   cterm=NONE guibg=#2f3e54  ctermfg=NONE
"set cursorlineopt=number,line  " 這是預設
set cursorlineopt=line

" 搜尋與選擇
hi Search           guifg=#ffffff guibg=#ff520d
hi IncSearch        guifg=#0d1117 guibg=#ffa657  " guifg=#161b22 guibg=#f0883e
hi Visual           guifg=#ffffff guibg=#78120d  " guibg=#2f81f7 guifg=#ffffff

" 基礎顏色
hi Normal           guifg=#e6edf3 guibg=#0d1117
hi NormalNC         guifg=#e6edf3 guibg=#0d1117
hi NormalFloat      guifg=#e6edf3 guibg=#161b22
hi FloatBorder      guifg=#30363d guibg=#161b22

" 編輯器 UI
hi Cursor           guifg=#0d1117 guibg=#e6edf3
" hi CursorLine       guibg=#21262d
" hi CursorColumn     guibg=#21262d
hi ColorColumn      guibg=#21262d
hi LineNr           guifg=#6e7681
hi CursorLineNr     guifg=#e6edf3 guibg=#21262d
hi SignColumn       guifg=#6e7681 guibg=#0d1117
hi VertSplit        guifg=#30363d
hi WinSeparator     guifg=#30363d
hi Folded           guifg=#8b949e guibg=#21262d
hi FoldColumn       guifg=#6e7681
hi EndOfBuffer      guifg=#21262d

" 彈出視窗
hi Pmenu            guifg=#e6edf3 guibg=#161b22
hi PmenuSel         guifg=#ffffff guibg=#2f81f7
hi PmenuSbar        guibg=#21262d
hi PmenuThumb       guibg=#6e7681

" 狀態列
hi StatusLine       guifg=#0d1117 guibg=#58a6ff gui=bold
hi StatusLineNC     guifg=#8b949e guibg=#21262d

" 語法高亮 (最接近 github_dark_default)
hi Comment          guifg=#8b949e gui=italic
hi Constant         guifg=#79c0ff
hi String           guifg=#a5d6ff
hi Character        guifg=#a5d6ff
hi Number           guifg=#79c0ff
hi Boolean          guifg=#79c0ff
hi Float            guifg=#79c0ff

hi Identifier       guifg=#e6edf3
hi Function         guifg=#d2a8ff

hi Statement        guifg=#ff7b72
hi Conditional      guifg=#ff7b72
hi Repeat           guifg=#ff7b72
hi Label            guifg=#ff7b72
hi Operator         guifg=#79c0ff
hi Keyword          guifg=#ff7b72

hi PreProc          guifg=#ff7b72
hi Type             guifg=#ffa657
hi StorageClass     guifg=#ffa657
hi Structure        guifg=#ffa657
hi Typedef          guifg=#ffa657

hi Special          guifg=#e6edf3
hi Tag              guifg=#7ee787
hi Delimiter        guifg=#e6edf3

hi Underlined       guifg=#58a6ff gui=underline
hi Error            guifg=#f85149
hi Todo             guifg=#0d1117 guibg=#d29922 gui=bold

" Diff
hi DiffAdd          guifg=#aff5b4 guibg=#033a16
hi DiffDelete       guifg=#ffdcd7 guibg=#67060c
hi DiffChange       guifg=#ffdfb6 guibg=#5a1e02
hi DiffText         guifg=#e6edf3 guibg=#5a1e02

" LSP / Diagnostic
hi DiagnosticError  guifg=#f85149
hi DiagnosticWarn   guifg=#d29922
hi DiagnosticInfo   guifg=#2f81f7
hi DiagnosticHint   guifg=#8b949e

"" Treesitter 相關 (vi不能這樣設定)
"hi @keyword         guifg=#ff7b72
"hi @function        guifg=#d2a8ff
"hi @variable        guifg=#e6edf3
"hi @string          guifg=#a5d6ff
"hi @type            guifg=#ffa657
"hi @constant        guifg=#79c0ff
"hi @comment         guifg=#8b949e gui=italic
"hi @tag             guifg=#7ee787
"hi @attribute       guifg=#d2a8ff


" 🟧 keymap
nnoremap Q :q<CR>

nnoremap <A-w> <C-w>w<CR>
nnoremap <A-h> <C-w>h<CR>
nnoremap <A-j> <C-w>j<CR>
nnoremap <A-k> <C-w>k<CR>
nnoremap <A-l> <C-w>l<CR>

nnoremap <leader><leader>t :term<CR>

nnoremap <A-t> :tabnew<CR>

nnoremap <leader>/ :nohlsearch<CR>


" Wrap selection / word with double quotes
nnoremap <leader>" viw<Esc>`>a"<Esc>`<i"<Esc>
vnoremap <leader>" <Esc>`>a"<Esc>`<i"<Esc>

" Wrap selection / word with single quotes
nnoremap <leader>' viw<Esc>`>a'<Esc>`<i'<Esc>
vnoremap <leader>' <Esc>`>a'<Esc>`<i'<Esc>

" Wrap selection / word with backticks
nnoremap <leader>` viw<Esc>`>a`<Esc>`<i`<Esc>
vnoremap <leader>` <Esc>`>a`<Esc>`<i`<Esc>

" Wrap selection / word with parentheses
nnoremap <leader>( viw<Esc>`>a)<Esc>`<i(<Esc>
vnoremap <leader>( <Esc>`>a)<Esc>`<i(<Esc>

" Wrap selection / word with square brackets
nnoremap <leader>[ viw<Esc>`>a]<Esc>`<i[<Esc>
vnoremap <leader>[ <Esc>`>a]<Esc>`<i[<Esc>

" Wrap selection / word with curly braces
nnoremap <leader>{ viw<Esc>`>a}<Esc>`<i{<Esc>
vnoremap <leader>{ <Esc>`>a}<Esc>`<i{<Esc>


" Tip: terminal中可以用 <C-w>" 後面可以接暫存器的名稱，就可以貼上該內容
tnoremap <C-r> <C-w>"

" clear
" function! ClearTerminal()
"     call feedkeys("iclear\<CR>", "nt")
"     set scrollback=1        " 沒這個可用
"     set scrollback=1000000
" endfunction
" tnoremap <silent> <Leader><Leader>c <C-\><C-n>:call ClearTerminal()<CR>
" tnoremap <Leader><Leader>c <C-\><C-n>iclear<CR> " 同下 (往上滾還是會看到)
tnoremap <Leader>c <C-\><C-n>i<C-l>


" 🟧 autocmd
"augroup YankHighlight  " 在vi不能這樣用，沒有lua能用
"  autocmd!
"  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup='IncSearch', timeout=700})
"augroup END


augroup YankHighlight
    autocmd!
    autocmd TextYankPost * call HighlightYank()
augroup END

function! HighlightYank()
    " Tip: 此版本只可適用: yw, yiw, yy  (V下的多列不行(單列可))

    let l:pos = getpos("'[")
    let l:end = getpos("']")

    if l:pos[1] != l:end[1]
        return
    endif

    let l:id = matchaddpos(
                \ 'IncSearch',
                \ [[l:pos[1], l:pos[2], l:end[2]-l:pos[2]+1]]
                \ )

    call timer_start(700, {-> matchdelete(l:id)})
endfunction


augroup filetype_indent
  " autocmd! 會先清除同 group 內之前的設定，防止重複
  autocmd!

  " 這種寫法會有問題，吃不到設定
  "  autocmd FileType md,yml,yaml,json,json5,jsonc,toml,xml,svg,ttx,
  "              \ gs,gohtml,gotmpl,html,js,javascript,mjs,ts,mts,
  "              \ css,scss,sass,lua,vim,vue,sh,zsh,dart
  "              \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2

  " Tip: `:verbose setlocal tabstop?`  " 加上verbose可以顯示設定是來至哪裡
  autocmd FileType *
                  \ if index(['md','markdown',
                  \           'yml','yaml',
                  \           'json','json5','jsonc',
                  \           'toml',
                  \           'xml','svg','ttx',
                  \           'gs',
                  \           'gohtml','gotmpl',
                  \           'html',
                  \           'js','javascript','mjs','ts','mts',
                  \           'css','scss','sass',
                  \           'lua',
                  \           'vim',
                  \           'vue',
                  \           'sh','zsh',
                  \           'dart',
                  \           ], &ft) >= 0
                  \ |   setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
                  \ | else
                  \ |   setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
                  \ | endif

  " `:verbose setlocal expandtab?`
  autocmd FileType go,puml,nsi.nsh,Makefile,mk
    \ setlocal noexpandtab

augroup END

