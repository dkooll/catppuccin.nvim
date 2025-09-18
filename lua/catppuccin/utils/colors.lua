local M = {}

local function hex_to_rgb(hex)
  hex = hex:gsub('#','')
  return tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16)
end

local function clamp(n)
  if n < 0 then return 0 end
  if n > 255 then return 255 end
  return math.floor(n + 0.5)
end

function M.blend(fg, bg, alpha)
  local fr, fg_, fb = hex_to_rgb(fg)
  local br, bg_, bb = hex_to_rgb(bg)
  local r = clamp(alpha * fr + (1 - alpha) * br)
  local g = clamp(alpha * fg_ + (1 - alpha) * bg_)
  local b = clamp(alpha * fb + (1 - alpha) * bb)
  return string.format('#%02X%02X%02X', r, g, b)
end

function M.darken(hex, amount, bg) return M.blend(hex, bg or '#000000', math.abs(amount)) end

function M.lighten(hex, amount, fg) return M.blend(hex, fg or '#FFFFFF', math.abs(amount)) end

function M.vary_color(palettes, default)
  local flavour = require('catppuccin').flavour
  if type(palettes) == 'table' then
    local candidate = palettes[flavour]
    if candidate ~= nil then return candidate end
  end
  return default
end

return M
