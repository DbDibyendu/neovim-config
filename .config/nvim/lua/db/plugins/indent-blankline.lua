return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "VeryLazy", "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
}
