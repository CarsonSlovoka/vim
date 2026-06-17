" `ln -siv $(realpath vimrc) ~/.vimrc`

let mapleader = '\'

if has("syntax") " vi --version | grep syntax " 要是+syntax才能用
  syntax on
  "set foldmethod=syntax
endif

set fileencodings=ucs-bom,utf-8,default,cp950,big5,gbk,binary
set fileformat=unix

" 顯示列號
" set nu
set relativenumber

" 取消列號
" set nonu

" 顯示這個才可以曉得當前的模式是插入還是指令的模式
set showcmd

set showmatch

" set lazyredraw
set synmaxcol=128     " vi對syntax的處理不如nvim, 所以減少會對速度提升很多
set cursorline        " 在vi禁用這些對速度會提升很多: `:set nocursorline nocursorcolumn`  (但nvim沒什麼影響)
set cursorcolumn

" scrolloff=999 保持在畫面中間
set scrolloff=999

" set timeoutlen=0  " 這如果設定成0, keymap的等待輸入都會看不到，例如: <leader>bk 會出問題
" ttimeoutlen 設定
set ttimeoutlen=0   " 設定成0之後，在Terminal按下了<Esc>a就不會被輸入成 å

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

set shortmess-=S  " 這個在搜尋的時候，可以出現匹配的個數

" 🟧 cursorshape
" 切換為插入模式 (Insert Mode) 時改為直線游標
let &t_SI = "\<Esc>[6 q"
" 切換為一般模式 (Normal Mode) 時改為方塊游標
let &t_EI = "\<Esc>[2 q"
" 切換為取代模式 (Replace Mode) 時改為底線游標
let &t_SR = "\<Esc>[4 q"

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
" set statusline+=%=
" set statusline+=\ %{searchcount().current}/%{searchcount().total}  " 好處是離開search時還能看到, 甚致曉得到當前第幾個, 但不用的時候就很礙眼
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


" 🟧 highlight
" 預設的主題(colorscheme)顏色, 都不太好, 使用自定
set background=dark       " Important: 這個還是要選，它也會影響到highlight的結果
" colorscheme wildcharm   " darkblue, habamax, slate, unokai, wildcharm " 能與CursorLine, CursorColumn匹配

" :help hi
" Warn: 是用NONE而不是None
" highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=white
" highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=white
"highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=NONE " ctermfg 用None才不會影響到syntax的突顯
"highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=NONE
highlight CursorLine     cterm=NONE guibg=#2f3e54  ctermfg=NONE
highlight CursorColumn   cterm=NONE guibg=#3a3a3a  ctermfg=NONE
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
hi StatusLineNC     guifg=#0d1117 guibg=#8b949e
" termnial的status line也要設定, 兩者可以不同
hi StatusLineTerm   guifg=#0d1117 guibg=#58a6ff gui=bold
hi StatusLineTermNC guifg=#0d1117 guibg=#8b949e

" Tabline
hi TabLineSel   guifg=#A9B665 guibg=#282828 gui=bold ctermfg=2 ctermbg=235 cterm=bold
hi TabLine      guifg=#7C6F64 guibg=#3C3836 ctermfg=243 ctermbg=237
hi TabLineFill  guifg=#1D2021 guibg=#1D2021 ctermfg=234 ctermbg=234

" 語法高亮
hi Comment          guifg=#8b949e gui=italic
"hi link vimLineComment    Comment  " 可以不用設定會延用
"hi link shComment         Comment

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

if $TERM_PROGRAM ==# 'Apple_Terminal'
  " <A-x> = \ex  使如果用Terimanl且將option改為Meta時 A-x 的熱鍵也能生效
  " echo 'Apple_Terminal'
  for c in split('abcdefghijklmnopqrstuvwxyz', '\zs')
    execute "set <A-".c.">=\e".c
  endfor
endif

nnoremap Q :q<CR>

vnoremap <leader>y "+y

nnoremap <A-w> <C-w>w<CR>
nnoremap <A-h> <C-w>h<CR>
nnoremap <A-j> <C-w>j<CR>
nnoremap <A-k> <C-w>k<CR>
nnoremap <A-l> <C-w>l<CR>

" clist, llist
" nnoremap [q :cprevious<CR>   " 這種寫法對有用到v:count1會不能用
nnoremap <silent> [q :<C-u>execute v:count1 . "cprevious"<CR>
nnoremap <silent> ]q :<C-u>execute v:count1 . "cnext"<CR>
nnoremap <silent> [l :<C-u>execute v:count1 . "lprevious"<CR>
nnoremap <silent> ]l :<C-u>execute v:count1 . "lnext"<CR>


" 在當前的目錄開啟term
" nnoremap <leader><leader>t :term<CR>
nnoremap <leader><leader>t :execute 'cd ' . expand('%:h') \| term<CR>
nnoremap <leader>t :execute 'e ' . expand('%:h')<CR>
nnoremap <leader>e :execute 'e ' . expand('%:h')<CR>

"nnoremap <A-t> :tabnew<CR>
nnoremap <A-t> :execute 'tabnew ' . expand('%:p')<CR>

nnoremap <leader>/ :nohlsearch<CR>

nnoremap <leader>cd :execute 'cd ' . expand('%:p:h') \| echo getcwd()<CR>

" Note: 如果要將efm改成預設，可以用 `:set efm&`
nnoremap <leader>cadde :set efm=%f<CR>
      \ :execute 'lcd ' . expand('%:p:h')<CR>
      \ :caddexpr systemlist('fd ')<Left><Left>
"\ :cgetexpr systemlist('fd ')<Left><Left>  " 這個每次都是新的, 用caddexpr會比較好, 可以添加

