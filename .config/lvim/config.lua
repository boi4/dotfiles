--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- :lua print(vim.inspect(lvim.keys))


-- general
lvim.log.level = "warn"
lvim.format_on_save = true
--lvim.colorscheme = "darkblue"
-- best default themes light: 
-- best default themes dark: darkblue desert slate
-- good schemes: OCeanicNext, onedarker
-- lvim.colorscheme = "OceanicNext"
lvim.colorscheme = "vscode"
-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

vim.g.vscode_style = "dark"

-- add your own keymapping
-- https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/keymappings.lua
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.command_mode["w!!"] = "SudaWrite"
lvim.keys.normal_mode["<leader>W"] = ":SudaWrite<cr>"
lvim.keys.normal_mode["<leader>t"] = ":Telescope colorscheme<cr>"

-- " Easy Align
vim.api.nvim_command("xmap ga <Plug>(EasyAlign)")
vim.api.nvim_command("nmap ga <Plug>(EasyAlign)")

-- lvim.builtin.which_key.setup.plugins.presets.motions = true
-- lvim.builtin.which_key.setup.plugins.presets.operators = true
--lvim.builtin.which_key.setup.plugins.presets.text_objects = true
-- lvim.keys.normal_mode["cl"] = "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>"
-- lvim.keys.visual_mode["cl"] = "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>"

lvim.builtin.which_key.mappings[";"]["1"] = nil -- disable dashboard
lvim.builtin.which_key.mappings[";"]["2"] = nil -- disable dashboard

vim.api.nvim_del_keymap('i', 'jk')
vim.api.nvim_del_keymap('i', 'kj')
vim.api.nvim_del_keymap('i', 'jj')


-- this is normally moving current line, but overwritten by kitty tabs
vim.api.nvim_del_keymap('i', '<A-j>')
vim.api.nvim_del_keymap('i', '<A-k>')

-- only highlight current line number
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"


-- in vis  mode: K,J um ganzen block zu bewegen
-- in completion: C-j, C-K für auswahl


-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
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
lvim.builtin.autopairs.active = false
lvim.builtin.dashboard.active = false
lvim.builtin.project.active = false
lvim.builtin.terminal.active = false


lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  --"javascript",
  "json",
  "lua",
  "python",
  --"typescript",
  --"css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true


-- for tab bar
-- https://github.com/romgrk/barbar.nvim#lua-1
vim.g.bufferline = {
   auto_hide = true
}

-- generic LSP settings

-- ---@usage disable automatic installation of servers
lvim.lsp.automatic_servers_installation = false

lvim.format_on_save = false
-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- pacman -S pyright
vim.list_extend(lvim.lsp.override, { "pyright" })
require("lvim.lsp.manager").setup("pyright", {})

-- pacman -S bash-language-server
vim.list_extend(lvim.lsp.override, { "bashls" })
require("lvim.lsp.manager").setup("bashls", {})

-- pacman -S clang
vim.list_extend(lvim.lsp.override, { "clangd" })
require("lvim.lsp.manager").setup("clangd", {})

-- pacman -S vscode-html-languageserver
vim.list_extend(lvim.lsp.override, { "html" })
require("lvim.lsp.manager").setup("html", {})

-- pacman -S vscode-json-languageserver
vim.list_extend(lvim.lsp.override, { "jsonls" })
require("lvim.lsp.manager").setup("jsonls", {})

-- pacman -S lua-language-server
vim.list_extend(lvim.lsp.override, { "sumneko_lua" })
require("lvim.lsp.manager").setup("sumneko_lua", {})

-- pacman -S texlab
vim.list_extend(lvim.lsp.override, { "texlab" })
require("lvim.lsp.manager").setup("texlab", {})

-- pacman -S yaml-language-server
vim.list_extend(lvim.lsp.override, { "yamlls" })
require("lvim.lsp.manager").setup("yamlls", {})


-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
--   {
--     exe = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
 lvim.plugins = {
  {"farmergreg/vim-lastplace"}, -- wieder da anfangen wo man dings
  {"mhartington/oceanic-next"},
  {"ap/vim-css-color"},
  {"lambdalisue/suda.vim"},
  {"Mofiqul/vscode.nvim"},
  {"tpope/vim-surround"},
  {"junegunn/vim-easy-align"},
  -- {"psliwka/vim-smoothie"},
  -- {"Yggdroot/indentLine"},
  -- {"rafi/awesome-vim-colorschemes"},
 }
--     {"folke/tokyonight.nvim"},
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  --{ "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  { "BufWinEnter", "*.py", "set colorcolumn=80"}
}
