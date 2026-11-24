return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    require("nvim-web-devicons").setup({
      override_by_extension = {
        -- Java / Spring
        java = { icon = "", name = "Java" },
        xml = { icon = "󰗀", name = "Xml" },
        properties = { icon = "", name = "Properties" },
        yml = { icon = "󰈙", name = "Yaml" },
        yaml = { icon = "󰈙", name = "Yaml" },
        gradle = { icon = "", name = "Gradle" },

        -- Angular / Frontend
        ts = { icon = "", name = "TypeScript" },
        js = { icon = "", name = "JavaScript" },
        html = { icon = "", name = "Html" },
        css = { icon = "", name = "Css" },
        scss = { icon = "", name = "Scss" },
        sass = { icon = "", name = "Sass" },
        json = { icon = "", name = "Json" },

        -- Backend / Geral
        lua = { icon = "", name = "Lua" },
        py = { icon = "", name = "Python" },
        php = { icon = "", name = "Php" },
        go = { icon = "", name = "Go" },
        rs = { icon = "", name = "Rust" },
        c = { icon = "", name = "C" },
        cpp = { icon = "", name = "Cpp" },
        h = { icon = "", name = "Header" },

        -- Shell / Config
        sh = { icon = "", name = "Shell" },
        bash = { icon = "", name = "Bash" },
        zsh = { icon = "", name = "Zsh" },
        toml = { icon = "", name = "Toml" },
        env = { icon = "", name = "Env" },

        -- Docs
        md = { icon = "", name = "Markdown" },
        txt = { icon = "󰈙", name = "Text" },
        pdf = { icon = "", name = "Pdf" },

        -- Imagens
        png = { icon = "󰉏", name = "Png" },
        jpg = { icon = "󰉏", name = "Jpg" },
        jpeg = { icon = "󰉏", name = "Jpeg" },
        gif = { icon = "󰵸", name = "Gif" },
        svg = { icon = "󰜡", name = "Svg" },
      },

      override_by_filename = {
        ["package.json"] = { icon = "", name = "PackageJson" },
        ["package-lock.json"] = { icon = "", name = "PackageLockJson" },
        ["angular.json"] = { icon = "", name = "AngularJson" },
        ["tsconfig.json"] = { icon = "", name = "TsConfig" },
        ["pom.xml"] = { icon = "", name = "Maven" },
        ["Dockerfile"] = { icon = "", name = "Dockerfile" },
        [".gitignore"] = { icon = "", name = "GitIgnore" },
        [".env"] = { icon = "", name = "Env" },
      },
    })

    require("nvim-tree").setup({
      view = {
        width = 30,
      },

      -- Sincroniza com o diretório/arquivo atual
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },

      filters = {
        custom = { "^.git$", "^node_modules$", "^.angular$" },
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        icons = {
          hint = "󰌶",
          info = "",
          warning = "",
          error = "",
        },
      },

      renderer = {
        highlight_git = true,
        highlight_diagnostics = true,
        group_empty = true,

        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            diagnostics = true,
          },

          glyphs = {
            folder = {
              arrow_closed = "›",
              arrow_open = "▼",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },

            git = {
              unstaged = "M",
              staged = "S",
              untracked = "U",
              renamed = "R",
              unmerged = "UU",
              deleted = "D",
              ignored = "◌",
            },
          },
        },
      },
    })
  end,
}
