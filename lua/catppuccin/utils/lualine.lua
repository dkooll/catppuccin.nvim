return function(flavour)
	local C = require('catppuccin.palettes').get_palette(flavour)
	local O = require('catppuccin').options
	local theme = {}

	local transparent_bg = O.transparent_background and C.none or C.mantle

	theme.normal = {
		a = { bg = C.blue, fg = C.mantle, gui = 'bold' },
		b = { bg = C.surface0, fg = C.blue },
		c = { bg = transparent_bg, fg = C.text },
	}

	theme.insert = {
		a = { bg = C.green, fg = C.base, gui = 'bold' },
		b = { bg = C.surface0, fg = C.green },
	}

	theme.terminal = {
		a = { bg = C.green, fg = C.base, gui = 'bold' },
		b = { bg = C.surface0, fg = C.green },
	}

	theme.command = {
		a = { bg = C.peach, fg = C.base, gui = 'bold' },
		b = { bg = C.surface0, fg = C.peach },
	}

	theme.visual = {
		a = { bg = C.mauve, fg = C.base, gui = 'bold' },
		b = { bg = C.surface0, fg = C.mauve },
	}

	theme.replace = {
		a = { bg = C.red, fg = C.base, gui = 'bold' },
		b = { bg = C.surface0, fg = C.red },
	}

	theme.inactive = {
		a = { bg = transparent_bg, fg = C.blue },
		b = { bg = transparent_bg, fg = C.surface1, gui = 'bold' },
		c = { bg = transparent_bg, fg = C.overlay0 },
	}

	return theme
end
