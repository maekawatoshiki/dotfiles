if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.dein')
  call dein#begin('~/.dein')

  call dein#add('~/.dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  " my own plugins
  call dein#add('scrooloose/nerdtree'                 , {'lazy': 1})
  call dein#add('luochen1990/rainbow'                 , {'lazy': 1})
  call dein#add('ctrlpvim/ctrlp.vim'                  , {'lazy': 1})
  call dein#add('h1mesuke/vim-alignta'                , {'lazy': 1})
  call dein#add('tpope/vim-fugitive'                  , {'lazy': 1})
  call dein#add('rhysd/wandbox-vim'                   , {'lazy': 1})
  call dein#add('thinca/vim-ref'                      , {'lazy': 1})
  call dein#add('justmao945/vim-clang'                , {'lazy': 1})
  call dein#add('mattn/vim-vimstreamer'               , {'lazy': 1})
  call dein#add('rhysd/github-complete.vim'           , {'lazy': 1})
  call dein#add('octol/vim-cpp-enhanced-highlight'    , {'lazy': 1})
  call dein#add('vim-scripts/taglist.vim'             , {'lazy': 1})
  call dein#add('kannokanno/previm'                   , {'lazy': 1})
  call dein#add('tyru/open-browser.vim'               , {'lazy': 1})
  call dein#add('kana/vim-submode'                    , {'lazy': 1})
  call dein#add('nathanaelkane/vim-indent-guides'     , {'lazy': 1})
  call dein#add('airblade/vim-gitgutter'              , {'lazy': 1})
  call dein#add('itchyny/lightline.vim'               , {'lazy': 1})
  call dein#add('tyru/caw.vim'                        , {'lazy': 1})
  call dein#add('rust-lang/rust.vim'                  , {'lazy': 1})
  call dein#add('rust-lang-nursery/rustfmt'           , {'lazy': 1})
  call dein#add('prabirshrestha/async.vim'            , {'lazy': 1})
  call dein#add('prabirshrestha/vim-lsp'              , {'lazy': 1})
  call dein#add('prabirshrestha/asyncomplete.vim'     , {'lazy': 1})
  call dein#add('prabirshrestha/asyncomplete-lsp.vim' , {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable
colorscheme deus
set termguicolors
set belloff=all
set rnu
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set noswapfile
set noexpandtab
set hlsearch
set title
set nowrap
set expandtab
" let lisp_rainbow=1
let g:rainbow_active=1
nnoremap / /\v
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-b> :RustFmt<CR>:w<CR>
nnoremap vg :vimgrep /\v
nnoremap s :%s /
nnoremap ,t :tabnew<CR>
nnoremap ,tq :tabclose<CR>
nnoremap ,n gt
nnoremap ,a ggVG
nnoremap M gt
nnoremap N gT
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>
set backspace=indent,eol,start 

" NERDTree 
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" vim-cpp-enhanced-highlight 
let g:cpp_class_scope_highlight = 1
" caw.vim
nmap ,c <Plug>(caw:hatpos:toggle)
vmap ,c <Plug>(caw:hatpos:toggle)
" taglist.vim
let Tlist_Use_Right_Window = 1                    
let Tlist_Exit_OnlyWindow = 1                
nnoremap tt :TlistToggle<CR>   
" open-browser.vim
au BufRead,BufNewFile *.md set filetype=markdown
" lightline settings
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [
      \							['mode', 'paste'], 
      \							['gitgutter', 'fugitive', 'filename'] 
      \						]
      \ },
      \ 'component_function': {
      \		'gitgutter': 'MyGitGutter'
      \ }
      \ }
" rust
if executable('rls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif 
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'
" git
function! MyGitGutter()
	if ! exists('*GitGutterGetHunkSummary')
				\ || ! get(g:, 'gitgutter_enabled', 0)
				\ || winwidth('.') <= 90
		return ''
	endif
	let symbols = [
				\ g:gitgutter_sign_added . ' ',
				\ g:gitgutter_sign_modified . ' ',
				\ g:gitgutter_sign_removed . ' '
				\ ]
	let hunks = GitGutterGetHunkSummary()
	let ret = []
	for i in [0, 1, 2]
		if hunks[i] > 0
			call add(ret, symbols[i] . hunks[i])
		endif
	endfor
	return join(ret, ' ')
endfunction

function! OpenModifiableQF()
	cw
	set modifiable
	set nowrap
endfunction
" submode settings
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')
" tab-related settings
command! SS call g:Sessionsave()
function! g:Sessionsave() 
	mks!  ~/.vimsession
endfunction

command! Q call g:Exitvim()
function! g:Exitvim()
	:tabo
	:q
endfunction

autocmd VimEnter * nested if @% == '' && s:GetBufByte() == 0 | source ~/.vimsession | endif

function! s:GetBufByte()
	let byte = line2byte(line('$') + 1)
	if byte == -1
		return 0
	else
		return byte - 1
	endif
endfunction
