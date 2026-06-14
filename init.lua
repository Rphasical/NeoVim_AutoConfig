-- ============================================================================
-- Neovim Configuration
--
-- A modern setup featuring:
--   - Syntax highlighting (Treesitter) for C, C++, C#, Python, Lua, Bash,
--     Markdown, JSON, YAML, and more
--   - Language server support (LSP) for C/C++, Python, C#, and Lua
--   - Autocompletion with snippets
--   - File explorer + fuzzy finder
--   - Dark colorscheme, line numbers, mouse support, system clipboard
--   - Keyboard-friendly navigation (window/buffer movement, line moving, etc.)
--
-- Requires: Neovim 0.11+  (check with `nvim --version`)
-- See the accompanying README.md for setup instructions and a keybinding
-- cheat sheet.
-- ============================================================================
 
-- ----------------------------------------------------------------------------
-- LEADER KEY (must be set before plugins load)
-- ----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
 
-- ----------------------------------------------------------------------------
-- GENERAL OPTIONS
-- ----------------------------------------------------------------------------
local opt = vim.opt
 
-- Line numbers (absolute number on the cursor line, relative everywhere else)
opt.number = true
opt.relativenumber = true
 
-- Mouse + system clipboard
opt.mouse = "a"               -- enable mouse in all modes (click, drag, scroll)
opt.clipboard = "unnamedplus" -- yanks/deletes go to the system clipboard
                               -- (needs `xclip` installed on Linux/X11)
 
-- Appearance
opt.termguicolors = true -- required for the colorscheme to look right
opt.signcolumn = "yes"   -- always show the sign column (avoids text shifting)
opt.cursorline = true    -- highlight the line the cursor is on
opt.scrolloff = 8        -- keep 8 lines visible above/below the cursor
opt.sidescrolloff = 8
opt.wrap = false         -- don't soft-wrap long lines
 
-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
 
-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
 
-- Splits open to the right/below, matching how most people read
opt.splitright = true
opt.splitbelow = true
 
-- Persistent undo across sessions, no swap/backup clutter
opt.undofile = true
opt.swapfile = false
opt.backup = false
 
-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = "menuone,noselect"
 
-- Nicer diagnostics (errors/warnings from the language server)
vim.diagnostic.config({
  virtual_text = { prefix = "● " },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
 
-- ----------------------------------------------------------------------------
-- KEYMAPS
-- ----------------------------------------------------------------------------
local map = vim.keymap.set
 
-- Clear search highlighting with Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
 
-- Move between window splits with Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
 
-- Resize the current split with Ctrl + arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")
 
-- Move the current line (or selection) up/down with Alt + j/k
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
 
-- Keep the visual selection after indenting with < / >
map("v", "<", "<gv")
map("v", ">", ">gv")
 
-- Half-page jumps keep the cursor centered on screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
 
-- Cycle through open buffers with Shift + h/l
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
 
-- Paste over a visual selection without losing your last yank
map("v", "p", '"_dP')
 
-- Quick save / quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
 
-- Quick terminal split (Esc twice to get back to normal mode)
map("n", "<leader>tt", "<cmd>split | terminal<CR>", { desc = "Open terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
 
-- LSP keymaps: only active in buffers where a language server is attached
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local lmap = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end
    lmap("gd", vim.lsp.buf.definition, "Go to definition")
    lmap("gD", vim.lsp.buf.declaration, "Go to declaration")
    lmap("gr", vim.lsp.buf.references, "Go to references")
    lmap("K", vim.lsp.buf.hover, "Hover documentation")
    lmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lmap("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    lmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})
 
-- ----------------------------------------------------------------------------
-- PLUGIN MANAGER: lazy.nvim (bootstraps itself on first run)
-- ----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
 
require("lazy").setup({
 
  ----------------------------------------------------------------------------
  -- Colorscheme: dark, modern theme
  ----------------------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
 
  ----------------------------------------------------------------------------
  -- Treesitter: accurate, language-aware syntax highlighting
  --
  -- NOTE: pinned to the `master` branch, which keeps the long-standing
  -- `ensure_installed` / `configs.setup()` API used below. nvim-treesitter's
  -- `main` branch is a full rewrite with a different setup process - see
  -- that project's README if you ever want to migrate to it.
  ----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "c_sharp", "python",
          "lua", "vim", "vimdoc",
          "bash", "markdown", "markdown_inline",
          "json", "yaml", "query",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- LSP: language servers for C/C++, Python, C#, and Lua, managed by Mason
  ----------------------------------------------------------------------------
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason.nvim",
    config = function() require("mason").setup() end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Give every language server nvim-cmp's enhanced capabilities
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
 
      -- Teach the Lua server about Neovim's `vim` global (handy for
      -- editing this very config without false "undefined global" warnings)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
 
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright", "omnisharp", "lua_ls" },
        -- `automatic_enable` defaults to true, so each server installed
        -- above is automatically turned on via vim.lsp.enable().
      })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- Autocompletion with snippet support
  ----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
 
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- File explorer (mouse-friendly: click to select, double-click to open)
  ----------------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 32 },
        renderer = { group_empty = true },
      })
      map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- Fuzzy finder for files, text, and buffers
  ----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (needs ripgrep)" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- Status line
  ----------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "tokyonight" } })
    end,
  },
 
  ----------------------------------------------------------------------------
  -- Git change markers in the sign column
  ----------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end,
  },
 
  ----------------------------------------------------------------------------
  -- Comment toggling: gcc for a line, gc over a visual selection
  ----------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
 
  ----------------------------------------------------------------------------
  -- Auto-close brackets, quotes, parentheses, etc.
  ----------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup() end,
  },
 
  ----------------------------------------------------------------------------
  -- Indentation guide lines
  ----------------------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("ibl").setup() end,
  },
 
  ----------------------------------------------------------------------------
  -- Pop-up showing available keybindings as you type (great for learning)
  ----------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("which-key").setup() end,
  },
 
})
 