" link
vnoremap <leader><leader>l c[<C-r>"]()<Left>

" insert move
inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

inoremap <C-h> <C-Left>
vnoremap <C-h> <C-Left>
inoremap <C-l> <C-Right>
vnoremap <C-l> <C-Right>


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

" 將選取區塊下(J)/上(K)移一行
" Note:
" gv 重新選取
" = 自動縮排
" gv 再重新選取
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


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

" 🟧 digraphs
augroup Digraphs
  " 😑
  digraph -- 128529
  " 😵
  digraph xd 128565

  " 😀 😁
  digraph sm 128512 ha 128513

  " 💬
  digraph .. 128172

  " ✅
  digraph Ok 9989")

  " ❌
  digraph xx 10060"
  " 👈 👇 👆 👉
  digraph hh 128072 jj 128071 kk 128070 ll 128073

  " 🚀
  digraph rt 128640

  " 💪
  digraph sg 128170

  " ≈ ≒
  digraph ~~ 8776
  digraph := 8776
augroup END

" 🟧 command
function! Inspect()
  let l:pos = [line('.'), col('.')]
  let l:synstack = synstack(l:pos[0], l:pos[1])

  " 清空之前的訊息，避免干擾
  echo "\n"

  echohl Title
  echo "=== Inspect at (" . l:pos[0] . "," . l:pos[1] . ") ==="
  echohl None

  if empty(l:synstack)
    echohl WarningMsg
    echo "No syntax highlight found."
    echohl None
    return
  endif

  echohl Statement
  echo "Syntax stack (from bottom to top):"
  echohl None

  for id in l:synstack
    let name = synIDattr(id, "name")
    echohl Identifier
    echo " • " . name
    echohl None
  endfor

  " 最上層的 highlight group
  let hi = synIDattr(synID(l:pos[0], l:pos[1], 1), "name")
  echohl Statement
  echo "\nDirect highlight group:"
  echohl Identifier
  echon " " . hi
  echohl None

  " 最終連結到的 group
  let lo = synIDattr(synIDtrans(synID(l:pos[0], l:pos[1], 1)), "name")
  if hi != lo
    echohl Statement
    echon " → Links to: "
    echohl Identifier
    echon lo
    echohl None
  endif

  " 顯示 highlight 設定
  if hlexists(hi)
    redir => hl_output
    silent execute 'highlight ' . hi
    redir END

    echohl Statement
    echo "\nHighlight definition:\n"
    echohl None

    let lines = split(trim(hl_output), "\n")
    for line in lines
      let line = trim(line)

      " 處理 "xxx links to yyy" 的情況
      if line =~# '\clinks to'
        let group = matchstr(line, '^\s*\zs\w\+')
        let target = matchstr(line, '\clinks to \zs\w\+')

        if hlexists(group)
          execute 'echohl ' . group
          echon group
          echohl None
        else
          echohl Identifier
          echon group
          echohl None
        endif

        echohl Statement
        echon " links to "
        echohl None

        if hlexists(target)
          execute 'echohl ' . target
          echon target
          echohl None
        else
          echohl Identifier
          echon target
          echohl None
        endif

      " 一般 highlight 定義（ctermfg、guifg 等）
      else
        let group = matchstr(line, '^\s*\zs\w\+')
        let attrs = matchstr(line, '^\s*\w\+\s*\zs.*')

        if hlexists(group)
          execute 'echohl ' . group
          echon group
          echohl None
        else
          echohl Identifier
          echon group
          echohl None
        endif

        echohl Comment
        echon " " . attrs
        echohl None
      endif
    endfor
  endif
endfunction
" command! Inspect echo synIDattr(synID(line("."),col("."),1),"name")   " 👈 這可行，但比較簡單
command! Inspect call Inspect()

" command! NewTmp enew | setlocal buftype=nofile noswapfile
command! -nargs=? -complete=filetype NewTmp call NewTmp(<q-args>)
function! NewTmp(ft) abort
  enew
  setlocal buftype=nofile noswapfile

  " 如果有提供 filetype，就設定
  if !empty(a:ft)
    execute 'setlocal filetype=' . a:ft
  endif
endfunction

command! -range -nargs=0 Help call s:HelpOnSelection()
function! s:HelpOnSelection() range
  " 取得 visual 選擇的文字. 這可行，但是gvy似乎會觸發其它的event, 導致執行了之後有其它的問題
  "let save_reg = @@
  "silent! normal! gvy
  "let selected = @@
  "let @@ = save_reg

  " 取得選取內容
  let selected = join(getregion(getpos("'<"), getpos("'>")), '')

  " 清除前後空白
  let selected = substitute(selected, '^\s*\|\s*$', '', 'g')

  if empty(selected)
    return
  endif

  execute 'help' selected
endfunction

" Caution: 一定要補上`filetype plugin indent on`，那麼用 &commentstring " 才會是給正確的
" Note: `filetype plugin indent on` 也可以讓 `=` 的格式化正確, 如果沒有開啟用 " = 不會對
filetype plugin indent on
packadd comment
" function! ToggleComment()
"   if empty(&commentstring)
"     echo 'No commentstring defined for this filetype!'
"     return
"   endif
"
"   let l:comment = split(&commentstring, '%s', 1) " 分割成前後兩部分
"   let l:leader = l:comment[0]
"   let l:trailer = get(l:comment, 1, '')
"
"   let l:line = getline('.')
"   let l:trimmed = substitute(l:line, '^\s*', '', '')
"
"
"   " 如果已經被註解，就取消註解
"   if l:trimmed =~# '^\V' . escape(l:leader, '\')
"     let l:newline = substitute(l:line, '\V' . escape(l:leader, '\'), '', '')
"     call setline('.', l:newline)
"   else
"     " 否則加上註解
"     let l:indent = matchstr(l:line, '^\s*')
"     let l:content = substitute(l:line, '^\s*', '', '')
"     let l:newline = l:indent . l:leader . l:content . l:trailer
"     call setline('.', l:newline)
"   endif
" endfunction
"
" nnoremap gcc :call ToggleComment()<CR>
" vnoremap gc :call ToggleComment()<CR>


augroup Formatting
  autocmd!

  "可行，但是所有的buffer都可以用
  "command! FmtJson %!jq .
  "command! -range FmtCurl s/ -/ \\\r -/g
  " -buffer只有當前的該buffer才會有此指令能用
  autocmd FileType json        command! -buffer        FmtJson   %!jq .
  autocmd FileType sh,bash,zsh command! -buffer -range FmtCurl   s/ -/ \\\r -/g

  "autocmd FileType go nnoremap <buffer> <leader>f :%!gofmt<CR>
  autocmd FileType go          command! -buffer        FmtGo     %!gofmt

  autocmd FileType xml         command! -buffer        FmtXml    %!xmlstarlet fo

  "autocmd FileType rust       command! -buffer        FmtRs
  "    \ update | silent %!cargo fmt
  autocmd FileType rust        command! -buffer        FmtRs     call FmtRust()
  function! FmtRust() abort
    update

    " 使用 rustfmt --emit=stdout 來 filter
    let l:cmd = 'rustfmt --emit=stdout'
    " 好像也能用以下的方式(沒試過)
    " let l:cmd = 'cargo fmt -- --emit=stdout'

    let l:output = system(l:cmd, join(getline(1, '$'), "\n"))

    if v:shell_error != 0
      " 錯誤時只顯示訊息，不修改 buffer
      echo "cargo fmt / rustfmt 執行失敗！"
      echomsg "❌ Error："
      for line in split(l:output, "\n")
        echomsg line
      endfor
      return
    endif

    " 成功才替換 buffer
    %delete _
    call setline(1, split(l:output, "\n"))
  endfunction
augroup END


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


" 移除每一列結尾多餘的空白
autocmd BufWritePre * %s/\s\+$//e


" 🟧 Plugin
packadd cfilter

augroup PluginBookmark
  " 存放書籤的字典
  let g:bookmarks = {}
  let g:bookmarks_file = expand('~/.vim/bookmarks.json')

  " 讀取書籤
  function! LoadBookmarks()
    if filereadable(g:bookmarks_file)
      let g:bookmarks = json_decode(join(readfile(g:bookmarks_file), ''))
    else
      let g:bookmarks = {}
    endif
  endfunction
  call LoadBookmarks()

  " 設定書籤 (:BkAdd Foo)
  command! -nargs=1 BkAdd call SetBookmark(<q-args>)
  function! SetBookmark(name)
    let g:bookmarks[a:name] = [expand('%:p'), getpos('.')]
    echo "Bookmarked: " . a:name
  endfunction

  " 刪除書籤( :BkRm Foo)
  command! -nargs=1 -complete=customlist,BookmarkComplete BkRm call RemoveBookmark(<q-args>)
  function! RemoveBookmark(name)
    if has_key(g:bookmarks, a:name)
      call remove(g:bookmarks, a:name)
      echo "Removed bookmark: " . a:name
    else
      echo "Bookmark not found: " . a:name
    endif
  endfunction

  " 跳到書籤 (:GotoBookmark Foo)
  command! -nargs=1 -complete=customlist,BookmarkComplete GotoBookmark call GotoBookmark(<q-args>)
  function! GotoBookmark(name)
    if has_key(g:bookmarks, a:name)
      let [file, pos] = g:bookmarks[a:name]
      exec 'edit ' . file
      call setpos('.', pos)
      "echo "Jumped to: " . a:name  " 如果加了會需要按下確認，會多一個動作
    else
      echo "Bookmark not found: " . a:name
    endif
  endfunction
  nnoremap <leader>bk :GotoBookmark<Space>

  " 補全功能
  function! BookmarkComplete(A, L, P)
    if empty(a:A)
      return keys(g:bookmarks)
    endif

    return matchfuzzy(keys(g:bookmarks), a:A)
  endfunction

  " 儲存到 viminfo 或檔案，讓重開 Vim 還在(它能保存全域變數，也就是g:的所有內容)
  " ! 這個旗標特別表示：儲存那些名稱以大寫字母開頭、且不含小寫字母的全域變數
  "set viminfo+=!  " 👈 沒用，還是沒辦法保存

  " 儲存書籤
  command! BkSave call SaveBookmarks()
  function! SaveBookmarks()
    let l:dir = fnamemodify(g:bookmarks_file, ':h')
    if !isdirectory(l:dir)
      call mkdir(l:dir, 'p')
    endif
    call writefile([json_encode(g:bookmarks)], g:bookmarks_file)
  endfunction

  autocmd VimLeave * call SaveBookmarks()
augroup END

augroup PluginHighlightSpecial
  autocmd!

  " 保存目前所有 match id
  let s:match_ids = []

  function! HighlightSpecialKeywords() abort
    "--------------------------------------------------
    " 清除舊的 match
    "--------------------------------------------------
    for id in s:match_ids
      silent! call matchdelete(id)
    endfor
    let s:match_ids = []

    "--------------------------------------------------
    " 全形空格 U+3000
    "--------------------------------------------------
    highlight CJKFullWidthSpace
          \ guifg=#00ffff
          \ guibg=#a6a6a6
          \ ctermfg=cyan
          \ ctermbg=gray

    call add(s:match_ids,
          \ matchadd('CJKFullWidthSpace', '　'))

    "--------------------------------------------------
    " 關鍵字
    "--------------------------------------------------
    let highlights = [
          \ ['NOTE',       '#FFFFFF', '#0000FF', '\<N[Oo][Tt][Ee]\>:\?'],
          \ ['USAGE',      '#FFFFFF', '#179797', '\<U[Ss][Aa][Gg][Ee]\>:\?'],
          \ ['TODO',       '#000000', '#8bb33d', '\<T[Oo][Dd][Oo]\>:\?'],
          \ ['WARNING',    '#020505', '#FFA500', '\<W[Aa][Rr][Nn]\(ing\)\?\>:\?'],
          \ ['FIXME',      '#F8F6F4', '#EA6890', '\<F[Ii][Xx][Mm][Ee]\>:\?'],
          \ ['TIP',        '#323225', '#99CC00', '\<T[Ii][Pp]\(s\)\?\>:\?'],
          \ ['IMPORTANT',  '#F1F2E6', '#FF00FF', '\<I[Mm][Pp][Oo][Rr][Tt][Aa][Nn][Tt]\>:\?'],
          \ ['ERROR',      '#F1F2E6', '#FF0000', '\<E[Rr][Rr]\(or\)\?\>:\?'],
          \ ['CAUTION',    '#F1F2E6', '#FF0000', '\<C[Aa][Uu][Tt][Ii][Oo][Nn]\>:\?'],
          \ ['DEPRECATED', '#FFFFFF', '#696969', '\<D[Ee][Pp][Rr][Ee][Cc][Aa][Tt][Ee][Dd]\>'],
          \ ]

    for hl in highlights
      let name = hl[0]
      let fg   = hl[1]
      let bg   = hl[2]
      let pat  = hl[3]

      execute printf(
            \ 'highlight %s guifg=%s guibg=%s ctermfg=white ctermbg=darkgray',
            \ name, fg, bg)

      call add(s:match_ids,
            \ matchadd(name, pat))
    endfor

    "--------------------------------------------------
    " ~~刪除線~~
    "--------------------------------------------------
    highlight STRIKETHROUGH
          \ guifg=#8b949e
          \ ctermfg=gray
          \ gui=strikethrough
          \ cterm=strikethrough

    call add(s:match_ids,
          \ matchadd(
          \   'STRIKETHROUGH',
          \   '\~\~.\{-\}\~\~'
          \ ))

    "--------------------------------------------------
    " URL
    "--------------------------------------------------
    highlight HYPERLINK
          \ guifg=#00c6ff
          \ ctermfg=cyan
          \ gui=underline
          \ cterm=underline

    call add(s:match_ids,
          \ matchadd(
          \   'HYPERLINK',
          \   '\<https\?:\/\/[a-zA-Z0-9#?./=_%:-]*\>'
          \ ))
  endfunction

  autocmd BufReadPost,BufNewFile * call HighlightSpecialKeywords()

  " 如果 colorscheme 改變，重新套用
  autocmd ColorScheme * call HighlightSpecialKeywords()

augroup END


" ============================================================
" Gitclist / Gitllist
"
" 將 git ls-files 結果放到:
"   Gitclist -> quickfix
"   Gitllist -> location list
"
" 支援:
"   --no-cd
"   -a ACTION
"   --action ACTION
"
" ACTION:
"   空白 = 新建
"   a    = append
"   r    = replace
"   u    = update
"   f    = free all
" ============================================================
augroup PluginGitlist
  autocmd!
  function! s:GitListToList(is_loclist, ...) abort
    let options = {
          \ 'action': ' ',
          \ 'cd': v:true,
          \ }

    let args = []

    let i = 0
    while i < len(a:000)
      let arg = a:000[i]

      if arg ==# '--no-cd'
        let options.cd = v:false

      elseif arg ==# '-a' || arg ==# '--action'
        let i += 1

        if i < len(a:000)
          let options.action = a:000[i]
        endif

      else
        call add(args, arg)
      endif

      let i += 1
    endwhile

    " 切換到目前檔案所在目錄
    if options.cd
      let l:old_cwd = getcwd()

      if expand('%') !=# ''
        execute 'cd' fnameescape(expand('%:p:h'))
      endif

      let l:git_root = substitute(
            \ system('git rev-parse --show-toplevel'),
            \ '\n\+$',
            \ '',
            \ '')

      if v:shell_error == 0
        execute 'cd' fnameescape(l:git_root)
      endif
    endif

    let l:cmd = 'git ls-files --full-name'

    if !empty(args)
      let l:cmd .= ' ' . join(args, ' ')
    endif

    let l:lines = systemlist(l:cmd)


    if a:is_loclist
      call setloclist(
            \ 0,
            \ [],
            \ options.action,
            \ {
            \  'title': l:cmd,
            \  'lines': l:lines,
            \  'efm': '%f',
            \ })

      lopen
    else
      call setqflist(
            \ [],
            \ options.action,
            \ {
            \  'title': l:cmd,
            \  'lines': l:lines,
            \  'efm': '%f',
            \ })

      copen
    endif

    if options.cd
      execute 'cd' fnameescape(l:old_cwd)
    endif
  endfunction

  function! s:GitListComplete(A, L, P) abort
    let l:cmdline = a:L

    " 補 action 參數
    if l:cmdline =~# '\v(--action|-a)\s+\S*$'
      return filter(
            \ ['a', 'r', 'u', 'f'],
            \ 'v:val =~ "^" . a:A'
            \ )
    endif

    " 補 option
    if a:A =~# '^-'
      return filter(
            \ [
            \ '--no-cd',
            \ '--action',
            \ '-a',
            \ ],
            \ 'v:val =~ "^" . a:A'
            \ )
    endif

    " 常用 git pathspec
    return filter(
          \ [
          \ "'*.md'",
          \ "'*.lua'",
          \ "'*.vim'",
          \ "'*keymap*'",
          \ "':!:node_modules'",
          \ "':!:vendor'",
          \ "':!:dist'",
          \ "':!:build'",
          \ "':!:*temp*'",
          \ "':!:*.min.js'",
          \ ],
          \ 'v:val =~ "^" . a:A'
          \ )
  endfunction

  command! -nargs=* -complete=customlist,s:GitListComplete Gitclist
        \ call s:GitListToList(v:false, <f-args>)

  command! -nargs=* -complete=customlist,s:GitListComplete Gitllist
        \ call s:GitListToList(v:true, <f-args>)

  " 底下也行，是簡易的版本
  "function! s:GitLsFiles(is_loclist, options)
  "  execute 'lcd' fnameescape(expand('%:h'))
  "  let l:output = system('git rev-parse --show-toplevel')
  "  if v:shell_error
  "    echo "Not a git repository or git command error"
  "    return
  "  endif
  "  let l:git_root = substitute(l:output , '\n$', '', '')
  "  execute 'lcd' fnameescape(l:git_root)
  "
  "  let l:cmd = 'git ls-files --full-name '
  "  let l:lines = systemlist(cmd)
  "
  "  let what = {
  "      \ 'title': cmd,
  "      \ 'lines': l:lines,
  "      \ 'efm': '%f'
  "      \ }
  "
  "  if a:is_loclist
  "      call setloclist(0, [], get(a:options, 'action', ' '), what)
  "      lopen
  "  else
  "      call setqflist([], get(a:options, 'action', ' '), what)
  "      copen
  "  endif
  "endfunction
  "command! Gitclist call s:GitLsFiles(v:false, {})
  "command! Gitllist call s:GitLsFiles(v:true, {})


  command! -nargs=* Gitfiles call GitFiles(<f-args>)
  " TODO: 當前還不能自動跳轉，要用gf才可以
  function! GitFiles(...) abort
    " 切換到目前檔案所在目錄
    execute 'lcd' expand('%:p:h')

    let git_root = substitute(
          \ system('git rev-parse --show-toplevel'),
          \ '\n$',
          \ '',
          \ '')

    if v:shell_error != 0
      echoerr 'Not in a Git repository'
      return
    endif

    execute 'lcd' git_root

    tabnew
    setlocal buftype=nofile

    let git_dirname = fnamemodify(git_root, ':t')
    execute 'file search git files:' . git_dirname

    if filereadable(expand('~/fzf/bin/fzf-preview.sh'))
      let preview_cmd =
            \ printf('--preview "%s {}"',
            \ expand('~/fzf/bin/fzf-preview.sh'))
    else
      let preview_cmd =
            \ '--preview "bat --color=always --style=numbers {}"'
    endif

    let cmd =
          \ 'git ls-files --exclude-standard --cached | ' .
          \ 'fzf --style full --multi ' .
          \ preview_cmd . ' ' .
          \ "--bind 'ctrl-q:select-all+accept'"

    let s:gitfiles_buf = bufnr('%')

    call term_start([&shell, &shellcmdflag, cmd], {
          \ 'exit_cb': function('GitFilesExit'),
          \ 'curwin': v:true,
          \ })

    startinsert
  endfunction

  function! GitFilesExit(job, status) abort
    let lines = getbufline(s:gitfiles_buf, 1, '$')

    call setqflist([], 'r')

    for filepath in lines
      if filereadable(filepath)
        call setqflist([
              \ {
              \ 'filename': filepath,
              \ 'text': filepath,
              \ }
              \ ], 'a')
      endif
    endfor

    let files = filter(copy(lines), 'v:val != ""')

    if !empty(files)
      execute 'edit' fnameescape(files[0])
    endif

    execute 'bwipeout!' s:gitfiles_buf
  endfunction

augroup END


" ==========================================================
" Copy file path / git path / git show command
" <leader>Y
" ==========================================================
augroup PluginCopyPath

  function! s:CopyPathMenu() abort
    let abs_path = expand('%:p')
    let filename = expand('%:t')

    let options = []
    let labels  = []

    " Absolute path
    call add(options, abs_path)
    call add(labels, 'Absolute Path: ' . abs_path)

    " Filename
    call add(options, filename)
    call add(labels, 'Filename: ' . filename)

    " --------------------------------------------------------
    " git relative path
    " --------------------------------------------------------

    let git_show_paths = []

    let cmd = 'git ls-files --full-name ' . shellescape(abs_path)
    let result = systemlist(cmd)

    if v:shell_error == 0 && !empty(result)
      let git_rel_path = result[0]

      call add(options, git_rel_path)
      call add(labels, 'Git Relative Path: ' . git_rel_path)

      " ------------------------------------------------------
      " latest commit sha
      " ------------------------------------------------------

      let sha_cmd =
            \ 'git log -n 1 --pretty=format:%H -- '
            \ . shellescape(abs_path)

      let sha_result = systemlist(sha_cmd)

      if !empty(sha_result)
        let sha = sha_result[0]

        " visual mode line range
        let start_line = line('v')
        let end_line   = line('.')

        if start_line > end_line
          let tmp = start_line
          let start_line = end_line
          let end_line = tmp
        endif

        for cur_sha in [sha, strpart(sha, 0, 8)]
          let git_show_cmd =
                \ printf(
                \ 'git show -p %s:%s | bat -l %s -P -r %d:%d',
                \ cur_sha,
                \ git_rel_path,
                \ &filetype,
                \ start_line,
                \ end_line
                \ )

          call add(git_show_paths, git_show_cmd)

          call add(options, git_show_cmd)
          call add(labels, ': ' . git_show_cmd)
        endfor
      endif
    endif

    " --------------------------------------------------------
    " menu
    " --------------------------------------------------------

    let menu = ['Choose path format to copy:']

    let idx = 1
    for label in labels
      call add(menu, printf('%d. %s', idx, label))
      let idx += 1
    endfor

    let choice = inputlist(menu)

    if choice < 1 || choice > len(options)
      return
    endif

    let selected = options[choice - 1]

    let @+ = selected

    echo '✅ Copied: ' . selected
  endfunction

  " Normal mode
  nnoremap <silent> <leader>Y :call <SID>CopyPathMenu()<CR>

  " Visual mode
  xnoremap <silent> <leader>Y :<C-U>call <SID>CopyPathMenu()<CR>

augroup END

augroup PluginLazygit
  function! OpenLazygit()
    " 1. 檢查是否安裝 lazygit
    if !executable('lazygit')
      echohl WarningMsg
      echo "lazygit not found. Please install it."
      echohl None
      return
    endif

    execute 'lcd' fnameescape(expand('%:p:h'))

    " 2. 獲取 Git 根目錄
    let l:git_root = system('git rev-parse --show-toplevel 2>/dev/null')
    let l:git_root = substitute(l:git_root, '\n$', '', '')

    if v:shell_error != 0
      echoerr "Not in a Git repository"
      return
    endif

    " 3. 切換目錄並打開新的 tab
    execute 'lcd ' . fnameescape(l:git_root)
    tabnew

    " 4. 設置 Terminal
    setlocal buftype=nofile
    " term " 這個在vi會分開一個新的視窗, 用++curwin可以直接在當前的win開啟
    :term ++curwin

    " 5. 設定標題
    let l:git_dirname = fnamemodify(l:git_root, ':t')
    execute 'file git:' . l:git_dirname

    " 6. 執行 lazygit
    " 在 Vim 中，term 打開後預設會處於 Terminal-Job 模式
    " 使用 feedkeys 來確保進入插入模式並執行指令
    " call feedkeys("i" . "lazygit --screen-mode half" . "\<CR>") " vi 進入 term 就會自動是i的模式
    call feedkeys("lazygit --screen-mode half" . "\<CR>")
  endfunction

  nnoremap <leader>git :call OpenLazygit()<CR>
augroup END


" <leader>st : 顯示 git status 中的檔案到 quickfix list，並開啟 quickfix window
nnoremap <silent> <leader>st :call GitStatusQuickfix()<CR>

augroup PluginGit
  autocmd!

  function! GitStatusQuickfix()
    execute 'lcd' fnameescape(expand('%:p:h'))

    let l:output = system('git status -s')
    if v:shell_error
      echo "Not a git repository or git command error"
      return
    endif

    let l:ll_list = []
    for line in split(l:output, "\n")
      let l:parts = split(line, '\s\+')
      if len(l:parts) >= 2
        let l:file = l:parts[-1] " 取最後一個欄位（檔案路徑）
        " 過濾掉 deleted 等無法跳轉的檔案
        "if l:file !~ '^\(D\|DD\)'
        if l:file !~ '^D'
          call add(l:ll_list, {'filename': l:file, 'text': line})
        endif
      endif
    endfor

    if empty(l:ll_list)
      echo "沒有需要處理的檔案"
      return
    endif

    "call setqflist(l:qf_list)
    call setloclist(0, l:ll_list)
    lopen
    lfirst
  endfunction

  "" 定義符號樣式 (在行號欄位顯示)
  "set signcolumn=yes
  "set updatetime=300
  "hi SignColumn guibg=NONE ctermbg=NONE
  "hi DiffAdd    ctermfg=Green  ctermbg=NONE
  "hi DiffChange ctermfg=Yellow ctermbg=NONE
  "hi DiffDelete ctermfg=Red    ctermbg=NONE
  sign define GitAdd    text=│ texthl=DiffAdd
  sign define GitChange text=│ texthl=DiffChange
  sign define GitDelete text=│ texthl=DiffDelete

  function! UpdateGitSigns()
    " 1. 取得當前 buffer 的編號與路徑
    let l:buf = bufnr('')
    let l:file = expand('%:p')

    " 若檔案不存在於磁碟上或為空，則跳過
    if empty(l:file) || !filereadable(l:file)
      return
    endif

    let l:group = 'GitSigns'
    " 先強制清除本 buffer 所有 signs (避免使用 :e 還有舊的殘留)
    " execute 'sign unplace * buffer=' . l:buf  " Warn不推清全部的，最好建一個group, 清除該group就好
    execute 'sign unplace * group=' . l:group . ' buffer=' . l:buf

    let l:diff = system('git --no-pager diff --no-color -U0 --relative -- ' . shellescape(l:file))
    if v:shell_error || empty(l:diff)
      return
    endif

    let l:lines = split(l:diff, '\n')
    "let l:id = 1
    let l:id = 10000000 + l:buf * 100000 " 每個buffer擁有自己的id
    "buffer 1 -> 1000000~1099999
    "buffer 2 -> 1100000~1199999
    "buffer 3 -> 1200000~1299999
    let l:current_line = 0
    let l:prev_was_delete = 0

    for l:line in l:lines
      if l:line =~ '^@@'
        " Parse hunk header: @@ -old_start,old_count +new_start,new_count @@
        let l:parts = matchlist(l:line, '^@@ -\d\+,\?\d* +\(\d\+\),\?\(\d*\) @@')
        if len(l:parts) >= 2
          let l:current_line = str2nr(l:parts[1])
          let l:prev_was_delete = 0
        endif
        continue
      endif

      if l:line =~ '^[ +]'
        if l:line[0] == '+'
          " Added line
          if l:prev_was_delete
            " 前一行是 delete → 這是 modified
            " TODO: 目前有的會重複，導致出現sign的問題: `E885: Not possible to change sign GitAdd` 目前先用silent!忽略錯誤
            execute printf('silent! sign place %d group=%s line=%d name=GitChange buffer=%d',
                  \ l:id, l:group, l:current_line, l:buf)
          else
            execute printf('silent! sign place %d group=%s line=%d name=GitAdd buffer=%d',
                  \ l:id, l:group, l:current_line, l:buf)
          endif
          let l:prev_was_delete = 0
        else
          " Context line (正常不會太多，因為 -U0)
          execute printf('silent! sign place %d group=%s line=%d name=GitChange buffer=%d',
                \ l:id, l:group, l:current_line, l:buf)
          let l:prev_was_delete = 0
        endif
        let l:id += 1
        let l:current_line += 1

      elseif l:line =~ '^-'
        " Deletion
        if !l:prev_was_delete
          execute printf('silent! sign place %d group=%s line=%d name=GitDelete buffer=%d',
                \ l:id, l:group, l:current_line, l:buf)
          let l:id += 1
        endif
        let l:prev_was_delete = 1
      endif
    endfor
  endfunction

  " 當存檔或進入緩衝區時自動更新
  autocmd BufReadPost,BufWritePost,CursorHold,CursorHoldI,BufEnter * call UpdateGitSigns()

  function! GitGutterJump(direction)
    " if &diff
    "   " 在diff模式下直接執行原生命令。詳: `:help diff` 再搜尋: &diff
    "   execute 'normal! ' . (a:direction == 'next' ? ']c' : '[c')
    "   return
    " endif

    execute 'lcd' fnameescape(expand('%:p:h'))

    " 執行 git diff 獲取異動行號 (Warn: 要用--no-pager, 避免有的是用gitdelta可能是不同的主題，輸出會抓不到)
    " 到grep '^@@的結果可能如下
    " @@ -1096,0 +1097 @@ augroup PluginGit
    " @@ -1128,0 +1130,45 @@ augroup PluginGit
    " 使用 awk 取出 @@ 行中，空格後面第二個欄位 (即 +1097, +1130 等) (分隔符空白)
    " 1097
    " 1130,45
    " 然後再用 sed 把 + 號去掉，只留下數字
    "let l:cmd = "git --no-pager diff -U0 --relative | grep '^@@' | awk '{print $3}' | sed 's/+//'"   👈 Warn這個沒有指定檔案, 多檔案跳轉之後就會亂掉
    let l:cmd = "git --no-pager diff -U0 --relative -- " . shellescape(expand('%')) . " | grep '^@@' | awk '{print $3}' | sed 's/+//'"

    let l:lines = split(system(l:cmd), '\n')

    if empty(l:lines)
      echo "No git changes found."
      return
    endif

    let l:curr = line('.')
    let l:target = 0

    if a:direction == 'next'
      for l:ln in l:lines
        if str2nr(l:ln) > l:curr
          let l:target = str2nr(l:ln)
          break
        endif
      endfor
    else " prev
      for l:ln in reverse(l:lines)
        if str2nr(l:ln) < l:curr
          let l:target = str2nr(l:ln)
          break
        endif
      endfor
    endif

    if l:target != 0
      execute 'normal! ' . l:target . 'G'
    else
      echo "No more changes in this direction."
    endif
  endfunction
  " nnoremap ]c :call GitGutterJump('next')<CR>
  " nnoremap [c :call GitGutterJump('prev')<CR>
  " 用以下的方式更好, 就不需要將&diff的判斷寫在 GitGutterJump 之中
  nnoremap <expr> ]c &diff ? ']c' : ':call GitGutterJump("next")<CR>'
  nnoremap <expr> [c &diff ? '[c' : ':call GitGutterJump("prev")<CR>'
augroup END

" ============================================================
" Markdown
" ============================================================
augroup PluginMarkdownPreview
  autocmd!
  autocmd FileType markdown call MarkdownSetup()
  "autocmd FileType markdown call GenerateMarkdownTOC() " 要用到的時候在自動建會比較好

  function! MarkdownSetup()
    " 摺疊 Markdown 標題
    setlocal foldmethod=expr
    setlocal foldexpr=MarkdownFold(v:lnum)
    normal! zR
  endfunction

  function! MarkdownFold(lnum)
    let line = getline(a:lnum)

    if line =~ '^# '
      return '>1'
    elseif line =~ '^## '
      return '>2'
    elseif line =~ '^### '
      return '>3'
    elseif line =~ '^#### '
      return '>4'
    elseif line =~ '^##### '
      return '>5'
    elseif line =~ '^###### '
      return '>6'
    endif

    return '='
  endfunction

  autocmd FileType markdown command! -buffer MdRead call MarkdownReadMode()
  function! MarkdownReadMode()
    "" 自動換行
    setlocal wrap

    "" 單字邊界換行，不會切到單字中間
    setlocal linebreak

    " 保留縮排
    setlocal breakindent

    " 顯示目前所在行
    setlocal cursorline

    " 不顯示空白字元
    setlocal nolist

    " 不顯示行號
    setlocal nonumber
    setlocal norelativenumber

    " 預設展開所有內容
    normal! zR

    "set foldcolumn=0
    "set signcolumn=no
    "set laststatus=0
    "set cmdheight=1

    " 搜尋時置中
    "nnoremap <buffer> n nzzzv
    "nnoremap <buffer> N Nzzzv

    " Space 可以快速往下翻頁
    nnoremap <buffer> <Space> <C-d>

    " Backspace 往上翻頁
    nnoremap <buffer> <BS> <C-u>

    " Tab 展開/收合標題
    nnoremap <buffer> <Tab> za
  endfunction

  autocmd FileType markdown command! -buffer MdTOC call GenerateMarkdownTOC()
  "function! GenerateMarkdownTOC()
  "  silent! execute 'lvimgrep /^#\+\s\+/ %'
  "  lopen
  "endfunction

  function! GenerateMarkdownTOC()
    let lines = getline(1, '$')
    let toc = []
    let in_code = 0
    for i in range(len(lines))
      if lines[i] =~ '^\s*```'
        let in_code = !in_code
      elseif !in_code && lines[i] =~ '^#\+\s\+'
        call add(toc, {'bufnr': bufnr('%'), 'lnum': i + 1, 'text': lines[i]})
      endif
    endfor
    call setloclist(0, toc)
    lopen
  endfunction
augroup END


augroup MarkdownConceal
  autocmd!
  autocmd FileType markdown call MarkdownConceal()
augroup END

function! MarkdownConceal()
  " Note: conceallevel=2 會自動做 bold, italic
  setlocal conceallevel=2

  "" Link & Image
  ""syntax match MdLink /\[[^]]*\](.\{-})/ conceal cchar=🌐  " 這樣會連網址加內容都變成🌐
  "
  " 以下的方式各別跑可行，但是合在一起，image就會受到連結的影響而被取代
  "syntax region MdLink
  "    \ start='\['
  "    \ end=')'
  "    \ contains=MdLinkOpen,MdLinkClose
  "syntax match MdLinkOpen '\[' conceal cchar=🌐 contained
  "syntax match MdLinkClose '\](.\{-})' conceal contained
  "
  "syntax region MdImage
  "    \ start='\!'
  "    \ end=')'
  "    \ contains=MdImageOpen,MdLinkClose
  "syntax match MdImageOpen '!\[' conceal cchar=🖼️ contained

  " 使用 \@<! 來表示「前面不是 !」的零寬斷言 (Negative Lookbehind), 使得連結要符合前面非`!` 使得image不會受到影響
  syntax region MdLink
        \ start='\%(!\)\@<!\[.*]('
        \ end=')'
        \ contains=MdLinkOpen,MdLinkClose
        \ keepend

  syntax match MdLinkOpen '\%(!\)\@<!\[' conceal cchar=🌐 contained
  syntax match MdLinkClose '\](.\{-})' conceal contained

  " 圖片的定義保持原樣，因為它明確指定了以 ! 開頭
  syntax region MdImage
        \ start='!'
        \ end=')'
        \ contains=MdImageOpen,MdLinkClose
        \ keepend
  "syntax match MdImageOpen '!\[' conceal cchar=🖼️ contained   " Warn: 🖼️ 這個有兩個unicode碼點組成，所以cchar取代能用，但是會不全
  " 🌇 🌅
  syntax match MdImageOpen '!\[' conceal cchar=🌇 contained


  " Checkbox  " Note: 需要在MdLink, MdImage之後，不然會被Link影響到
  syntax match MdTodoOpen '\[ \]' conceal cchar=🔳
  syntax match MdTodoDone '\[x\]' conceal cchar=✅
  syntax match MdTodoDone '\[X\]' conceal cchar=✅

  " 👇 這很重要，如果conceal有用空白，它就有可能會吃到背景色, 因為可以將Conceal的顏色都關掉
  hi Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

  " 可行，但是cchar只能一個碼點，要多個需要用以下的方法
  "syntax match MdH1Mark '^# '      conceal contained cchar=󰲡
  "syntax match MdH2Mark '^## '     conceal contained cchar=󰲣
  "syntax match MdH3Mark '^### '    conceal contained cchar=󰲥
  "syntax match MdH4Mark '^#### '   conceal contained cchar=󰲧
  "syntax match MdH5Mark '^##### '  conceal contained cchar=󰲩
  "syntax match MdH6Mark '^###### ' conceal contained cchar=󰲫

  " Header Mark (Important: 當一個syntax可能也會有其它的syntax相衝，要用contains才會有多個效果)
  syntax match MdH1Head contained "#" conceal cchar=󰲡
  "syntax match MdHeadingTail contained ' ' conceal cchar=    " 可行，但是最後面的空白打不出來(假設結尾空白會自動去除), 所以用exectue來輔助
  execute printf("syntax match MdHeadingTail contained ' ' " . "conceal cchar= ")
  syntax match MdH1Mark '^# '      contains=MdH1Head,MdHeadingTail

  syntax match MdH2Head contained "##"     conceal cchar=󰲣
  syntax match MdH3Head contained "###"    conceal cchar=󰲥
  syntax match MdH4Head contained "####"   conceal cchar=󰲧
  syntax match MdH5Head contained "#####"  conceal cchar=󰲩
  syntax match MdH6Head contained "######" conceal cchar=󰲫

  syntax match MdH2Mark '^## '     contains=MdH2Head,MdHeadingTail
  syntax match MdH3Mark '^### '    contains=MdH3Head,MdHeadingTail
  syntax match MdH4Mark '^#### '   contains=MdH4Head,MdHeadingTail
  syntax match MdH5Mark '^##### '  contains=MdH5Head,MdHeadingTail
  syntax match MdH6Mark '^###### ' contains=MdH6Head,MdHeadingTail

