local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
	print("GITSIGNS could not be found or installed")
	return
end
-- Gitsigns
-- See `:help gitsigns.txt`
gitsigns.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
