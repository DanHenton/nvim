return {
  "my-vue-setup",
  virtual = true,
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    local lspconfig = require('lspconfig')
    
    -- We can get capabilities from cmp_nvim_lsp if available
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if has_cmp then
      capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
    end

    -- Define your servers and their config
    local servers = {
      volar = {
        capabilities = capabilities,
        filetypes = { 'vue' },
      },
      tailwindcss = {
        capabilities = capabilities,
        filetypes = { "html", "vue", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_dir = lspconfig.util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts', 'package.json'),
      },
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        }
      }
    }

    -- Automatically install and setup the servers
    local registry = require("mason-registry")
    
    local lsp_to_mason = {
      volar = "vue-language-server",
      tailwindcss = "tailwindcss-language-server",
      emmet_ls = "emmet-language-server"
    }
    
    for server_name, server_config in pairs(servers) do
      local package_name = lsp_to_mason[server_name] or server_name
      
      -- If the package is installed, or we don't know the mason name, set it up
      if registry.has_package(package_name) then
        local pkg = registry.get_package(package_name)
        if pkg:is_installed() then
          lspconfig[server_name].setup(server_config)
        else
          -- Auto-install if not installed
          vim.notify("Installing " .. package_name .. " via Mason...", vim.log.levels.INFO)
          pkg:install():once("closed", function()
            if pkg:is_installed() then
              vim.schedule(function()
                vim.notify(package_name .. " installed! Setting up LSP...", vim.log.levels.INFO)
                lspconfig[server_name].setup(server_config)
                -- Attempt to start the server for the current buffer if it matches filetype
                vim.cmd("silent! LspStart " .. server_name)
              end)
            end
          end)
        end
      else
        -- Fallback if not found in Mason registry (e.g. system installed)
        lspconfig[server_name].setup(server_config)
      end
    end
  end,
}