endfunction

" ============================================================
" Markdown 顏色強化
" ============================================================
augroup MarkdownHighlight
  autocmd!
  autocmd FileType markdown call MarkdownHighlight()
  function! MarkdownHighlight()
    "--- Level 1: 主標題 (紅色系) ---
    "syntax match MdH1 /^# .*$/
    syntax match MdH1 /^# .\{0,120}\.*$/  contains=MdH1Mark
    "hi default link MdH1 Normal
    "hi MdH1 gui=bold guifg=#ff5f87
    hi MdH1 gui=bold guifg=#ff7f69 guibg=#3e2b2f

    " --- Level 2: 副標題 (藍色系) ---
    syntax match MdH2 /^## .\{0,120}\.*$/ contains=MdH2Mark
    "hi default link MdH2 Normal
    "hi MdH2 gui=bold guifg=#50fa7b
    hi MdH2 gui=bold guifg=#4fa3d1 guibg=#2c4556

    " --- Level 3: 章節標題 (橘色系) ---
    syntax match MdH3 /^### .\{0,120}\.*$/ contains=MdH3Mark
    "hi default link MdH3 Normal
    "hi MdH3 gui=bold guifg=#ffcb6b
    hi MdH3 gui=bold guifg=#57a68d guibg=#3a4e3c

    " --- Level 4: 子標題 (紫色系) ---
    syntax match MdH4 /^#### .\{0,120}\.*$/ contains=MdH4Mark
    "hi default link MdH4 Normal
    "hi MdH4 gui=bold guifg=#c678dd
    hi MdH4 gui=bold guifg=#9b72aa guibg=#3a2e44

    " --- Level 5 & 6: 細節標題 (淡紫/粉紅系) ---
    syntax match MdH5 /^##### .\{0,120}\.*$/ contains=MdH5Mark
    "hi default link MdH5 Normal
    "hi MdH5 gui=bold guifg=#ff79c6
    hi MdH5 gui=bold guifg=#c0c0c0 guibg=#4a3b5e

    syntax match MdH6 /^###### .\{0,120}\.*$/ contains=MdH6Mark
    "hi default link MdH6 Normal
    "hi MdH6 gui=bold guifg=#b16286
    hi MdH6 gui=bold guifg=#b16286 guibg=#3a2e3c

    " Code Block
    syntax region MdCodeBlock
          \ start=/^\s*```/
          \ end=/^\s*```/

    hi default MdCodeBlock ctermbg=236 guibg=#37365c

    "syntax match MdInlineMark '`' conceal  " Important: 當沒有設定contained時, 它就會都能套用，當設定了contained，就只有用到contains此項目的內容才會套用
    syntax match MdInlineMark '`' conceal contained
    "syntax match MdInlineCode /`[^`]\+`/  " 可行，但是頭尾的`都還看的到
    syntax match MdInlineCode /`[^`]\+`/ contains=MdInlineMark
    hi default MdInlineCode ctermfg=220 guifg=#f1fa8c

  endfunction
augroup END


" ============================================================
" Rg Command
" :Rg Test -g '*.go'
"
" TODO: 當前選完之後要用 gF 來手動跳轉
" ============================================================
augroup PluginRg
  autocmd!
  let s:rg_buf = -1
  let s:rg_is_files = 0
  command! -nargs=* Rg call Rg(<q-args>)
augroup END

function! Rg(args) abort
  if !executable('rg')
    echohl ErrorMsg
    echom 'rg not found'
    echohl None
    finish
  endif

  if !executable('fzf')
    echohl ErrorMsg
    echom 'fzf not found'
    echohl None
    finish
  endif

  execute 'lcd' expand('%:p:h')

  let git_root = substitute(
        \ system('git rev-parse --show-toplevel'),
        \ '\n$',
        \ '',
        \ '')

  if v:shell_error == 0
    execute 'lcd' git_root
  endif

  tabnew
  setlocal buftype=nofile

  let s:rg_buf = bufnr('%')

  let s:rg_is_files = a:args =~# '--files'

  if filereadable(expand('~/fzf/bin/fzf-preview.sh'))
    let preview_cmd =
          \ printf(
          \ '--preview "%s {}"',
          \ expand('~/fzf/bin/fzf-preview.sh')
          \ )
  else
    let preview_cmd =
          \ '--preview "bat --color=always --style=numbers {}"'
  endif

  if s:rg_is_files

    let cmd =
          \ 'rg ' . a:args .
          \ ' | fzf --style full --multi ' .
          \ preview_cmd . ' ' .
          \ "--bind 'ctrl-q:select-all+accept'"

  else

    let cmd =
          \ 'rg --vimgrep ' . a:args .
          \ ' | fzf ' .
          \ '--delimiter=: ' .
          \ '--multi ' .
          \ '--preview-window=right:+{2} ' .
          \ '--preview "bat --color=always --style=numbers --highlight-line {2} {1}" ' .
          \ "--bind 'ctrl-q:select-all+accept'"

  endif

  call term_start(
        \ [&shell, &shellcmdflag, cmd],
        \ {
        \ 'curwin': v:true,
        \ 'exit_cb': function('RgExit')
        \ })

  startinsert

endfunction

function! RgExit(job, status) abort
  let lines = getbufline(s:rg_buf, 1, '$')
  " 1. 先清理所有 ANSI 與特殊字元 即: 如果行首包含非字母/路徑符號，直接將其截斷 (使得不會將視覺指標也算進去)
  call map(lines, 'substitute(v:val, "\e\\[[0-9;]*[mK]", "", "g")')
  call map(lines, 'trim(v:val)') " 移除前後空白
  let lines = filter(lines, '!empty(v:val)')

  if empty(lines) | return | endif

  call setqflist([], 'r')

  " 處理邏輯
  for line in lines
    " 這裡將正規表示式改得更有彈性
    " 嘗試匹配：路徑:行號:列號 或 純路徑
    let m = matchlist(line, '\v^([^:]+):?(\d+)?:?(\d+)?:?(.*)$')

    if empty(m) | continue | endif

    let lnum = !empty(m[2]) ? str2nr(m[2]) : 1
    let col = !empty(m[3]) ? str2nr(m[3]) : 1

    call setqflist([
          \ {
          \ 'filename': m[1],
          \ 'lnum': lnum,
          \ 'col': col,
          \ 'text': m[4]
          \ }
          \ ], 'a')
  endfor

  " 確保 Quickfix 列表不為空
  let qf_list = getqflist()
  if empty(qf_list)
    return
  endif

  let target = qf_list[0]

  " 檢查 filename 是否為字串且存在
  if has_key(target, 'filename') && !empty(target.filename)
    let fname = target.filename
    " 確保路徑是絕對路徑或正確的相對路徑
    execute 'edit' fnameescape(fname)

    " 跳轉到行與列 (如果沒有值則預設為 1)
    let lnum = get(target, 'lnum', 1)
    let col = get(target, 'col', 1)
    call cursor(lnum, col)
  else
    echom "Error: target.filename is missing or empty"
    echom "Target content: " . string(target)
  endif
endfunction
