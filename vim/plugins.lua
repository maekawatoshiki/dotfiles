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

local function fork(repo, commit, spec)
  spec = spec or {}
  spec[1] = "maekawatoshiki/" .. repo
  spec.commit = commit
  return spec
end

require("lazy").setup({
  -- colorschemes
  fork('everforest', 'aeef62ee97872d2557d25904d160ec93a4a355f8', -- 2026-04-16
  {
    config = function() vim.cmd [[ let g:everforest_background = "hard" ]] end
  }),
  -- { 'morhetz/gruvbox', config = function() vim.cmd [[ let g:gruvbox_contrast_dark = 'hard' ]] end },
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
  -- { 'projekt0n/caret.nvim', lazy = false },
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
  fork('nvim-treesitter', '4916d6592ede8c07973490d9322f187e07dfefac', -- 2026-04-03
  {
    lazy = false,
    build = function()
      local treesitter_parsers = { "c", "cpp", "python", "lua", "rust", "llvm", "go", "bash", "json", "yaml", "toml", "markdown", "markdown_inline" }
      require('nvim-treesitter').install(treesitter_parsers)
    end,
    config = function()
      require('nvim-treesitter').setup()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { "c", "cpp", "python", "lua", "rust", "llvm", "go", "sh", "bash", "json", "yaml", "toml", "markdown" },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  }),

  fork('tcomment_vim', '48ab639a461d9b8344f7fee06cb69b4374863b13'), -- 2024-03-25

  -- nvim-tree
  fork('nvim-tree.lua', 'f9bfc0059eca24546b69a7006110463da4808f8f', -- 2026-05-01
  {
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
  }),

  fork('copilot.vim', 'a12fd5672110c8aa7e3c8419e28c96943ca179be'), -- 2026-01-09

  fork('indent-blankline.nvim', 'd28a3f70721c79e3c5f6693057ae929f3d9c0a03', { main = "ibl", opts = {} }), -- 2026-02-17


  fork('lspsaga.nvim', 'c532fb86c3d211c5829ad58d2a0783012739bb65', -- 2026-04-21
  {
    config = function()
        require('lspsaga').setup {}
        vim.opt.signcolumn = "yes"
        vim.keymap.set("n", "K",  "<cmd>Lspsaga hover_doc<CR>")
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
            end,
        })

    end
  }),

  fork('mason.nvim', 'cb8445f8ce85d957416c106b780efd51c6298f89', -- 2026-04-27
  {
    build = ':MasonUpdate',
    config = function()
      require('mason').setup()
    end,
  }),

  fork('mason-lspconfig.nvim', '0c2823e0418f3d9230ff8b201c976e84de1cb401', -- 2026-04-23
  {
    dependencies = { fork('mason.nvim', 'cb8445f8ce85d957416c106b780efd51c6298f89') }, -- 2026-04-27
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'pyright', 'lua_ls', 'rust_analyzer', 'clangd',
          'gopls', 'bashls', 'jsonls', 'yamlls', 'taplo',
        },
      }
    end
  }),

  fork('nvim-lspconfig', '31026a13eefb20681124706a79fc1df6bf11ab27', -- 2026-04-30
  {
    dependencies = {
      fork('mason.nvim', 'cb8445f8ce85d957416c106b780efd51c6298f89'), -- 2026-04-27
      fork('mason-lspconfig.nvim', '0c2823e0418f3d9230ff8b201c976e84de1cb401'), -- 2026-04-23
      fork('cmp-nvim-lsp', 'cbc7b02bb99fae35cb42f514762b89b5126651ef'), -- 2025-11-13
    },
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition,       opts)
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition,  opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,   opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references,       opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,   opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'K',  vim.lsp.buf.hover,            opts)

      -- Enable inlay hints
      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if client and client.server_capabilities.inlayHintProvider then
      --       vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      --     end
      --   end,
      -- })
    end,
  }),

  fork('nvim-cmp', 'a1d504892f2bc56c2e79b65c6faded2fd21f3eca', -- 2026-03-25
  {
    dependencies = {
      fork('cmp-nvim-lsp', 'cbc7b02bb99fae35cb42f514762b89b5126651ef'), -- 2025-11-13
      fork('cmp_luasnip', '98d9cb5c2c38532bd9bdb481067b20fea8f32e90'), -- 2024-11-04
      fork('LuaSnip', 'a62e1083a3cfe8b6b206e7d3d33a51091df25357'), -- 2026-04-05
      fork('lspkind.nvim', 'c7274c48137396526b59d86232eabcdc7fed8a32'), -- 2026-01-29
    },
    config = function()
      local cmp     = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          -- ['<TAB>'] = cmp.mapping(function(fb)
          --   if cmp.visible() then cmp.select_next_item()
          --   elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
          --   else fb() end
          -- end, { 'i', 's' }),
          ['<S-TAB>'] = cmp.mapping(function(fb)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fb() end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path'   },
        },
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
          }),
        },
      })
    end,
  }),

  fork('nvim-bqf', 'c282a62bec6c0621a1ef5132aa3f4c9fc4dcc2c7', -- 2026-04-02
  {
    ft = 'qf',
    opts = {
      auto_enable  = true,
      preview = { auto_preview = true },
      func_map = {
        open = '', -- Open preview when line focused
        openc = '<CR>' -- Close preview by enter
      },
    }
  }),


  -- DEPRECATED: coc.nvim
  -- {
  --   'neoclide/coc.nvim',
  --   build = "yarn",
  --   config = function()
  --     vim.cmd [[
  --       " inoremap <silent><expr> <TAB>
  --       "      \ coc#pum#visible() ? coc#pum#next(1):
  --       "      \ coc#refresh()
  --       inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  --       inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  --                                     \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  --       nmap <silent> gd <Plug>(coc-definition)
  --       nmap <silent> gy <Plug>(coc-type-definition)
  --       nmap <silent> gi <Plug>(coc-implementation)
  --       nmap <silent> gr <Plug>(coc-references)
  --       command! CC :CocCommand
  --     ]]
  --   end
  -- },

  -- vim-submode
  fork('vim-submode', 'd29de4f55c40a7a03af1d8134453a703d6affbd2', -- 2017-07-10
  {
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
  }),

  -- fzf
  fork('fzf', 'b4a86a9c8a688159131a27b6ec9dbce72ec11573', -- 2026-05-02
  {
    build = function()
      vim.cmd [[ call fzf#install() ]]
    end
  }),
  fork('fzf.vim', 'b9624aa012ddcbae9e79964bfd30cc1fbe3cf263', -- 2026-04-10
  {
    config = function()
      vim.cmd [[
        nnoremap <C-p> :Files<CR>
        nnoremap ,<C-p> :Rg<CR>
      ]]
    end
  }),

  -- Lightline
  fork('lightline.vim', '6c283f8df85aa7219fa4096a6ed4ff45d48aa9e1', -- 2026-04-13
  {
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
              \     ['mode', 'paste'], 
              \     ['gitgutter', 'fugitive', 'filename'] 
              \   ]
              \ },
              \ 'component_function': {
              \		'gitgutter': 'MyGitGutter'
              \ }
              \ }
      ]]
    end
  }),

  fork('nvim-web-devicons', '4fc505ac7bd7692824a142e96e5f529c133862f8'), -- 2026-04-28

  -- vim-quickhl
  fork('vim-quickhl', 'be1f44169c3fdee3beab629e83380515da03835e', -- 2021-09-01
  {
    config = function()
      vim.cmd [[
      " Highlight the selected word
      nmap <Space>m <Plug>(quickhl-manual-this)
      " Highlight the selected text
      xmap <Space>m <Plug>(quickhl-manual-this)
      " Disable all highlights
      nmap <Space>M <Plug>(quickhl-manual-reset)
      ]]
    end
  }),

  -- vim-toml
  fork('vim-toml', 'da051b7c23bad3c52d18886203c594739780ec09'), -- 2026-03-03

  -- OpenCL
  fork('vim-opencl', '7668b018fe9461c6b51e0b736ed84aa84d6bafce'), -- 2018-06-13

  -- TeX
  fork('vimtex', '97e11bd4f56d46a87f8593d6ccb27820e19c4ab0', -- 2026-05-01
  {
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
  }),

  -- PlantUML
  fork('plantuml-syntax', '9d4900aa16674bf5bb8296a72b975317d573b547', -- 2024-08-26
  {
    config = function()
      vim.cmd [[ au BufRead,BufNewFile *.puml set filetype=plantuml ]]
    end
  }),

  -- LLVM TableGen
  -- { 'antiagainst/vim-tablegen', ft = 'tablegen' }
  -- vim.cmd [[ au BufRead,BufNewFile *.td set filetype=tablegen ]]

  -- LLVM IR
  fork('vim-llvm', '05ccc57d98398bddbbd71789c21914383fc9ad45'), -- 2025-12-28

  -- SATySFi
  fork('satysfi.vim', 'c11dc636ce2987bf122cbd6d488f40d98909a2df'), -- 2021-09-18

  -- Rainbow parentheses
  fork('rainbow', '76ca1a20aa42edb5c65c19029968aad4625790dc', -- 2024-07-27
  {
    config = function()
      vim.cmd [[ let g:rainbow_active = 1 ]]
    end
  }),

  -- vim-simple-align
  fork('vim-simple-align', '89b2d815034b7b25c9234449957677276aa3e25f'), -- 2025-05-24

  -- Formatter
  fork('conform.nvim', 'dca1a190aa85f9065979ef35802fb77131911106', -- 2026-04-22
  {
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          python = { "black" },
          rust = { "rustfmt" },
        },
      })

      -- Format with <C-b>
      vim.keymap.set("n", "<C-b>", function()
        conform.format({
          timeout_ms = 3000,
          lsp_fallback = false,
        })
        vim.cmd("write")
      end, { noremap = true, desc = "Format and save" })
    end,
  }),

  -- vim-fugitive (e.g. :Gdiff)
  fork('vim-fugitive', '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0'), -- 2026-03-07

  -- gitsigns
  fork('gitsigns.nvim', 'dd3f588bacbeb041be6facf1742e42097f62165d', -- 2026-05-01
  {
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
  }),

  fork('github-complete.vim', 'ba1ccc89e80c40f42b071337c6914006ebe0af03'), -- 2020-10-26
  -- { 'maekawatoshiki/vimproc.vim', name = 'vimproc', commit = '63a4ce0768c7af434ac53d37bdc1e7ff7fd2bece' }, -- 2024-09-04

  -- Gist
  fork('vim-gist', 'fd55721a8f7c2a7c23d2e704405047e03d6f95f6'), -- 2026-04-11
  fork('webapi-vim', 'c7eec04aad31e1665164d8292d0ec8b5c3cc5a57'), -- 2026-03-27

  -- Rust
  fork('rust.vim', '889b9a7515db477f4cb6808bef1769e53493c578'), -- 2022-11-27

  fork('hop.nvim', 'dcd111def98bc925a608dd311525dad96cdb0f24', -- 2025-03-27
  {
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      vim.cmd [[ 
        nnoremap <silent> H :lua require'hop'.hint_patterns({}, vim.fn['getreg']('/'))<CR>
      ]]
    end
  }),

  -- Auto detect indent settings
  fork('vim-sleuth', 'be69bff86754b1aa5adcbb527d7fcd1635a84080') -- 2024-09-19
})

vim.cmd [[
  nmap ,c :TComment<CR>
  vmap ,c :TComment<CR>
]]

vim.cmd [[ nnoremap <silent><C-e> :NvimTreeToggle<CR> ]]
