local M = {}

M.url = 'https://github.com/folke/lazy.nvim'

function M.get()
	local base_bg = O.transparent_background and C.none or C.base
	local accent_bg = O.transparent_background and C.none or C.surface0
	local lavender_bg = O.transparent_background and C.none or C.lavender

	return {
		LazyNormal = { fg = C.text, bg = base_bg },
		LazyNormalNC = { fg = C.text, bg = base_bg },
		LazyBorder = { fg = C.surface0, bg = base_bg },
		LazyDimmed = { fg = C.overlay1 },
		LazyComment = { fg = C.overlay0 },
		LazyProp = { fg = C.peach },
		LazyValue = { fg = C.green },
		LazyH1 = { fg = base_bg, bg = C.lavender, style = { 'bold' } },
		LazyH2 = { fg = C.lavender },
		LazyButton = { fg = C.text, bg = accent_bg },
		LazyButtonActive = { fg = O.transparent_background and C.lavender or C.base, bg = lavender_bg, style = { 'bold' } },
		LazySpecial = { fg = C.flamingo },
		LazyDir = { fg = C.sky },
		LazyUrl = { fg = C.teal, style = { 'underline' } },
		LazyTaskOutput = { fg = C.overlay2 },
		LazyProgressDone = { fg = C.green },
		LazyProgressTodo = { fg = C.surface1 },
		LazyReasonEvent = { fg = C.sky },
		LazyReasonPlugin = { fg = C.lavender },
		LazyReasonRuntime = { fg = C.teal },
		LazyReasonSource = { fg = C.sky },
		LazyReasonStart = { fg = C.sky },
		LazyReasonFt = { fg = C.teal },
		LazyError = { fg = C.red },
		LazyWarn = { fg = C.yellow },
		LazyInfo = { fg = C.sky },
		LazyHint = { fg = C.teal },
		LazySuccess = { fg = C.green },
	}
end

return M
