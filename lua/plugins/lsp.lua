return {
  -- Tipagem/autocomplete da API do Neovim ao editar esta config
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  -- Java: iniciado em ftplugin/java.lua
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
  },

  -- Schemas para package.json, tsconfig, angular.json, docker-compose, GitHub Actions...
  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- Capabilities do nvim-cmp para TODOS os servidores
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- ---------- Configs específicas ----------
      -- HTML também nos templates do Angular/Ionic (filetype htmlangular)
      vim.lsp.config("html", { filetypes = { "html", "htmlangular" } })

      -- Angular só sobe em projetos com angular.json (não em Node puro)
      vim.lsp.config("angularls", { workspace_required = true })

      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literals",
              includeInlayFunctionLikeReturnTypeHints = true,
            },
            preferences = { importModuleSpecifier = "relative" },
          },
          javascript = {
            inlayHints = { includeInlayParameterNameHints = "literals" },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML (application.yml do Spring, docker-compose, CI...)
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
            keyOrdering = false,
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { completion = { callSnippet = "Replace" } } },
      })

      vim.lsp.config("eslint", {
        settings = { workingDirectories = { mode = "auto" } },
      })

      -- ---------- Instalação / ativação ----------
      require("mason-lspconfig").setup({
        ensure_installed = {
          "jdtls",           -- Java (iniciado pelo nvim-jdtls em ftplugin/java.lua)
          "ts_ls",           -- TypeScript / JavaScript / Node
          "angularls",       -- Angular / Ionic templates
          "eslint",          -- Lint JS/TS
          "html",
          "cssls",           -- CSS / SCSS / LESS
          "jsonls",
          "yamlls",
          "lemminx",         -- XML (pom.xml)
          "lua_ls",
          "r_language_server",
        },
        -- jdtls é gerenciado pelo nvim-jdtls; não deixar o lspconfig iniciar outro
        automatic_enable = { exclude = { "jdtls" } },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd",           -- formatter web
          "stylua",              -- formatter lua
          "java-debug-adapter",  -- debug Java
          "java-test",           -- rodar/debugar testes JUnit
          "js-debug-adapter",    -- debug Node
          "firefox-debug-adapter", -- debug Angular/Ionic no navegador
        },
      })
      -- o plugin é carregado depois do VimEnter, então dispara a checagem manualmente
      if vim.v.vim_did_enter == 1 then require("mason-tool-installer").run_on_start() end

      -- ---------- Keymaps quando um LSP conecta ----------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("braga-lsp", { clear = true }),
        callback = function(ev)
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          local tb = function(name) return function() require("telescope.builtin")[name]() end end

          map("K", vim.lsp.buf.hover, "Documentação")
          map("<F5>", vim.lsp.buf.hover, "Documentação")
          map("<F5>", function() vim.cmd("stopinsert"); vim.lsp.buf.hover() end, "Documentação", "i")
          map("<C-k>", vim.lsp.buf.signature_help, "Assinatura", "i")
          map("gd", tb("lsp_definitions"), "Ir para definição")
          map("gD", vim.lsp.buf.declaration, "Ir para declaração")
          map("gr", tb("lsp_references"), "Referências")
          map("gi", tb("lsp_implementations"), "Implementações")
          map("gt", tb("lsp_type_definitions"), "Definição do tipo")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<A-CR>", vim.lsp.buf.code_action, "Code action", { "n", "i" })
          map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
          map("<F7>", vim.lsp.buf.rename, "Renomear símbolo")
          map("<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Alternar inlay hints")

          -- TS/JS: organizar e adicionar imports
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "ts_ls" then
            map("<A-o>", function()
              vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
            end, "Organizar imports")
            map("<leader>ci", function()
              vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" }, diagnostics = {} } })
            end, "Adicionar imports faltando")
          end
        end,
      })
    end,
  },
}
