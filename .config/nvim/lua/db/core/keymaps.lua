-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
---------------------
local which_key = require("which-key")

-- Register key groups for better descriptions in the first modal
which_key.register({
	c = { name = "CopyPath/GitHubRemote" }, -- Grouping copy and GitHub-related commands
	s = { name = "Splits" }, -- Grouping split-related commands
	t = { name = "Tabs" }, -- Grouping tab-related commands
	n = { name = "Highlights" }, -- Clear search highlights
	e = { name = "File Explorer" }, -- Clear search highlights
	h = { name = "Git" }, -- Clear search highlights
	m = { name = "Format" }, -- Clear search highlights
	l = { name = "LazyGit" }, -- Clear search highlights
	z = { name = "Debugger" }, -- Clear search highlights
	f = { name = "FileFinder" }, -- Clear search highlights
	w = { name = "Sessions" }, -- Clear search highlights
	r = { name = "LSP" }, -- Clear search highlights
}, { prefix = "<leader>" })
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tabt

-- Function to copy relative file path
vim.keymap.set("n", "<leader>cr", function()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path) -- Copy to system clipboard
	print("Copied relative path: " .. path)
end, { desc = "Copy Relative File Path" })

-- Function to copy absolute file path
vim.keymap.set("n", "<leader>cs", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path) -- Copy to system clipboard
	print("Copied absolute path: " .. path)
end, { desc = "Copy Absolute File Path" })

-- Lua function to open the current file on GitHub using the git openfile command
function open_remote_file_on_github()
	-- Get the relative path of the current file (relative to the git repository)
	local file_path = vim.fn.expand("%") -- This gets the relative path of the current file

	-- Use vim.fn.system() to run the git openfile command with the relative file path
	vim.fn.system(string.format("git openfile %s", file_path))
end

vim.keymap.set(
	"n",
	"<leader>cg",
	":lua open_remote_file_on_github()<CR>",
	{ desc = "Open remote github file", noremap = true, silent = true }
)
