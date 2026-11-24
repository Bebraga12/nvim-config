-- Detecta o tipo de projeto a partir do arquivo atual e roda no Kitty
local M = {}

local function in_kitty(cmd, cwd)
  vim.fn.jobstart({ "kitty", "--hold", "-e", "bash", "-c", cmd }, { cwd = cwd })
end

local function read_json(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return ok and data or nil
end

-- Retorna (raiz, comando) para o projeto do buffer atual
function M.detect()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  local root = vim.fs.root(buf, { "pom.xml" })
  if root then
    local mvn = vim.uv.fs_stat(root .. "/mvnw") and "./mvnw" or "mvn"
    return root, mvn .. " spring-boot:run"
  end

  root = vim.fs.root(buf, { "build.gradle", "build.gradle.kts" })
  if root then
    local gradle = vim.uv.fs_stat(root .. "/gradlew") and "./gradlew" or "gradle"
    return root, gradle .. " bootRun"
  end

  root = vim.fs.root(buf, { "ionic.config.json" })
  if root then return root, "ionic serve" end

  root = vim.fs.root(buf, { "angular.json" })
  if root then return root, "npx ng serve -o" end

  root = vim.fs.root(buf, { "package.json" })
  if root then
    local pkg = read_json(root .. "/package.json") or {}
    local scripts = pkg.scripts or {}
    local pm = vim.uv.fs_stat(root .. "/pnpm-lock.yaml") and "pnpm"
      or vim.uv.fs_stat(root .. "/yarn.lock") and "yarn"
      or "npm"
    for _, s in ipairs({ "dev", "start", "serve" }) do
      if scripts[s] then return root, pm .. " run " .. s end
    end
  end

  -- Arquivo solto
  local dir = vim.fn.fnamemodify(file, ":h")
  local ft = vim.bo[buf].filetype
  local f = vim.fn.shellescape(file)
  if ft == "java" then return dir, "java " .. f end
  if ft == "javascript" then return dir, "node " .. f end
  if ft == "typescript" then return dir, "npx --yes tsx " .. f end
  return nil, nil
end

function M.run()
  vim.cmd("silent! write")
  local root, cmd = M.detect()
  if not cmd then
    vim.notify("Runner: não sei rodar este arquivo/projeto", vim.log.levels.WARN)
    return
  end
  vim.notify("Runner: " .. cmd .. "  (" .. root .. ")")
  in_kitty(cmd, root)
end

-- Roda os testes do projeto
function M.test()
  local buf = vim.api.nvim_get_current_buf()
  local root = vim.fs.root(buf, { "pom.xml" })
  if root then
    local mvn = vim.uv.fs_stat(root .. "/mvnw") and "./mvnw" or "mvn"
    return in_kitty(mvn .. " test", root)
  end
  root = vim.fs.root(buf, { "build.gradle", "build.gradle.kts" })
  if root then
    local gradle = vim.uv.fs_stat(root .. "/gradlew") and "./gradlew" or "gradle"
    return in_kitty(gradle .. " test", root)
  end
  root = vim.fs.root(buf, { "angular.json" })
  if root then return in_kitty("npx ng test", root) end
  root = vim.fs.root(buf, { "package.json" })
  if root then return in_kitty("npm test", root) end
  vim.notify("Runner: nenhum projeto encontrado", vim.log.levels.WARN)
end

return M
