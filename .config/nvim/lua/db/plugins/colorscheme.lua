return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			transparent = false, -- disable transparency
		})

		vim.cmd("colorscheme kanagawa-wave")
		vim.opt.background = "dark"

		-- Set background to dark grey instead of pure black
		local dark_grey = "#000000" -- very dark grey color

		vim.api.nvim_set_hl(0, "Normal", { bg = dark_grey })
	end,
}
