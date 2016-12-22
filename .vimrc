set autoindent
set smartindent
set number
set tabstop=2
set shiftwidth=2
set noswapfile
set noexpandtab
set hlsearch
set title
set nowrap
set expandtab
let lisp_rainbow=1
syntax on
nnoremap / /\v
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
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
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" colorscheme
set background=dark
colorscheme solarized8_dark
set termguicolors
set t_Co=256

" if (empty($TMUX))
" 	if (has("nvim"))
" 		"For Neovim 0.1.3 and 0.1.4 <
" 		"https://github.com/neovim/neovim/pull/2198 >
" 		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" 	endif
" 	if (has("termguicolors"))
" 		set termguicolors
" 	endif
" endif
" line highlight
set cursorline
hi CursorLineNr cterm=NONE ctermfg=232

if has("autocmd")
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   exe "normal! g'\"" |
		\ endif
endif

" Setting NeoBundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" add plugins here
" NeoBundle 'vim-jp/cpp-vim'
" NeoBundle 'scrooloose/syntastic.git'
" let g:syntastic_check_on_wq = 0
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'rhysd/wandbox-vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'justmao945/vim-clang'
NeoBundle 'mattn/vim-vimstreamer'
" NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'rhysd/github-complete.vim'
NeoBundleLazy 'vim-jp/cpp-vim', {
            \ 'autoload' : {'filetypes' : 'cpp'}
            \ }
NeoBundle 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
NeoBundle 'Shougo/neoinclude.vim'
NeoBundle 'Shougo/vimproc'
" NeoBundle 'tomtom/tcomment_vim'
NeoBundle "tyru/caw.vim.git"
nmap ,c <Plug>(caw:hatpos:toggle)
vmap ,c <Plug>(caw:hatpos:toggle)
NeoBundle 'vim-scripts/taglist.vim'
let Tlist_Use_Right_Window = 1                    
let Tlist_Exit_OnlyWindow = 1                
nnoremap tt :TlistToggle<CR>   
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
au BufRead,BufNewFile *.md set filetype=markdown

NeoBundle 'kana/vim-submode'
NeoBundle 'nathanaelkane/vim-indent-guides' 
" let g:indent_guides_enable_on_vim_startup=1
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" NERDTree settings
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" lightline settings
set laststatus=2
let g:lightline = {
			\ 'colorscheme': 'default',
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

autocmd QuickfixCmdPost vimgrep call OpenModifiableQF()

" setting for gvim
set guifont=ubuntu\ mono\ 13

" submode settings
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')

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


function! s:get_syn_id(transparent)
	let synid = synID(line("."), col("."), 1)
	if a:transparent
		return synIDtrans(synid)
	else
		return synid
	endif
endfunction
function! s:get_syn_attr(synid)
	let name = synIDattr(a:synid, "name")
	let ctermfg = synIDattr(a:synid, "fg", "cterm")
	let ctermbg = synIDattr(a:synid, "bg", "cterm")
	let guifg = synIDattr(a:synid, "fg", "gui")
	let guibg = synIDattr(a:synid, "bg", "gui")
	return {
				\ "name": name,
				\ "ctermfg": ctermfg,
				\ "ctermbg": ctermbg,
				\ "guifg": guifg,
				\ "guibg": guibg}
endfunction
function! s:get_syn_info()
	let baseSyn = s:get_syn_attr(s:get_syn_id(0))
	echo "name: " . baseSyn.name .
				\ " ctermfg: " . baseSyn.ctermfg .
				\ " ctermbg: " . baseSyn.ctermbg .
				\ " guifg: " . baseSyn.guifg .
				\ " guibg: " . baseSyn.guibg
	let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
	echo "link to"
	echo "name: " . linkedSyn.name .
				\ " ctermfg: " . linkedSyn.ctermfg .
				\ " ctermbg: " . linkedSyn.ctermbg .
				\ " guifg: " . linkedSyn.guifg .
				\ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:clang_periodic_quickfix = 0
let g:clang_complete_copen = 1
let g:clang_complete_auto = 1
let g:clang_use_library = 1

let g:clang_library_path = '/usr/lib/llvm-3.5/lib'
" specify compiler options
let g:clang_user_options = '-std=c++11 `llvm-config-3.5 --cppflags`'
let g:clang_cpp_options = '-std=c++11 `llvm-config-3.5 --cppflags`'
let g:clang_auto = 0
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
