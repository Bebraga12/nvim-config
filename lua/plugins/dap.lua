-- Debug: Java (nvim-jdtls), Node/TS (js-debug-adapter), Angular/Ionic no Firefox (firefox-debug-adapter)
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint" },
      { "<F8>", function() require("dap").continue() end, desc = "Debug: Iniciar/Continuar" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<F12>", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<S-F12>", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condição: ")) end, desc = "Breakpoint condicional" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Iniciar/Continuar" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Repetir último" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Encerrar" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Alternar UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Avaliar expressão" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

      -- ---------- JavaScript / TypeScript / Node / Angular ----------
      local js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      dap.adapters.firefox = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/firefox-debug-adapter",
      }
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = "node", args = { js_debug, "${port}" } },
        }
      end

      local js_configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: arquivo atual",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          -- arquivos .ts rodam via tsx (npx baixa se precisar)
          runtimeExecutable = function()
            return vim.fn.expand("%:e") == "ts" and "npx" or "node"
          end,
          runtimeArgs = function()
            return vim.fn.expand("%:e") == "ts" and { "--yes", "tsx" } or {}
          end,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: npm run dev",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Node: anexar a processo (--inspect)",
          processId = function() return require("dap.utils").pick_process() end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "firefox",
          request = "launch",
          name = "Firefox: Angular/Ionic (localhost)",
          reAttach = true,
          url = function()
            local port = vim.fs.root(0, { "ionic.config.json" }) and "8100" or "4200"
            return vim.fn.input("URL: ", "http://localhost:" .. port)
          end,
          webRoot = "${workspaceFolder}",
          firefoxExecutable = vim.fn.exepath("firefox"),
        },
      }
      for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "htmlangular" }) do
        dap.configurations[ft] = js_configs
      end
    end,
  },
}
