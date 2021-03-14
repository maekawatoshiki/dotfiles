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
let lisp_rainbow=1
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
set rnu
" colorscheme
set t_Co=256
colorscheme rigel
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark

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

" NeoBundle 'tyru/eskk.vim'
" let g:eskk#directory = "~/.eskk"
" let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8', }
" let g:eskk#large_dictionary = { 'path': "~/.eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
" let g:eskk#enable_completion = 1
NeoBundle 'lervag/vimtex'
let g:vimtex_compiler_latexmk = { 'continuous' : 0 }
let g:vimtex_quickfix_open_on_warning = 0
let g:tex_flavor = "latex"
" let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
augroup set_latex_compiler
	autocmd!
	autocmd BufNewFile,BufRead *.tex nmap <C-c> <plug>(vimtex-compile)
augroup END

filetype plugin indent on

" Golang
NeoBundle 'fatih/vim-go'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
" autocmd BufNewFile,BufRead *.go nmap <C-b> <plug>(vimtex-compile)

NeoBundle 'rhysd/vim-llvm'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'qnighy/satysfi.vim'
NeoBundle 'luochen1990/rainbow'
let g:rainbow_active = 1
NeoBundle 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/](\.(git|hg|svn))$',
			\ }
"			\ 'dir':  '\v[\/](target|\.(git|hg|svn))$',

NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'rhysd/wandbox-vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'justmao945/vim-clang'
NeoBundle 'mattn/vim-vimstreamer'
NeoBundle 'rhysd/github-complete.vim'
NeoBundleLazy 'vim-jp/cpp-vim', {
			\ 'autoload' : {'filetypes' : 'cpp'}
			\ }
NeoBundle 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
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

" NeoBundle 'marcus/rsense'

" for Rust
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'rust-lang-nursery/rustfmt'
" NeoBundle 'prabirshrestha/async.vim'
" NeoBundle 'prabirshrestha/vim-lsp' , {'rev': "83a3a2b004316dcc89ce33b695c4cda8a54f0d79"}
" NeoBundle 'prabirshrestha/asyncomplete.vim'
" NeoBundle 'prabirshrestha/asyncomplete-lsp.vim'
NeoBundle 'neoclide/coc.nvim', 'v0.0.80'
", '060b292e1c0d3b9233cb71fa662d0584309bdd20'

if executable('rls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'rls',
				\ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
				\ 'whitelist': ['rust'],
				\ })
    au FileType rust setlocal omnifunc=lsp#complete
endif 

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
" let g:asyncomplete_popup_delay = 200
" let g:lsp_text_edit_enabled = 1


" let g:LanguageClient_autoStart = 
" for vim-racer
" NeoBundle 'racer-rust/vim-racer'
set hidden
" let g:racer_cmd = "/home/unsigned/.cargo/bin/racer"
" let g:racer_experimental_completer = 1

" for rustfmt
" let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'

call neobundle#end()

NeoBundleCheck

" RSense
let g:rsenseHome = '/usr/local/lib/rsense-0.3/bin'
let g:rsenseUseOmniFunc = 1

" NERDTree settings
nnoremap <silent><C-e> :NERDTreeToggle<CR>

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

" let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_cpp_compiler_options = '-std=c++14 -Iinclude -I/home/unsigned/work/llvm-project'
" let g:clang_cpp_options = '-std=c++14 -Iinclude -I/home/unsigned/work/llvm-project'
let g:clang_periodic_quickfix = 0
let g:clang_complete_copen = 1
let g:clang_complete_auto = 1
let g:clang_use_library = 1
let g:clang_format_auto = 0
let g:clang_format#enable_fallback_style = 0

let g:clang_library_path = '/usr/lib/llvm-11/lib'
" specify compiler options
let g:clang_user_options = '-std=c++14 `llvm-config-11 --cppflags`'
let g:clang_cpp_options = '-std=c++14 `llvm-config-11 --cppflags`'
let g:clang_auto = 0
let g:clang_complete_auto = 0
let g:clang_auto_select = 0

syntax on
syntax enable

