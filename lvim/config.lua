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

-- This command highlights all occurences of the current selection,
-- also working for multi-line text
-- Compored to the original version, I added on <cr> at the end to terminate the pending command,
-- removed the histadd, and use the "x register instead of *
-- to avoid messing up the default register by unrelated highlighting
 vim.cmd([[
xnoremap <silent> <cr> "xy:silent! let searchTerm = '\V'.substitute(escape(@x, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> set hls<cr><cr>
]])
-- Original version:
-- xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

-- Copy to system clipboard bindings. Note: Requires xclip utility
-- Note that we cannot do stuff directly here, but instead define a function
-- that is called once the plugin has been loaded. Due to lazy loading,
-- that may be later than now.
-- copy only in visual mode, and paste only in normal mode
function Setup_which_key()
  local wk = require("which-key")
  wk.register({
    L = { ":lua os.execute('echo break '..vim.fn.expand('%')..':'..vim.api.nvim_win_get_cursor(0)[1]..' | xclip -selection clipboard')<CR>", "Export gdb breakpoint on current line to system clipboard." },
    P = { ":lua os.execute('readlink -f '..vim.fn.expand('%')..' | xclip -selection clipboard')<CR>", "Export absolute path of current file to system clipboard." },
  }, { prefix = "g", mode="n" })
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
    F = {
      name = "Foldmethod",
      s = { ":setlocal foldmethod=syntax<CR>", "syntax" },
      e = { ":setlocal foldmethod=expr<CR>", "expr" },
      m = { ":setlocal foldmethod=manual<CR>", "manual" },
      i = { ":setlocal foldmethod=indent<CR>", "indent" },
      p = { ":setlocal foldexpr=(getline(v:lnum)=~@/)?0:1 foldmethod=expr foldlevel=0 foldcolumn=2 foldminlines=0<CR>", "current search pattern" },
    },
    g = {
      B = { ":Git blame<CR>", "Full git blame" },
      q = { ":Git! difftool<CR>", "Populate quickfix with diff" },
    },
    l = {
      D = { ":lua vim.diagnostic.open_float()<CR>", "Show current line diagnostic popup" },
      F = { ":write | :! cd $(dirname %) && git clang-format -f -- $(basename %)<CR> | :checktime<CR>", "Run git-format on local changes" },
      -- Note: by default, for some reason this uses the loclist instead of qflist
      q = { ":lua vim.diagnostic.setqflist()<CR>", "Quickfix" },
      v = { ":lua DiagnosticVirtualTextToggle()<CR>", "Toggle virtual text" },
      -- F = { ":lua print(5)<CR>", "Run git-format on local changes1" },
    },
  -- Note: by default, the q binding force-quits without saving, which may be dangerous
    q = { ":q<CR>", "quit" },
    Q = { ":q!<CR>", "quit (force)" },
    s = {
      l = { ":BLines<CR>", "Text (current buffer)" },
      T = { ":lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>", "Text (open buffers)" },
    },
    W = { ":wa<CR>", "Save all" }
  }, { prefix = "<leader>", mode="n" })
end

function Setup_telescope()
  local tc = require("telescope")
  tc.setup({
    defaults = {
      layout_config = {
        -- Wider window to avoid truncating paths
        horizontal = { width = 0.9 }
      -- other layout configuration here
      },
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
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.diagnostics.shellcheck,
        require("null-ls").builtins.diagnostics.markdownlint.with({
          extra_args = { "-c", vim.fn.expand("~/.dotfiles/.markdownlint.json") }
        }),
        -- pytlint disabled for the time due to outdated diagnostics
        -- require("null-ls").builtins.diagnostics.pylint,
    },
  })
end
Setup_null_ls()

-- function Setup_bufferline()
-- require('bufferline').setup {
--   options = {
--     max_name_length = 30,
--     max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
--     tab_size = 18,
--   }
-- }
-- end
-- Setup_bufferline()

