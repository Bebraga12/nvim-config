# nvim-config

Config do Neovim (0.12+) com [lazy.nvim](https://github.com/folke/lazy.nvim), voltada para **Java/Spring Boot**, **Angular**, **Ionic** e **Node/TypeScript**.

## Instalação

```bash
mv ~/.config/nvim ~/.config/nvim.bak   # se já existir
git clone git@github.com:Bebraga12/nvim-config.git ~/.config/nvim
nvim   # lazy.nvim instala os plugins; Mason instala LSPs/formatters/debuggers
```

### Dependências do sistema (Arch)

```bash
sudo pacman -S git gcc make unzip ripgrep fd tree-sitter-cli wl-clipboard \
               nodejs npm jdk21-openjdk maven lazygit kitty
npm i -g @angular/cli @ionic/cli
```

> `tree-sitter-cli` é obrigatório para o nvim-treesitter (branch `main`) compilar os parsers.
> Sem ele o highlight cai para o regex do Vim.

## O que tem

| Área | Plugins / ferramentas |
|---|---|
| LSP | nvim-lspconfig + Mason: `ts_ls`, `angularls`, `eslint`, `html`, `cssls`, `jsonls` (SchemaStore), `yamlls`, `lemminx` (pom.xml), `lua_ls`, `r_language_server` |
| Java | nvim-jdtls com **Lombok**, JDKs de `/usr/lib/jvm`, debug e testes JUnit (java-debug-adapter + java-test) |
| Completion | nvim-cmp + LuaSnip + friendly-snippets (snippets Java, Angular, TS, HTML) |
| Formatação | conform.nvim: prettierd (TS/JS/HTML/SCSS/JSON/YAML), stylua, jdtls para Java — ao salvar |
| Debug | nvim-dap + dap-ui: Java, Node/TS (js-debug), Angular/Ionic no Firefox |
| Syntax | nvim-treesitter (inclui parser `angular` para templates) + folds |
| HTML | emmet-vim, nvim-ts-autotag, nvim-autopairs |
| Git | gitsigns, lazygit |
| UI | nvim-tree, bufferline, lualine, telescope (+fzf, ui-select), which-key, trouble, todo-comments, indent-blankline, nvim-surround |

## Atalhos principais

Leader = `Espaço`. Aperte `Espaço` e espere para ver todos (which-key).

| Atalho | Ação |
|---|---|
| `F1` / `F2` / `<leader>E` | NvimTree: toggle / focar / revelar arquivo |
| `F3` | Alternar números relativos |
| `F4` | Kitty na raiz do projeto |
| `F5` / `K` | Documentação (hover) |
| `F6` | Preview Markdown |
| `F7` / `<leader>rn` | Renomear símbolo |
| `F8` `F9` `F10` `F12` `S-F12` | Debug: continuar, breakpoint, step over, into, out |
| `F11` / `<leader>rr` | **Run** — detecta Maven/Spring, Gradle, Ionic (`ionic serve`), Angular (`ng serve`), Node (`npm run dev/start`) ou arquivo solto |
| `<leader>rt` | Rodar testes do projeto |
| `gd` `gr` `gi` `gt` `gD` | Definição, referências, implementações, tipo, declaração |
| `<leader>ca` / `Alt+Enter` | Code action |
| `<leader>cf` / `<leader>tf` | Formatar / ligar-desligar formatar ao salvar |
| `<leader>e`, `[d`, `]d` | Diagnóstico da linha, anterior, próximo |
| `<leader>xx` | Lista de erros do projeto (Trouble) |
| `<leader>ff` `<C-p>` `<leader>fg` `<leader>fb` `<leader>fr` | Arquivos, grep, buffers, recentes |
| `<leader>fs` / `<leader>fS` | Símbolos do arquivo / projeto |
| `Alt+o` | Organizar imports (Java e TS) |
| `<leader>j*` | Java: extrair var/const/método, testar classe/método, gerar teste... |
| `<leader>v*` | Git hunks: preview, stage, reset, blame |
| `<leader>g` | Lazygit |
| `Ctrl+1..9`, `Shift+h/l` | Ir para buffer N / anterior / próximo |
| `Ctrl+w` | Fechar buffer (substitui o prefixo de janelas — use `Ctrl+h/j/k/l`) |
| `Ctrl+s` | Salvar |
| `Alt+j/k` | Mover linha/bloco |
| `<C-e>,` | Expandir Emmet |

## Comandos

- `:SpringInit <nome> [deps] [java]` — gera projeto no start.spring.io (padrão: `web,data-jpa,postgresql,lombok,validation,devtools`, Java 21)
- `:NgGenerate component pages/home` — `ng generate` na raiz do Angular
- `:IonicGenerate page login` — `ionic generate`
- `:Ionic cap run android -l --external` — qualquer comando ionic num Kitty
- `:Run` / `:Test`
