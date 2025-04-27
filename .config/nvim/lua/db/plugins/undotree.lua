return {
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle", -- Lazy load when the command ":UndotreeToggle" is executed
		event = "VeryLazy", -- Lazy load on the "VeryLazy" event
		opts = {
			-- Add any specific options for undotree here if needed
		},
		config = function()
			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })
		end,
	},
}
