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

if has("autocmd")
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line ("'\"") <= line("$") |
				\   exe "normal! g'\"" |
				\ endif
  autocmd BufRead,BufNewFile *.cl setfiletype opencl
  autocmd BufRead,BufNewFile *.lalrpop setfiletype rust
  autocmd BufRead,BufNewFile *.ll setfiletype llvm
endif

" Setting NeoBundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundleLazy 't9md/vim-quickhl'

" Highlight the selected word
nmap <Space>m <Plug>(quickhl-manual-this)
" Highlight the selected text
xmap <Space>m <Plug>(quickhl-manual-this)
" Disable all highlights
nmap <Space>M <Plug>(quickhl-manual-reset)


" NeoBundle 'tyru/skk.vim'
" let skk_large_jisyo = '~/work/playground/SKK-JISYO.L'

" Toml
NeoBundle 'cespare/vim-toml'

" Colorscheme
" NeoBundle 'tyrannicaltoucan/vim-deep-space'
" NeoBundle 'ayu-theme/ayu-vim'
" let ayucolor="mirage"
" colorscheme ayu
" NeoBundle 'rafamadriz/neon'
" NeoBundle 'mhartington/oceanic-next'
" NeoBundle 'EdenEast/nightfox.nvim'
" NeoBundle 'folke/tokyonight.nvim'
" let g:tokyonight_style = "night"
" let g:tokyonight_italic_functions = 1
" NeoBundle "EdenEast/nightfox.nvim"
" NeoBundle "laniusone/kyotonight.vim"
NeoBundle "maekawatoshiki/everforest"
let g:everforest_background = "hard"

" NeoBundle 'https://github.com/widatama/vim-phoenix'
" NeoBundle 'NLKNguyen/papercolor-theme'

" NeoBundle 'arcticicestudio/nord-vim'

" Indent guide
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1

" GitHub Copilot
NeoBundle 'github/copilot.vim'

NeoBundle 'myhere/vim-nodejs-complete'
:setl omnifunc=jscomplete#CompleteJS
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
let g:node_usejscomplete = 1


" add plugins here
" NeoBundle 'vim-jp/cpp-vim'
" NeoBundle 'scrooloose/syntastic.git'
" let g:syntastic_check_on_wq = 0

NeoBundle 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" OpenCL
NeoBundleLazy 'petRUShka/vim-opencl'
" NeoBundle 'brgmnn/vim-opencl'

" NeoBundle 'tyru/eskk.vim'
" let g:eskk#directory = "~/.eskk"
" let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8', }
" let g:eskk#large_dictionary = { 'path': "~/.eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
" let g:eskk#enable_completion = 1
NeoBundleLazy 'lervag/vimtex'
let g:vimtex_compiler_latexmk = { 'continuous' : 0, 'build_dir' : 'aux' }
let g:vimtex_quickfix_open_on_warning = 0
let g:tex_flavor = "latex"
let g:latex_latexmk_options = '-c'
" let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
augroup set_latex_compiler
	autocmd!
	autocmd BufNewFile,BufRead *.tex nmap <C-c> <plug>(vimtex-compile)
augroup END

filetype plugin indent on

" Golang
NeoBundleLazy 'fatih/vim-go'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
" autocmd BufNewFile,BufRead *.go nmap <C-b> <plug>(vimtex-compile)

" PlantUML
NeoBundle 'aklt/plantuml-syntax'
au BufRead,BufNewFile *.puml set filetype=plantuml

NeoBundle 'antiagainst/vim-tablegen', { 'autoload' : {'filetypes' : 'tablegen'} }
au BufRead,BufNewFile *.td set filetype=tablegen

NeoBundle 'rhysd/vim-llvm'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'qnighy/satysfi.vim'
NeoBundle 'luochen1990/rainbow'
let g:rainbow_active = 1
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'junegunn/fzf'
nnoremap <C-p> :Files<CR>
nnoremap ,<C-p> :Rg<CR>
" NeoBundle 'ctrlpvim/ctrlp.vim'
" NeoBundle 'mattn/ctrlp-matchfuzzy'
" let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
let g:ctrlp_custom_ignore = {
	\   'dir' : '\.git$\|build.*$\|node_modules\|dist\|target' ,
	\ 	'file' : '\v\.(exe|dll|lib)$'
	\ }
let g:ctrlp_max_files=0

" NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'kg8m/vim-simple-align'

NeoBundle 'psf/black'
au BufRead,BufNewFile *.py nnoremap <C-b> :Black<CR>:w<CR>

" NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kyazdani42/nvim-web-devicons'
NeoBundle 'kyazdani42/nvim-tree.lua'

NeoBundle 'tpope/vim-fugitive'
" NeoBundle 'rhysd/wandbox-vim'
NeoBundleLazy 'thinca/vim-ref'
NeoBundleLazy 'mattn/vim-vimstreamer'
NeoBundleLazy 'rhysd/github-complete.vim'
NeoBundleLazy 'Shougo/neoinclude.vim'
NeoBundleLazy 'Shougo/vimproc'

NeoBundle "tyru/caw.vim"
" nmap ,c <Plug>(caw:hatpos:toggle)
" vmap ,c <Plug>(caw:hatpos:toggle)
" NeoBundle 'tpope/vim-commentary'
NeoBundleLazy 'tomtom/tcomment_vim'
nmap ,c :TComment<CR>
vmap ,c :TComment<CR>

NeoBundle 'tyru/open-browser.vim'

au BufRead,BufNewFile *.md set filetype=markdown

NeoBundle 'kana/vim-submode'
NeoBundle 'nathanaelkane/vim-indent-guides' 
" let g:indent_guides_enable_on_vim_startup=1
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'

" NeoBundle 'marcus/rsense'

" NeoBundle 'jamestthompson3/nvim-remote-containers'
" NeoBundle 'https://codeberg.org/esensar/nvim-dev-container.git'

" Gist
NeoBundle 'mattn/vim-gist'
NeoBundle 'mattn/webapi-vim'

" for Rust
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'rust-lang-nursery/rustfmt'
"
" coc.nvim
NeoBundle 'neoclide/coc.nvim'
" inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1):
"      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1

set hidden

" for rustfmt
let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'

call neobundle#end()

NeoBundleCheck

" RSense
let g:rsenseHome = '/usr/local/lib/rsense-0.3/bin'
let g:rsenseUseOmniFunc = 1

" lightline settings
set laststatus=2
let g:lightline = {
			\ 'colorscheme': 'everforest',
			\ 'mode_map': {'c': 'NORMAL'},
      \ 'separator': { 'left': "", 'right': "" },
      \ 'subseparator': { 'left': "", 'right': "" },
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
  :qa
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

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "all",
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = { "javascript" },
    highlight = {
      -- `false` will disable the whole extension
      enable = true,
      -- list of language that will be disabled
      -- disable = { "c", "rust" },
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
EOF

" nvim-tree.lua settings
nnoremap <silent><C-e> :NvimTreeToggle<CR>
lua <<EOF
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
-- require("nvim-tree").setup()

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    -- adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "<C-e>", action = "close" },
      },
    },
    side = "left"
  },
  renderer = {
    group_empty = true,
    icons = {
      -- show = {
      --   file = false,
      --   folder = false,
      --   folder_arrow = false,
      --   git = false,
      -- }
    }
  },
  filters = {
    dotfiles = false,
  },
})
EOF

syntax on
syntax enable
colorscheme everforest
