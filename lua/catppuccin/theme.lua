local palettes = require('catppuccin.palettes')
local utils = require('catppuccin.utils.colors')

local M = {}

local function safe_require(name)
  local ok, mod = pcall(require, name)
  if ok then return mod end
end

local function compute_dim(palette, options)
  local cfg = options.dim_inactive or {}
  if not cfg.enabled then return palette.base end
  local percentage = cfg.percentage or 0.15
  if cfg.shade == 'light' then
    return utils.vary_color(
      { latte = utils.lighten('#FBFCFD', percentage, palette.base) },
      utils.lighten(palette.surface0, percentage, palette.base)
    )
  end
  return utils.vary_color(
    { latte = utils.darken(palette.base, percentage, palette.mantle) },
    utils.darken(palette.base, percentage, palette.mantle)
  )
end

function M.build(flavour, options, defaults)
  local palette = palettes.get_palette(flavour)
  local color_overrides = options.color_overrides or {}
  local flavour_override = color_overrides[flavour]
  if flavour_override then
    palette = vim.tbl_deep_extend('force', palette, flavour_override)
  end
  palette.none = 'NONE'
  palette.dim = compute_dim(palette, options)

  local prev = { O = _G.O, C = _G.C, U = _G.U }
  _G.O, _G.C, _G.U = options, palette, utils

  local theme = {}
  theme.syntax = require('catppuccin.groups.syntax').get()
  theme.editor = require('catppuccin.groups.editor').get()
  theme.terminal = require('catppuccin.groups.terminal').get()

  local final_integrations = {}
  for name, value in pairs(options.integrations or {}) do
    local enabled = false
    if type(value) == 'table' then
      if value.enabled == nil then
        enabled = true
      else
        enabled = value.enabled
      end
    elseif value == true then
      local default = defaults and defaults[name]
      if type(default) == 'table' then
        value = vim.deepcopy(default)
      else
        value = { enabled = true }
      end
      options.integrations[name] = value
      enabled = true
    end

    if enabled then
      local mod = safe_require('catppuccin.groups.integrations.' .. name)
      if mod and type(mod.get) == 'function' then
        final_integrations = vim.tbl_deep_extend('force', final_integrations, mod.get())
      end
    end
  end

  theme.integrations = final_integrations

  local overrides = options.highlight_overrides or {}
  local all = overrides.all
  if type(all) == 'function' then all = all(palette) end
  local per_flavour = overrides[flavour]
  if type(per_flavour) == 'function' then per_flavour = per_flavour(palette) end
  theme.custom_highlights = vim.tbl_deep_extend('keep', per_flavour or {}, all or {})

  _G.O, _G.C, _G.U = prev.O, prev.C, prev.U

  return theme, palette
end

return M
