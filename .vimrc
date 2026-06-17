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

set foldcolumn=0  " 不顯示, 要的時候再自己設定. 比較常用的是2
" 設定 foldlevel 0~9
for i in range(0, 9)
    execute printf('nnoremap <leader>fl%d :set foldlevel=%d<CR>', i, i)
    execute printf('nnoremap <leader>fc%d :set foldcolumn=%d<CR>', i, i)
endfor

" 🟧 indent_size, indent_style
set tabstop=2         " Tab鍵等於2個空白
set softtabstop=2     " 在插入模式下，Tab鍵也等於2空白
set shiftwidth=2      " 自動縮進時使用 2 個空白
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
set statusline+=%{indent('.')}
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
" :help hi
" Warn: 是用NONE而不是None
" highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=white
" highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=white
 "highlight CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=NONE " ctermfg 用None才不會影響到syntax的突顯
 "highlight CursorColumn cterm=NONE ctermbg=DarkGray ctermfg=NONE
highlight CursorLine     cterm=NONE guibg=#333333  ctermfg=NONE
highlight CursorColumn   cterm=NONE guibg=#2f3e54  ctermfg=NONE

highlight IncSearch guifg=#161b22 guibg=#f0883e
highlight Visual    guifg=#ffffff guibg=#78120d

" 🟧 keymap
nnoremap Q :q<CR>

nnoremap <A-w> <C-w>w<CR>
nnoremap <A-h> <C-w>h<CR>
nnoremap <A-j> <C-w>j<CR>
nnoremap <A-k> <C-w>k<CR>
nnoremap <A-l> <C-w>l<CR>

nnoremap <leader><leader>t :term<CR>

nnoremap <leader>/ :nohlsearch<CR>

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
