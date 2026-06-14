# NeoVim Setup

A modern, batteries-included Neovim setup for C, C++, C#, and Python
development (plus general scripting). Built and tested on Kali Linux, but
portable to any Linux or macOS machine.

## Features

- **Syntax highlighting** (via Treesitter) for C, C++, C#, Python, Lua, Bash,
  Markdown, JSON, and YAML
- **Language server support** (LSP) for C/C++ (`clangd`), Python (`pyright`),
  C# (`omnisharp`), and Lua (`lua_ls`) — autocomplete, go-to-definition, hover
  docs, diagnostics, and renaming, all installed automatically via Mason
- **Dark colorscheme** (Tokyo Night), line numbers, and a status line
- **Full mouse support** — click to move the cursor, drag to select, scroll
  to scroll, double-click to open files in the tree
- **System clipboard integration** for copying/pasting between Neovim and the
  rest of your desktop
- **File explorer** and **fuzzy file/text search**
- **Keyboard-first navigation** — window/buffer switching, line moving,
  centered scrolling, and a "which-key" popup that shows available shortcuts
  as you type

## Requirements

- Neovim **0.11 or newer** — check with `nvim --version`
- `git`
- A C compiler (`gcc`/`clang`) — needed to build Treesitter parsers
- `ripgrep` — needed for live text search
- `xclip` (X11) or `wl-clipboard` (Wayland) — needed for clipboard sync
- A [Nerd Font](https://www.nerdfonts.com) in your terminal — needed for
  file-type icons to render (otherwise you'll see boxes or `?` instead of
  icons)

### Install everything on Kali / Debian / Ubuntu

```bash
sudo apt update
sudo apt install -y neovim git ripgrep xclip unzip nodejs npm curl build-essential 
```

If `nvim --version` reports something below 0.11, see
[Updating Neovim](#updating-neovim) below.

## Installation

```bash
git clone https://github.com/Rphasical/NeoVim_AutoConfig.git ~/.config/nvim
nvim
```

On first launch:

1. `lazy.nvim` (the plugin manager) bootstraps itself and installs every
   plugin. This needs internet access and takes a minute or two.
2. Once it finishes, close and reopen Neovim (`:qa`, then `nvim` again).
3. Mason then installs the language servers (`clangd`, `pyright`,
   `omnisharp`, `lua_ls`) in the background. Watch progress with `:Mason`.

Open a C, C++, Python, or C# file — highlighting, diagnostics, and completion
should all be working within a minute or two of the first launch.

## Using This on Multiple Machines

Clone the same repo to `~/.config/nvim` on each machine and run `nvim`.
lazy.nvim and Mason will install whatever's needed locally — plugin binaries
and language servers aren't portable across machines/architectures, so each
one does its own first-run install.

After your first successful setup, a `lazy-lock.json` file appears in
`~/.config/nvim/`. **Commit that file to your repo** — it pins exact plugin
versions, so every machine that clones the repo gets the same versions
instead of "whatever's newest today."

## Keybindings

The leader key is **Space**. Tap Space and pause — a popup (which-key) shows
you what's available from there.

### General

| Key | Action |
| --- | --- |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<Esc>` | Clear search highlighting |
| `<leader>tt` | Open a terminal in a split |
| `<Esc><Esc>` (in terminal) | Return to normal mode |

### Windows & Buffers

| Key | Action |
| --- | --- |
| `Ctrl + h/j/k/l` | Move between window splits |
| `Ctrl + ↑ ↓ ← →` | Resize the current split |
| `Shift + l` / `Shift + h` | Next / previous buffer |
| `<leader>bd` | Close current buffer |

### Movement & Editing

| Key | Action |
| --- | --- |
| `Alt + j` / `Alt + k` | Move current line (or selection) down/up |
| `<` / `>` (visual mode) | Indent/outdent, keeping the selection |
| `Ctrl + d` / `Ctrl + u` | Half-page scroll, cursor stays centered |
| `gcc` | Toggle comment on current line |
| `gc` (visual mode) | Toggle comment on selection |
| `p` (visual mode) | Paste over selection without losing your last yank |

### Files & Search

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle file explorer (`g?` inside it shows its full help) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across the project (needs ripgrep) |
| `<leader>fb` | Switch between open buffers |
| `<leader>fh` | Search help docs |

### LSP (active when a language server is attached)

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | List references |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |

### Autocomplete (insert mode)

| Key | Action |
| --- | --- |
| `Ctrl + Space` | Open suggestions manually |
| `Tab` / `Shift + Tab` | Next/previous suggestion, or jump through snippet placeholders |
| `Enter` | Accept the selected suggestion |

## Mouse & Clipboard

With `mouse=a` enabled, you can click to move the cursor, drag to make a
selection, scroll to scroll, and double-click a file in the explorer to open
it.

To copy text **to your system clipboard** (e.g. to paste into a browser or
report):

1. Drag to select text (or use a Vim selection like `viw` for "select word")
2. Press `y` to yank — with `clipboard=unnamedplus` and `xclip` installed,
   this also copies to the system clipboard
3. Paste outside Neovim as normal (`Ctrl+V`, right-click paste, etc.)

**Alternative**: most terminal emulators let you hold **Shift** while
dragging to bypass Neovim entirely and use the terminal's own selection —
handy for a quick copy without touching Vim modes.

If you're connecting to this machine over RDP / Hyper-V Enhanced Session,
clipboard redirection in that connection lets the system clipboard above
bridge through to your host machine's clipboard too.

## If You're New to Vim Motions

The keybindings above build on Vim's normal movement keys. The essentials:

| Key | Action |
| --- | --- |
| `h` `j` `k` `l` | Left, down, up, right |
| `w` / `b` | Jump forward/back one word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `i` / `a` | Insert before / after cursor |
| `o` | Open a new line below and insert |
| `dd` / `yy` / `p` | Delete / copy / paste a line |
| `u` / `Ctrl+r` | Undo / redo |
| `:w` / `:q` | Save / quit |

Because line numbers are **relative** (except on the current line), you can
combine a count with a movement — e.g. `5j` moves down 5 lines, `3dd` deletes
3 lines. This is usually the fastest way to move around once it clicks.

## Customizing

- **Change the colorscheme**: edit the `tokyonight` block near the top of
  `init.lua`. Other popular dark themes (`catppuccin/nvim`,
  `ellisonleao/gruvbox.nvim`, `rebelot/kanagawa.nvim`) follow the same
  `lazy = false, priority = 1000` pattern.
- **Add another language**: add its name to `ensure_installed` in the
  Treesitter block (for highlighting) and, if it has a language server, to
  `ensure_installed` in the `mason-lspconfig` block (for LSP).
- **Add code formatting** (e.g. `clang-format`, `black`, `csharpier`): a
  popular next step is `stevearc/conform.nvim`, which wires formatters up to
  save or a keybinding.

## A Note on Plugin Updates

The Neovim plugin ecosystem moves quickly. As of mid-2026, this config:

- Pins `nvim-treesitter` to its `master` branch, which keeps the
  long-standing `ensure_installed` / `setup()` API used here. The plugin's
  `main` branch is a full rewrite with a different setup process.
- Uses Neovim's built-in `vim.lsp.config()` / `vim.lsp.enable()`
  (Neovim 0.11+) instead of the older `require('lspconfig')...setup{}`
  pattern, which is being phased out.

If a future `:Lazy update` introduces breaking changes, `:checkhealth`, the
`:Lazy` UI (which flags plugin errors), and the relevant plugin's GitHub
README are the best places to start.

## Troubleshooting

- **Icons look like boxes or `?`** — install a Nerd Font and set it as your
  terminal's font.
- **Clipboard not syncing with the system** — install `xclip` (X11) or
  `wl-clipboard` (Wayland), then restart Neovim.
- **Treesitter parser fails to build** — make sure `build-essential`
  (or `gcc`/`clang`) and `git` are installed, then run `:TSUpdate`.
- **A language server isn't working** — run `:Mason` to confirm it
  installed, `:LspInfo` to check if it's attached, and `:checkhealth vim.lsp`
  for diagnostics.
- **C# / OmniSharp** — works best when you open a folder containing a `.sln`
  or `.csproj` file. OmniSharp itself is self-contained via Mason, but to
  actually *build and run* C# projects you'll also want the
  [.NET SDK](https://learn.microsoft.com/en-us/dotnet/core/install/linux)
  installed separately.

## Updating Neovim

If your distro's Neovim is older than 0.11:

```bash
# Option 1: Neovim's "unstable" PPA (Ubuntu/Debian-based)
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Option 2: download the AppImage directly from the releases page
# https://github.com/neovim/neovim/releases
```
