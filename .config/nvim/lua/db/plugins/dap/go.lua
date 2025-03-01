return {
	"leoluz/nvim-dap-go",
	event = "VeryLazy",
	dependencies = "mfussenegger/nvim-dap",
	ft = "go",
	config = function(_, opts)
		require("dap-go").setup(opts)
	end,
}
