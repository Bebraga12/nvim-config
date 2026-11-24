return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- busca mais rápida
      "nvim-telescope/telescope-ui-select.nvim", -- code actions/menus no Telescope
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { horizontal = { preview_width = 0.55 } },
          sorting_strategy = "ascending",
          prompt_prefix = " Buscar: ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = {
            "node_modules/", "%.git/", "target/", "dist/", "www/", "%.angular/",
            "android/app/build/", "ios/App/Pods/", "build/", "%.class$",
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
