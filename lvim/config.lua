--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Copy to system clipboard bindings. Note: Requires xclip utility
-- Note that we cannot do stuff directly here, but instead define a function
-- that is called once the plugin has been loaded. Due to lazy loading,
-- that may be later than now.
-- copy only in visual mode, and paste only in normal mode
function Setup_which_key()
  local wk = require("which-key")
  wk.register({
    C = {
      name = "Clipboard", -- optional group name
      y = { "\"+y", "Copy to clipboard" },
    },
  }, { prefix = "<leader>", mode="v" })
  wk.register({
    C = {
      name = "Clipboard", -- optional group name
      p = { "\"+p", "Paste from clipboard" },
    },
  }, { prefix = "<leader>", mode="n" })
  wk.register({
    g = {
      B = { ":Git blame<CR>", "Full git blame" },
    },
  }, { prefix = "<leader>", mode="n" })
  wk.register({
    F = {
      name = "Foldmethod",
      s = { ":set foldmethod=syntax<CR>", "syntax" },
      e = { ":set foldmethod=expr<CR>", "expr" },
      m = { ":set foldmethod=manual<CR>", "manual" },
      i = { ":set foldmethod=indent<CR>", "indent" },
    },
  }, { prefix = "<leader>", mode="n" })
end

function Setup_telescope()
  local tc = require("telescope")
  tc.setup({
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key"
        }
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      git_files = {
        recurse_submodules = true,
        show_untracked = false,
      --   ...
      }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
    }
  })
end
Setup_telescope()

function Setup_null_ls()
  require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.shellharden,
        require("null-ls").builtins.diagnostics.shellcheck,
        -- pytlint disabled for the time due to outdated diagnostics
        -- require("null-ls").builtins.diagnostics.pylint,
    },
  })
end
Setup_null_ls()


-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile

-- Disable dashboard plugin
lvim.builtin.alpha.active = false
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.which_key.on_config_done = Setup_which_key

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true


-- Custom settings
lvim.builtin.lualine.style = "default"
vim.opt.relativenumber = true
vim.opt.tabstop=2
vim.opt.sw=2
vim.opt.cmdheight=1
vim.opt.expandtab = true
vim.opt.wrap = true

-- set conceallevel=0

-- Extra whitespace highlighting. We need to specify the highlighting effect
-- in an autocommand to ensure it survives the color scheme, which resets all highlights
 vim.cmd([[
augroup AuGroupExtraWhitespace
    autocmd!
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
augroup END
]])
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Call :checktime on update focus events.
-- Note: tmux can be configured to send these upon active pane switches
vim.cmd([[
  autocmd FocusGained * checktime
]])

-- Ignore trailing whitespace in the lunarvim dashboard
-- Note: this is currently disabled since it also permanently disables
-- trailing whitespace highlighting for other fts. A solution would need
-- to either restrict the match or highlight to specific fts, or call some
-- function upon buffer events.
-- vim.cmd('autocmd Filetype dashboard match none')

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
    {"tpope/vim-fugitive"},
    -- {"folke/tokyonight.nvim"},
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  { "BufWinEnter", "*.cpp", "setlocal colorcolumn=120" },
  { "BufWinEnter", "*.h", "setlocal colorcolumn=120" },
}
