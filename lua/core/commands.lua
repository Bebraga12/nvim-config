local cmd = vim.api.nvim_create_user_command

-- :SpringInit <nome> [dependencias] [versao-java]
cmd("SpringInit", function(opts)
  local name, deps, java = opts.fargs[1], opts.fargs[2] or "web,data-jpa,postgresql,lombok,validation,devtools", opts.fargs[3] or "21"
  if not name then
    vim.notify("Uso: :SpringInit <nome> [dependencias] [java]\nEx: :SpringInit loja web,security,data-jpa,postgresql 21", vim.log.levels.WARN)
    return
  end
  local esc = vim.fn.shellescape
  local sh = string.format(
    "curl -fsSL https://start.spring.io/starter.zip -d type=maven-project -d language=java -d javaVersion=%s -d dependencies=%s -d name=%s -d artifactId=%s -o %s && unzip -q %s -d %s && rm %s",
    esc(java), esc(deps), esc(name), esc(name), esc(name .. ".zip"), esc(name .. ".zip"), esc(name), esc(name .. ".zip")
  )
  vim.fn.jobstart({ "bash", "-c", sh }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Projeto Spring '" .. name .. "' gerado (" .. deps .. ")")
        else
          vim.notify("SpringInit falhou (código " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { nargs = "*" })

-- :NgGenerate <schematic> <nome>   ex: :NgGenerate component pages/home
cmd("NgGenerate", function(opts)
  local root = vim.fs.root(0, { "angular.json" }) or vim.fn.getcwd()
  local args = vim.list_extend({ "npx", "ng", "generate" }, opts.fargs)
  vim.fn.jobstart(args, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data) if data then vim.schedule(function() vim.notify(table.concat(data, "\n")) end) end end,
    on_stderr = function(_, data)
      local msg = table.concat(data or {}, "\n")
      if msg:match("%S") then vim.schedule(function() vim.notify(msg, vim.log.levels.WARN) end) end
    end,
  })
end, {
  nargs = "+",
  complete = function()
    return { "component", "service", "module", "directive", "pipe", "guard", "interceptor", "interface", "class", "enum", "resolver", "environments" }
  end,
})

-- :IonicGenerate <tipo> <nome>   ex: :IonicGenerate page login
cmd("IonicGenerate", function(opts)
  local root = vim.fs.root(0, { "ionic.config.json" }) or vim.fn.getcwd()
  local args = vim.list_extend({ "ionic", "generate" }, opts.fargs)
  vim.fn.jobstart(args, {
    cwd = root,
    stdout_buffered = true,
    on_stdout = function(_, data) if data then vim.schedule(function() vim.notify(table.concat(data, "\n")) end) end end,
  })
end, {
  nargs = "+",
  complete = function()
    return { "page", "component", "service", "module", "class", "directive", "guard", "pipe", "interface", "enum" }
  end,
})

-- :Ionic <subcomando>   ex: :Ionic serve | :Ionic cap run android -l --external
cmd("Ionic", function(opts)
  local root = vim.fs.root(0, { "ionic.config.json" }) or vim.fn.getcwd()
  vim.fn.jobstart({ "kitty", "--hold", "-e", "bash", "-c", "ionic " .. opts.args }, { cwd = root })
end, { nargs = "+" })

cmd("Run", function() require("core.runner").run() end, {})
cmd("Test", function() require("core.runner").test() end, {})
