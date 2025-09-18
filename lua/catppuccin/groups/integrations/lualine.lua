local M = {}

local function to_highlight(spec)
	local hl = { fg = spec.fg, bg = spec.bg }
	if spec.gui then
		if type(spec.gui) == 'string' then
			hl.style = { spec.gui }
		elseif type(spec.gui) == 'table' then
			hl.style = spec.gui
		end
	end
	return hl
end

function M.get()
	local theme = require('catppuccin.utils.lualine')()
	local highlights = {}

	for mode, sections in pairs(theme) do
		for section, spec in pairs(sections) do
			highlights[string.format('lualine_%s_%s', section, mode)] = to_highlight(spec)
		end
	end

	return highlights
end

return M
