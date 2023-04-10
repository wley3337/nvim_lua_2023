local function init()
  -- leader key
  vim.g.mapleader = " "

  -- disable netrw for nvim-tree
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- pretty colors
  vim.opt.termguicolors = true
end

init()
