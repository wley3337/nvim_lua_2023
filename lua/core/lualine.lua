
local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
	print("LUALINE could not be found or installed")
	return
end
-- Set lualine as statusline
-- See `:help lualine.txt`
lualine.setup {
  options = {
    icons_enabled = false,
    theme = 'nightfly',
    component_separators = '|',
    section_separators = '',
  },
}
