vim.g.mapleader = " "
local ikeymap = function(key, map, opt)
  local opt = opt or {}
  vim.keymap.set("i", key, map, opt)
end

local nkeymap = function(key, map, opt)
  local opt = opt or {}
  vim.keymap.set("n", key, map, opt)
end

nkeymap("<leader>fe", "<cmd>NvimTreeToggle<CR>") -- built in file explorer

ikeymap("jk", "<ESC>")                           -- remap for quick escap
-- ikeymap("kj", "<ESC>") -- remap for quick escap
-- Better window navigation
nkeymap("<C-h>", "<C-w>h")
nkeymap("<C-j>", "<C-w>j")
nkeymap("<C-k>", "<C-w>k")
nkeymap("<C-l>", "<C-w>l")

--#region primeagen re-map

-- Allows you to move a highlighted group up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move through wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "J", "mzJ`z")       -- keeps the curser at the start of the line when using 'J' to bring next line up with space

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- keeps curser in the middle when moving the screen
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- keeps curser in the middle when moving the screen

vim.keymap.set("n", "n", "nzzzv")       -- keeps curser in the middle when searching the screen
vim.keymap.set("n", "N", "Nzzzv")       -- keeps curser in the middle when searching the screen


-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever @asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- yanks into system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])          -- yanks into system clipboard

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- delete to void register

-- vim.keymap.set("i", "<C-c>", "<Esc>") -- this is a remap from intelaJ vertical edit

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end)

--#region this is navigating the quick fix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--#endregion

-- allows you to start replacing the word that you're on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- it makes the current file into an exicutable
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--#endregion
--
-- GitSigns --
nkeymap("<leader>gb", ":GitBlameToggle<cr>")
