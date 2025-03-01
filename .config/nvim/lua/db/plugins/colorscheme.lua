return {
	"nyoom-engineering/oxocarbon.nvim",
	lazy = false, -- Load immediately
	priority = 1000, -- Ensures it loads before other plugins
	config = function()
		-- Set the colorscheme
		vim.cmd("colorscheme oxocarbon")

		-- Optional: Configure UI tweaks
		vim.opt.termguicolors = true
		vim.opt.background = "dark" -- Oxocarbon is a dark theme
	end,
}
