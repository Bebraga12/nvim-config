-- Mostra um quadradinho "■" com a cor antes de #hex / rgb() / rgba() (estilo VSCode)
-- Funciona com termguicolors desligado: a cor é aproximada para a paleta de 256 cores.
-- Se um dia ligar termguicolors, passa a mostrar a cor exata automaticamente.

local levels = { 0, 95, 135, 175, 215, 255 }

local function dist(r1, g1, b1, r2, g2, b2)
  return (r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2
end

-- RGB -> índice xterm-256 mais próximo (cubo 6x6x6 ou escala de cinza)
local function xterm256(r, g, b)
  local function q(v) return v < 48 and 0 or v < 115 and 1 or math.floor((v - 35) / 40) end
  local cr, cg, cb = q(r), q(g), q(b)
  local cube = 16 + 36 * cr + 6 * cg + cb
  local dcube = dist(r, g, b, levels[cr + 1], levels[cg + 1], levels[cb + 1])

  local avg = (r + g + b) / 3
  local gi = avg > 238 and 23 or math.max(0, math.floor((avg - 3) / 10))
  local gv = 8 + 10 * gi
  local dgray = dist(r, g, b, gv, gv, gv)

  return dgray < dcube and (232 + gi) or cube
end

local cache = {}
local function swatch_group(r, g, b)
  local hex = string.format("%02x%02x%02x", r, g, b)
  local name = "ColorSwatch_" .. hex
  if not cache[name] then
    vim.api.nvim_set_hl(0, name, { fg = "#" .. hex, ctermfg = xterm256(r, g, b) })
    cache[name] = true
  end
  return name
end

local function swatch(_, _, data)
  return {
    virt_text = { { "■ ", data.hl_group } },
    virt_text_pos = "inline",
    priority = 200,
    right_gravity = false,
  }
end

local function clamp(v) return math.max(0, math.min(255, math.floor(v + 0.5))) end

return {
  {
    "nvim-mini/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local hp = require("mini.hipatterns")
      local fts = {
        css = true, scss = true, sass = true, less = true,
        html = true, htmlangular = true, vue = true, svelte = true,
        javascript = true, typescript = true, javascriptreact = true, typescriptreact = true,
        json = true, jsonc = true, yaml = true, toml = true, lua = true, conf = true,
        kitty = true, hyprlang = true, markdown = true,
      }
      local function enabled(buf) return fts[vim.bo[buf].filetype] end

      hp.setup({
        highlighters = {
          -- #rrggbb e #rrggbbaa
          hex6 = {
            pattern = function(buf) return enabled(buf) and "#%x%x%x%x%x%x%f[%X]" or nil end,
            group = function(_, m)
              return swatch_group(tonumber(m:sub(2, 3), 16), tonumber(m:sub(4, 5), 16), tonumber(m:sub(6, 7), 16))
            end,
            extmark_opts = swatch,
          },
          hex8 = {
            pattern = function(buf) return enabled(buf) and "#%x%x%x%x%x%x%x%x%f[%X]" or nil end,
            group = function(_, m)
              return swatch_group(tonumber(m:sub(2, 3), 16), tonumber(m:sub(4, 5), 16), tonumber(m:sub(6, 7), 16))
            end,
            extmark_opts = swatch,
          },
          -- #rgb e #rgba
          hex3 = {
            pattern = function(buf) return enabled(buf) and "#%x%x%x%x?%f[%X]" or nil end,
            group = function(_, m)
              local function d(i) local c = m:sub(i, i); return tonumber(c .. c, 16) end
              return swatch_group(d(2), d(3), d(4))
            end,
            extmark_opts = swatch,
          },
          -- rgb(255, 0, 0) / rgba(255 0 0 / .5) / rgb(100% 0% 0%)
          rgb = {
            pattern = function(buf) return enabled(buf) and "rgba?%([%d%s,./%%]+%)" or nil end,
            group = function(_, m)
              local vals = {}
              for num, pct in m:gmatch("([%d.]+)(%%?)") do
                local v = tonumber(num)
                if not v then return nil end
                vals[#vals + 1] = pct == "%" and v * 2.55 or v
                if #vals == 3 then break end
              end
              if #vals < 3 then return nil end
              return swatch_group(clamp(vals[1]), clamp(vals[2]), clamp(vals[3]))
            end,
            extmark_opts = swatch,
          },
        },
      })

      -- Recria os grupos se o colorscheme for trocado
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() cache = {} end,
      })
    end,
  },
}
