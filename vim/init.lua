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
    set pumblend=30
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

    function TabsOrSpaces()
        " Determines whether to use spaces or tabs on the current buffer.
        if getfsize(bufname("%")) > 256000
            " File is very large, just use the default.
            return
        endif

        let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
        let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))

        if numTabs > numSpaces
            setlocal noexpandtab
        endif
    endfunction

    autocmd BufReadPost * call TabsOrSpaces()

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

    " function! MyGitGutter()
    " 	if ! exists('*GitGutterGetHunkSummary')
    " 				\ || ! get(g:, 'gitgutter_enabled', 0)
    " 				\ || winwidth('.') <= 90
    " 		return ''
    " 	endif
    " 	let symbols = [
    " 				\ g:gitgutter_sign_added . ' ',
    " 				\ g:gitgutter_sign_modified . ' ',
    " 				\ g:gitgutter_sign_removed . ' '
    " 				\ ]
    " 	let hunks = GitGutterGetHunkSummary()
    " 	let ret = []
    " 	for i in [0, 1, 2]
    " 		if hunks[i] > 0
    " 			call add(ret, symbols[i] . hunks[i])
    " 		endif
    " 	endfor
    " 	return join(ret, ' ')
    " endfunction

    filetype plugin indent on
    syntax enable
    colorscheme caret
]]

