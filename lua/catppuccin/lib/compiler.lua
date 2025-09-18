local theme = require('catppuccin.theme')
local highlights_lib = require('catppuccin.lib.highlights')

local M = {}

local function normalize(value)
	local t = type(value)
	if t == 'table' then
		local keys = vim.tbl_keys(value)
		table.sort(keys, function(a, b)
			return tostring(a) < tostring(b)
		end)
		local normalized = {}
		for _, key in ipairs(keys) do
			normalized[key] = normalize(value[key])
		end
		return normalized
	elseif t == 'function' then
		local ok, dumped = pcall(string.dump, value)
		if ok then return dumped end
		local info = debug.getinfo(value, 'S') or {}
		return string.format('function:%s:%s', info.source or '?', info.linedefined or '?')
	end
	return value
end

local function hash(options)
	local ok, result = pcall(vim.fn.sha256, vim.inspect(normalize(options)))
	if ok then return result end
	return vim.inspect(normalize(options))
end

local function serialized(data)
	return 'return ' .. vim.inspect(data, { newline = ' ', indent = '' })
end

function M.compile(flavour, options, defaults, path_sep)
	local opts_copy = vim.deepcopy(options)
	local compiled_theme = select(1, theme.build(flavour, opts_copy, defaults))
	local highlights = highlights_lib.prepare(compiled_theme, opts_copy)
	local terminal = nil
	if options.term_colors then terminal = vim.deepcopy(compiled_theme.terminal) end
	local payload = {
		hash = hash(options),
		highlights = highlights,
		terminal = terminal,
	}

	local dir = options.compile_path
	if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end

	local file_path = table.concat({ dir, flavour .. '.lua' }, path_sep)
	local file, err = io.open(file_path, 'w')
	if not file then
		vim.notify(
			('catppuccin: could not write compiled file %s (%s)'):format(file_path, err or 'unknown error'),
			vim.log.levels.WARN
		)
		return payload
	end
	file:write(serialized(payload))
	file:close()

	return payload
end

function M.load(flavour, options, defaults, path_sep)
	local file_path = table.concat({ options.compile_path, flavour .. '.lua' }, path_sep)
	local chunk = loadfile(file_path)
	if not chunk then return end
	local ok, result = pcall(chunk)
	if not ok or type(result) ~= 'table' or not result.highlights then return end
	local current_hash = hash(options)
	if result.hash ~= current_hash then
		return M.compile(flavour, options, defaults, path_sep)
	end
	return result
end

return M
