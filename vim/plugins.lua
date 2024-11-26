-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- colorschemes
  { 'sainnhe/everforest', config = function() vim.cmd [[ let g:everforest_background = "hard" ]] end },
  -- use 'maekawatoshiki/everforest'
  -- vim.cmd [[ let g:everforest_background = "hard" ]]
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

  -- {
  --   "TabbyML/vim-tabby",
  --   lazy = false,
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --   },
  --   init = function()
  --     vim.g.tabby_agent_start_command = {"npx", "tabby-agent", "--stdio"}
  --     vim.g.tabby_inline_completion_trigger = "auto"
  --   end,
  -- },

  -- nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate", 
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      require'nvim-treesitter.configs'.setup {
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = { "c", "cpp", "python", "lua", "rust", "llvm", "go", "bash", "json", "yaml", "toml" },
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
  },

  'tomtom/tcomment_vim',

  -- nvim-tree
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = { max = "23%" },
          adaptive_size = true,
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
    end
  },

  { 'github/copilot.vim' },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- coc.nvim
  {
    'neoclide/coc.nvim',
    build = "yarn",
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
  },

  -- vim-submode
  {
    'kana/vim-submode',
    config = function()
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
    end
  },

  -- fzf
  {
    'junegunn/fzf',
    build = function()
      vim.cmd [[ call fzf#install() ]]
    end
  },
  {
    'junegunn/fzf.vim',
    config = function()
      vim.cmd [[
        nnoremap <C-p> :Files<CR>
        nnoremap ,<C-p> :Rg<CR>
      ]]
    end
  },

  -- Lightline
  {
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
  },

  'kyazdani42/nvim-web-devicons',

  -- vim-quickhl
  {
    't9md/vim-quickhl', config = function()
      vim.cmd [[
      " Highlight the selected word
      nmap <Space>m <Plug>(quickhl-manual-this)
      " Highlight the selected text
      xmap <Space>m <Plug>(quickhl-manual-this)
      " Disable all highlights
      nmap <Space>M <Plug>(quickhl-manual-reset)
      ]]
    end
  },

  -- vim-toml
  'cespare/vim-toml',

  -- OpenCL
  'petRUShka/vim-opencl',

  -- TeX
  {
    'lervag/vimtex',
    config = function()
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
    end
  },

  -- PlantUML
  {
    'aklt/plantuml-syntax',
    config = function()
      vim.cmd [[ au BufRead,BufNewFile *.puml set filetype=plantuml ]]
    end
  },

  -- LLVM TableGen
  -- { 'antiagainst/vim-tablegen', ft = 'tablegen' }
  -- vim.cmd [[ au BufRead,BufNewFile *.td set filetype=tablegen ]]

  -- LLVM IR
  'rhysd/vim-llvm',

  -- SATySFi
  'qnighy/satysfi.vim',

  -- Rainbow parentheses
  {
    'luochen1990/rainbow',
    config = function()
      vim.cmd [[ let g:rainbow_active = 1 ]]
    end
  },

  -- vim-simple-align
  'kg8m/vim-simple-align',

  -- python black
  { 'psf/black',
    config = function()
      vim.cmd [[ autocmd FileType python nnoremap <C-b> :Black<CR>:w<CR> ]]
    end
  },

  -- vim-fugitive (e.g. :Gdiff)
  'tpope/vim-fugitive',

  -- gitsigns
  {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '|' },
                topdelete    = { text = '|' },
                changedelete = { text = '|' },
                untracked    = { text = '┆' },
            },
            signs_staged = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '|' },
                topdelete    = { text = '|' },
                changedelete = { text = '|' },
                untracked    = { text = '┆' },
            },
            signs_staged_enable = true,
            signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
            linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
        }
    end
  },

  'rhysd/github-complete.vim',
  'Shougo/vimproc',

  -- Gist
  'mattn/vim-gist',
  'mattn/webapi-vim',

  -- Rust
  'rust-lang/rust.vim',
  { 
    'rust-lang-nursery/rustfmt',
    config = function()
      vim.cmd [[ autocmd FileType rust nnoremap <C-b> :RustFmt<CR>:w<CR> ]]
    end
  },

  {
    'phaazon/hop.nvim',
    version = 'v2',
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      vim.cmd [[ 
        nnoremap <silent> H :lua require'hop'.hint_patterns({}, vim.fn['getreg']('/'))<CR>
      ]]
    end
  }

})

vim.cmd [[
  nmap ,c :TComment<CR>
  vmap ,c :TComment<CR>
]]

vim.cmd [[ nnoremap <silent><C-e> :NvimTreeToggle<CR> ]]


--   -- use {
--   --   'https://codeberg.org/esensar/nvim-dev-container',
--   --   requires = { 'nvim-treesitter/nvim-treesitter' },
--   --   config = function()
--   --     require'devcontainer'.setup { }
--   --   end
--   -- }
--   --
--
--   -- use {
--   --   'chipsenkbeil/distant.nvim',
--   --   branch = 'v0.3',
--   --   config = function()
--   --       local plugin = require('distant')
--   --       plugin:setup({
--   --         servers = {
--   --           ['persica'] = {
--   --             lsp = {
--   --               ['Project Distant'] = {
--   --                 cmd = '/home2/uint/.cargo/bin/rust-analyzer',
--   --                 root_dir = '/home2/uint/work/altius',
--   --                 file_types = {'rust'},
--   --                 on_exit = function(code, signal, client_id)
--   --                   local prefix = '[Client ' .. tostring(client_id) .. ']'
--   --                   print(prefix .. ' LSP exited with code ' .. tostring(code))
--   --
--   --                   -- Signal can be nil
--   --                   if signal ~= nil then
--   --                     print(prefix .. ' Signal ' .. tostring(signal))
--   --                   end
--   --                 end,
--   --                 on_attach = function()
--   --                   vim.keymap.set('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>')
--   --                   vim.keymap.set('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>')
--   --                   vim.keymap.set('n', 'gh', '<CMD>lua vim.lsp.buf.hover()<CR>')
--   --                   vim.keymap.set('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>')
--   --                   vim.keymap.set('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>')
--   --                 end,
--   --               }
--   --             }
--   --           }
--   --         }
--   --       })
--   --   end
--   -- }
--
--   -- Automatically set up your configuration after cloning packer.nvim
--   -- Put this at the end after all plugins
--   if packer_bootstrap then
--     require('packer').sync()
--   end
-- end)
--
