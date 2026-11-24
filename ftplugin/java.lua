-- Java: nvim-jdtls (LSP + Lombok + debug + testes JUnit)
local ok, jdtls = pcall(require, "jdtls")
if not ok then return end

local mason = vim.fn.stdpath("data") .. "/mason/packages"
local root_dir = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
  or vim.fn.getcwd()

-- Workspace único por projeto (usa o caminho completo para evitar colisão de nomes)
local project_name = root_dir:gsub("^/", ""):gsub("/", "_")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

-- Lombok (vem junto com o jdtls do Mason)
local cmd = { "jdtls", "-data", workspace_dir }
local lombok = mason .. "/jdtls/lombok.jar"
if vim.uv.fs_stat(lombok) then
  table.insert(cmd, 2, "--jvm-arg=-javaagent:" .. lombok)
end

-- Bundles de debug e testes (java-debug-adapter + java-test do Mason)
local bundles = {}
vim.list_extend(bundles, vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true))
for _, jar in ipairs(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true, true)) do
  -- estes jars quebram o jdtls se forem carregados como bundle
  if not jar:match("com.microsoft.java.test.runner%-jar%-with%-dependencies.jar")
    and not jar:match("jacocoagent.jar") then
    table.insert(bundles, jar)
  end
end

-- JDKs instalados (/usr/lib/jvm) para o jdtls compilar na versão do projeto
local runtimes = {}
for _, v in ipairs({ "8", "11", "17", "21", "25" }) do
  local path = "/usr/lib/jvm/java-" .. v .. "-openjdk"
  if vim.uv.fs_stat(path) then
    table.insert(runtimes, {
      name = v == "8" and "JavaSE-1.8" or ("JavaSE-" .. v),
      path = path,
      default = v == "21",
    })
  end
end

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive", runtimes = runtimes },
      references = { includeDecompiledSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "literals" } },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      format = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "org.assertj.core.api.Assertions.*",
          "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
          "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
        },
        importOrder = { "java", "javax", "jakarta", "com", "org" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        useBlocks = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    -- Detecta classes com main() e cria configs de debug automaticamente
    pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
    pcall(require("jdtls.dap").setup_dap_main_class_configs)

    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = bufnr, desc = "Java: " .. desc })
    end
    -- Atalhos estilo Eclipse/IntelliJ
    map("<A-o>", jdtls.organize_imports, "Organizar imports")
    map("<C-S-o>", jdtls.organize_imports, "Organizar imports")
    map("<leader>jo", jdtls.organize_imports, "Organizar imports")
    map("<leader>jv", jdtls.extract_variable, "Extrair variável")
    map("<leader>jv", function() jdtls.extract_variable(true) end, "Extrair variável", "v")
    map("<leader>jc", jdtls.extract_constant, "Extrair constante")
    map("<leader>jc", function() jdtls.extract_constant(true) end, "Extrair constante", "v")
    map("<leader>jm", function() jdtls.extract_method(true) end, "Extrair método", "v")
    map("<leader>jt", jdtls.test_class, "Debug: testar classe")
    map("<leader>jT", jdtls.test_nearest_method, "Debug: testar método")
    map("<leader>jp", jdtls.pick_test, "Escolher teste")
    map("<leader>jg", function() require("jdtls.tests").generate() end, "Gerar teste da classe")
    map("<leader>js", function() require("jdtls.tests").goto_subjects() end, "Ir para teste/classe")
    map("<leader>ju", "<Cmd>JdtUpdateConfig<CR>", "Recarregar pom.xml/gradle")
    map("<leader>jb", "<Cmd>JdtCompile full<CR>", "Compilar projeto")
  end,
}

jdtls.start_or_attach(config)
