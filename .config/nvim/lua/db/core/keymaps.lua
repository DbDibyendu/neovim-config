-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
---------------------

-- Register key groups for better descriptions in the first modal
require("which-key").add({
	{ "<leader>c", group = "[C]opyPath/GitHubRemote" },
	{ "<leader>s", group = "[S]plits" },
	{ "<leader>t", group = "[T]abs" },
	{ "<leader>n", group = "[N]o Highlights" },
	{ "<leader>e", group = "[E]xplorer" },
	{ "<leader>h", group = "[H]it Git Commands" },
	{ "<leader>m", group = "[M]ake Format" },
	{ "<leader>l", group = "[L]azyGit" },
	{ "<leader>z", group = "[Z]ebugger" },
	{ "<leader>f", group = "[F]ileFinder" },
	{ "<leader>w", group = "[W]orkspace Sessions" },
	{ "<leader>r", group = "[R]LSP" },
})

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

-- default file explorer
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { noremap = true, silent = true })

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

-- fold option for neovim
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true -- Enable folding
vim.opt.foldcolumn = "1" -- Show a fold column on the left

-- Window navigation using Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Optional: Make these work in terminal mode too
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- cursor
