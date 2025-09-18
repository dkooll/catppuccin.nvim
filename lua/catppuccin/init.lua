local theme = require('catppuccin.theme')

local M = {}

M.default_options = {
  flavour = 'mocha',
  background = {
    light = 'latte',
    dark = 'mocha',
  },
  compile_path = vim.fn.stdpath('cache') .. '/catppuccin',
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { 'italic' },
    conditionals = { 'italic' },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    miscs = {},
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    lualine = true,
    neotree = true,
    indent_blankline = {
      enabled = true,
      scope_color = '',
      colored_indent_levels = false,
    },
    nvimtree = true,
    telescope = { enabled = true },
    treesitter = true,
    which_key = true,
  },
  color_overrides = {},
  highlight_overrides = {},
}

M.options = vim.deepcopy(M.default_options)
M.flavour = M.default_options.flavour
M.path_sep = package.config:sub(1, 1)

local function resolve_flavour(preferred)
  if preferred and preferred ~= 'auto' then return preferred end
  local background = vim.o.background == 'light' and 'light' or 'dark'
  return M.options.background[background] or 'mocha'
end

local function apply_highlights(compiled_theme, opts, flavour)
  vim.o.termguicolors = true
  if vim.g.colors_name then vim.cmd('hi clear') end

  if flavour == 'latte' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end

  vim.g.colors_name = 'catppuccin-' .. flavour

  if opts.term_colors then
    for name, value in pairs(compiled_theme.terminal) do
      vim.g[name] = value
    end
  end

  local merged = vim.tbl_deep_extend(
    'keep',
    vim.deepcopy(compiled_theme.custom_highlights),
    compiled_theme.integrations,
    compiled_theme.syntax,
    compiled_theme.editor
  )

  for group, spec in pairs(merged) do
    local hl = vim.deepcopy(spec)
    if type(hl.style) == 'table' then
      for _, style in ipairs(hl.style) do
        hl[style] = true
      end
      hl.style = nil
    end

    if opts.no_italic then hl.italic = false end
    if opts.no_bold then hl.bold = false end
    if opts.no_underline then hl.underline = false end

    local custom = compiled_theme.custom_highlights[group]
    if hl.link and custom and custom.link == nil then
      hl.link = nil
    end

    vim.api.nvim_set_hl(0, group, hl)
  end
end

function M.setup(user_conf)
  user_conf = user_conf or {}
  local merged = vim.tbl_deep_extend('force', vim.deepcopy(M.default_options), user_conf)
  merged.highlight_overrides = merged.highlight_overrides or {}
  if user_conf.custom_highlights then
    merged.highlight_overrides.all = user_conf.custom_highlights
  end

  M.options = merged
  M.flavour = merged.flavour
  return merged
end

function M.load(flavour)
  if not M.options then M.setup() end
  local resolved = resolve_flavour(flavour or M.options.flavour)
  M.flavour = resolved

  local result_theme = theme.build(resolved, M.options, M.default_options.integrations)
  apply_highlights(result_theme, M.options, resolved)
end

return M
