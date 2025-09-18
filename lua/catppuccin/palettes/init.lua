local M = {}

local palettes = {
  mocha = require('catppuccin.palettes.mocha'),
}

function M.get_palette(flavour)
  flavour = flavour or 'mocha'
  local base = palettes[flavour]
  if not base then
    error(('catppuccin: unsupported flavour "%s"'):format(tostring(flavour)))
  end
  return vim.deepcopy(base)
end

return M