function Setup_illuminate()
  require('illuminate').configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    -- delay: delay in milliseconds
    delay = 100,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
        'dirvish',
        'fugitive',
    },
    -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
    filetypes_allowlist = { 'llvm' },
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
  })
    -- Override highlighting style, copy LSP style
    vim.cmd([[
    hi clear illuminatedWord
    hi link illuminatedWord LspReferenceText
  ]])
  end
Setup_illuminate()

require('leap').add_default_mappings()

-- Virtual text enable/disable/toggle functions
-- I could not find a way to query the current state,
-- so instead we manage our own state here and export that on
-- every action
__DiagnosticVirtualTextState = true
function DiagnosticVirtualTextUpdateEnableDisable()
  -- Also disable underline, as this distracts as well
  vim.diagnostic.config({virtual_text = __DiagnosticVirtualTextState, underline = __DiagnosticVirtualTextState})
end

function DiagnosticVirtualTextEnable()
  __DiagnosticVirtualTextState = true
  DiagnosticVirtualTextUpdateEnableDisable()
end

function DiagnosticVirtualTextDisable()
  __DiagnosticVirtualTextState = false
  DiagnosticVirtualTextUpdateEnableDisable()
end

function DiagnosticVirtualTextToggle()
  __DiagnosticVirtualTextState = not __DiagnosticVirtualTextState
  DiagnosticVirtualTextUpdateEnableDisable()
end

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
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = 50
lvim.builtin.nvimtree.setup.update_cwd = false
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
vim.opt.tabstop=4
vim.opt.sw=4
vim.opt.cmdheight=1
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.list = true
vim.opt.jumpoptions="stack"

-- set conceallevel=0

-- Minimal .clang-format support: let clang-format dump its configuration,
-- and set tabstop/sw from that (if successful)
local function import_clang_format_settings()
  -- TODO: Process output in lua instead of shell
  local pipe = io.popen("clang-format --dump-config | grep -i '\\bindentwidth:' | rev | cut -d ' ' -f1 | rev")
  if not pipe then
    return
  end
  local line = pipe:read("*l")
  if line then
    local indent = tonumber(line)
    -- print("Detected indent setting of "..tostring(indent))
    vim.opt.tabstop = indent
    vim.opt.sw = indent
  end
end
import_clang_format_settings()


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

-- Avoid repositioning of current line when switching buffers, as it makes
-- e.g. visually comparing files very difficult
vim.cmd([[
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
]])

-- Prepare xml syntax folding -- enable with 'set foldmethod=syntax' (ensure syntax on before)
vim.cmd('let g:xml_syntax_folding=1')

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
    {"tpope/vim-sleuth"},
    {"rhysd/vim-llvm"},
    {"ntpeters/vim-better-whitespace"},
    -- Highlight current word under cursor for filetypes without LSP support
    -- This is conditionally enabled for certain FTs, because usually lvim already does it
    {"RRethy/vim-illuminate"},
    {"beyondmarc/hlsl.vim"},
    {"ggandor/leap.nvim"},
    {"junegunn/fzf"},
    {"junegunn/fzf.vim"},
    -- {"folke/tokyonight.nvim"},
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
}

vim.api.nvim_create_autocmd("BufWinEnter", {
	  pattern = { "*.ll", "*.dxil" },
	  command = "set filetype=llvm",
})

-- The highlight link is a hack to get it to work, setting in the config
-- function does not work for some reason. I only need it for llvm for the time being.
vim.cmd([[
autocmd FileType llvm set iskeyword+=%
autocmd FileType llvm set iskeyword+=!
autocmd FileType llvm set iskeyword+=.
autocmd FileType llvm set iskeyword+=#
autocmd FileType llvm hi link illuminatedWord LspReferenceText
]])

-- For LSP highlights, we need to set LspReferenceText, LspReferenceRead and LspReferenceWrite
-- As long as I'm using the onedarker scheme, I just fix these groups in the plugin itself,
-- as overwriting here did not work.
