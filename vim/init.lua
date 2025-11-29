vim.loader.enable()

vim.cmd [[
    let g:python3_host_prog = 'python3'

    set nobackup
    set nowritebackup
    set autoindent
    set smartindent
    set tabstop=2
    set shiftwidth=2
    set noswapfile
    set hlsearch
    set title
    set nowrap
    set expandtab
    nnoremap / /\v
    nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
    nnoremap vg :vimgrep /\v
    nnoremap s :%s /
    nnoremap ,t :tabnew<CR>
    nnoremap ,tq :tabclose<CR>
    nnoremap ,n gt
    nnoremap ,a ggVG
    " nnoremap M gt
    " nnoremap N gT
    imap <C-j> <Down>
    imap <C-k> <Up>
    imap <C-h> <Left>
    imap <C-l> <Right>
    nmap j gj
    nmap k gk
    nnoremap <C-k> gt
    nnoremap <C-n> gT
    set backspace=indent,eol,start
    set rnu
    " For colorscheme
    set t_Co=256
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set background=dark
    set list
    set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
    set pumblend=10
    set cursorline
    hi CursorLineNr cterm=NONE ctermfg=232
    set clipboard+=unnamedplus

    lua require('plugins')

    autocmd BufReadPost *
          \ if line("'\"") > 0 && line ("'\"") <= line("$") |
          \   exe "normal! g'\"" |
          \ endif
    autocmd BufRead,BufNewFile *.cl setfiletype opencl
    autocmd BufRead,BufNewFile *.lalrpop setfiletype rust
    autocmd BufRead,BufNewFile *.ll setfiletype llvm
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.tex nmap <C-c> <plug>(vimtex-compile)
    autocmd BufNewFile,BufRead *.zsh-theme setfiletype bash

    autocmd BufNewFile,BufRead *.vsm setfiletype bash
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " Force quit by :Q
    command! Q call g:Exitvim()
    function! g:Exitvim()
        :qa
    endfunction

    " Save session by :SS
    command! SS call g:Sessionsave()
    function! g:Sessionsave()
        mks!  ~/.vimsession
    endfunction
    function! s:GetBufByte()
        let byte = line2byte(line('$') + 1)
        if byte == -1
            return 0
        else
            return byte - 1
        endif
    endfunction
    autocmd VimEnter * nested if @% == '' && s:GetBufByte() == 0 | source ~/.vimsession | endif

    filetype plugin indent on
    syntax enable
    colorscheme everforest
]]

