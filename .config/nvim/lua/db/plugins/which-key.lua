return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		-- which key is for displaying keybindings
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {},
}
