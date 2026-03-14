local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

if vim.treesitter.language and not vim.treesitter.language.ft_to_lang then
	vim.treesitter.language.ft_to_lang = function(ft)
		return ft
	end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Ensure leader key is set here again
require("lazy").setup({
	-- Plugins configuration
	{ import = "db.plugins" },
	{ import = "db.plugins.lsp" },
	{ import = "db.plugins.dap" },
}, {
	-- Lazy.nvim options
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
