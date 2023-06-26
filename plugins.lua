-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.loader.enable()

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local group = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerSync",
	pattern = "/home/uint/.config/nvim/lua/plugins.lua", -- the name of your plugins file
	group = group,
})

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- colorschemes
  use 'sainnhe/everforest'
  vim.cmd [[ let g:everforest_background = "hard" ]]
  -- NeoBundle 'tyrannicaltoucan/vim-deep-space'
  -- NeoBundle 'ayu-theme/ayu-vim'
  -- let ayucolor="mirage"
  -- colorscheme ayu
  -- NeoBundle 'rafamadriz/neon'
  -- NeoBundle 'mhartington/oceanic-next'
  -- NeoBundle 'EdenEast/nightfox.nvim'
  -- NeoBundle 'folke/tokyonight.nvim'
  -- let g:tokyonight_style = "night"
  -- let g:tokyonight_italic_functions = 1
  -- NeoBundle "EdenEast/nightfox.nvim"
  -- NeoBundle "laniusone/kyotonight.vim"

  -- fzf
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  vim.cmd [[
    nnoremap <C-p> :Files<CR>
    nnoremap ,<C-p> :Rg<CR>
  ]]

  -- Lightline
  use {
    'itchyny/lightline.vim',
    config = function()
      vim.cmd [[
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
      ]]
    end
  }

  -- vim-submode
  use 'kana/vim-submode'
  vim.cmd [[
    call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
    call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
    call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
    call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
    call submode#map('winsize', 'n', '', '>', '<C-w>>')
    call submode#map('winsize', 'n', '', '<', '<C-w><')
    call submode#map('winsize', 'n', '', '+', '<C-w>-')
    call submode#map('winsize', 'n', '', '-', '<C-w>+')
  ]]

  -- nvim-treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    opt = true,
    event = "VimEnter",
    config = function()
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
    end
  }

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          -- adaptive_size = true,
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
        on_attach = function (bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end


          -- Default mappings. Feel free to modify or remove as you wish.
          --
          -- BEGIN_DEFAULT_ON_ATTACH
          vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
          vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
          vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
          vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
          vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
          vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
          vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
          vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
          vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
          vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
          vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
          vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
          vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
          vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
          vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
          vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
          vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
          vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
          vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
          vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
          vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
          vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
          vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
          vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
          vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
          vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
          vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
          vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
          vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
          vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
          vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
          vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
          vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
          vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
          vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
          vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
          vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
          vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
          vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
          vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
          vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
          vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
          vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
          vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
          vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
          vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
          vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
          vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
          vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
          vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
          vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
          -- END_DEFAULT_ON_ATTACH


          -- Mappings migrated from view.mappings.list
          --
          -- You will need to insert "your code goes here" for any mappings with a custom action_cb
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', '<C-e>', api.tree.close, opts('Close'))

        end
      })
      vim.cmd [[ nnoremap <silent><C-e> :NvimTreeToggle<CR> ]]
    end
  }
  use 'kyazdani42/nvim-web-devicons'

  -- vim-quickhl
  use 't9md/vim-quickhl'
  vim.cmd [[
    " Highlight the selected word
    nmap <Space>m <Plug>(quickhl-manual-this)
    " Highlight the selected text
    xmap <Space>m <Plug>(quickhl-manual-this)
    " Disable all highlights
    nmap <Space>M <Plug>(quickhl-manual-reset)
  ]]

  -- vim-toml
  use 'cespare/vim-toml'

  -- tcomment_vim
  use 'tomtom/tcomment_vim'
  vim.cmd [[
    nmap ,c :TComment<CR>
    vmap ,c :TComment<CR>
  ]]

  -- indent guide
  use 'nathanaelkane/vim-indent-guides'
  vim.cmd [[ let g:indent_guides_enable_on_vim_startup = 1 ]]

  -- GitHub Copilot
  use { 'github/copilot.vim', opt = true, event = "VimEnter" }

  -- OpenCL
  use 'petRUShka/vim-opencl'

  -- TeX
  use 'lervag/vimtex'
  vim.cmd [[
    let g:vimtex_compiler_latexmk = { 'continuous' : 0, 'build_dir' : 'aux' }
    let g:vimtex_quickfix_open_on_warning = 0
    let g:tex_flavor = "latex"
    let g:latex_latexmk_options = '-c'
    " let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
    augroup set_latex_compiler
      autocmd!
      autocmd BufNewFile,BufRead *.tex nmap <C-c> <plug>(vimtex-compile)
    augroup END
  ]]

  -- PlantUML
  use 'aklt/plantuml-syntax'
  vim.cmd [[ au BufRead,BufNewFile *.puml set filetype=plantuml ]]

  -- LLVM TableGen
  use { 'antiagainst/vim-tablegen', ft = 'tablegen' }
  vim.cmd [[ au BufRead,BufNewFile *.td set filetype=tablegen ]]

  -- LLVM IR
  use 'rhysd/vim-llvm'

  -- SATySFi
  use 'qnighy/satysfi.vim'

  -- Rainbow parentheses
  use { 'luochen1990/rainbow',
    config = function()
      vim.cmd [[ let g:rainbow_active = 1 ]]
    end
  }

  -- vim-simple-align
  use 'kg8m/vim-simple-align'

  -- python black
  use { 'psf/black',
    config = function()
      vim.cmd [[ autocmd FileType python nnoremap <C-b> :Black<CR> ]]
    end
  }

  -- vim-fugitive (e.g. :Gdiff)
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'rhysd/github-complete.vim'
  use 'Shougo/vimproc'

  -- Gist
  use { 'mattn/vim-gist', config = function() vim.cmd [[ PackerLoad webapi-vim ]] end }
  use { 'mattn/webapi-vim', opt = true }

  -- Rust
  use 'rust-lang/rust.vim'
  use { 
    'rust-lang-nursery/rustfmt',
    config = function()
      vim.cmd [[ autocmd FileType rust nnoremap <C-b> :RustFmt<CR> ]]
    end
  }

  -- coc.nvim
  use {
    'neoclide/coc.nvim',
    run = 'zsh -c "yarn install"',
    config = function()
      vim.cmd [[
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
        command! CC :CocCommand
      ]]
    end
  }

  use {
    'folke/flash.nvim',
    opt = true,
    event = "VimEnter",
    config = function()
      require('flash').setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

