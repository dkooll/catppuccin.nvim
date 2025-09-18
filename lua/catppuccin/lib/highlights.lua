local M = {}

local function normalize_style(style)
	if type(style) == 'table' then return style end
	if type(style) == 'string' then return { style } end
	return {}
end

function M.prepare(theme, opts)
	local merged = vim.tbl_deep_extend(
		'keep',
		vim.deepcopy(theme.custom_highlights),
		theme.integrations,
		theme.syntax,
		theme.editor
	)
	local prepared = {}

	for group, spec in pairs(merged) do
		local hl = vim.deepcopy(spec)
		for _, style in ipairs(normalize_style(hl.style)) do
			hl[style] = true
		end
		hl.style = nil

		if opts.no_italic then hl.italic = false end
		if opts.no_bold then hl.bold = false end
		if opts.no_underline then hl.underline = false end

		local custom = theme.custom_highlights[group]
		if hl.link and custom and custom.link == nil then
			hl.link = nil
		end

		prepared[group] = hl
	end

	return prepared
end

return M
