# Neovim Configuration (Kickstart) - Agent Guide

This repository contains a personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). 
It follows the standard Neovim Lua configuration structure.

## 1. Build, Lint, and Test

Since this is a configuration repository consisting primarily of Lua scripts, there is no traditional "build" step. 
However, formatting and syntax checking are critical.

### Formatting
The project uses **StyLua** for formatting. configuration is located in `.stylua.toml`.

*   **Check formatting:**
    ```bash
    stylua --check .
    ```
*   **Apply formatting:**
    ```bash
    stylua .
    ```

### Linting
There is no standalone linter (like `luacheck`) explicitly configured in the CI/build scripts. 
Linting is primarily handled by **LuaLS** (Lua Language Server) within the editor.

*   **Syntax Check:** You can use `luac` to verify syntax correctness if you are modifying core files.
    ```bash
    luac -p init.lua
    ```

### Testing
There is currently **no automated test suite** for this configuration.
*   Changes must be verified by starting Neovim and checking for startup errors or functional regressions.
*   If you add complex logic (e.g., a utility module in `lua/custom/utils.lua`), consider adding a corresponding test file if a harness becomes available, but for now, rely on manual verification and syntax checks.

## 2. Code Style & Conventions

### General Lua Guidelines
*   **Version:** LuaJIT (Neovim standard).
*   **Indentation:** **2 spaces** (Soft tabs).
*   **Line Length:** **160 columns** (as defined in `.stylua.toml`).
*   **Quotes:** Prefer **single quotes** (`'`) over double quotes, unless nesting quotes.
*   **Parentheses:** Omit parentheses for function calls with a single string or table argument (e.g., `require 'module'`, `setup {}`).

### Project Structure
*   `init.lua`: Entry point. Handles options, keymaps, lazy.nvim bootstrap, and core plugin loading.
*   `lua/kickstart/`: Core Kickstart modules (do not modify unless necessary to diverge from upstream).
*   `lua/custom/plugins/`: **User-specific plugins go here.** Each file should return a `lazy.nvim` plugin spec.

### Plugin Configuration (lazy.nvim)
When adding or modifying plugins, follow the `lazy.nvim` specification pattern.
Place new plugin configurations in `lua/custom/plugins/<name>.lua`.

**Example Pattern:**
```lua
return {
  'owner/repo',
  -- explicit dependencies
  dependencies = {
    'dep-owner/dep-repo',
  },
  -- "opts" forces the plugin to load and calls require('plugin').setup(opts)
  opts = {
    option_name = true,
  },
  -- Use "config" for complex setup requiring custom logic or autocommands
  config = function()
    require('plugin').setup({
      -- config here
    })
    
    -- Add keymaps related to this plugin here
    vim.keymap.set('n', '<leader>x', '<cmd>PluginCommand<cr>', { desc = 'Description' })
  end,
}
```

### Keymappings
*   Use `vim.keymap.set('mode', 'key', 'action', { options })`.
*   **Always** provide a `desc` field in the options table for `which-key` integration.
*   Use `<leader>` (mapped to space) for user-defined shortcuts.

**Example:**
```lua
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
```

### Autocommands
*   Use `vim.api.nvim_create_autocmd`.
*   **Always** group autocommands using `vim.api.nvim_create_augroup` to prevent duplication on reload.

**Example:**
```lua
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
```

### UI & UX
*   **Icons:** Use Nerd Font icons if `vim.g.have_nerd_font` is true.
*   **Notifications:** Use `vim.notify` for user feedback.

## 3. Workflow Rules

*   **Modifying Core:** Try to avoid modifying `init.lua` heavily if the change can be isolated to a module in `lua/custom/`.
*   **Dependencies:** When adding a plugin, check if it relies on external tools (like `ripgrep`, `fd`, `node`, etc.) and document if they are required.
*   **Safety:** Since there are no tests, be extremely careful with startup logic. A broken `init.lua` prevents the editor from opening.

## 4. Specific Tooling Configs

### Stylua (`.stylua.toml`)
*   `indent_type = "Spaces"`
*   `indent_width = 2`
*   `quote_style = "AutoPreferSingle"`
*   `call_parentheses = "None"`

### Cursor / Copilot Rules
*   No specific `.cursorrules` or `copilot-instructions.md` are currently present.
*   Follow the conventions outlined in this file.
