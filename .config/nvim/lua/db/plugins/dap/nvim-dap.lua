return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"leoluz/nvim-dap-go",
		"Weissle/persistent-breakpoints.nvim",
	},
	config = function()
		local dap = require("dap")

		-- Setup the go debug adapter
		require("dap-go").setup()

		-- Setup DAP virtual text
		require("nvim-dap-virtual-text").setup({})
		vim.g.dap_virtual_text = true

		-- Allows breakpoints to last between sessions
		require("persistent-breakpoints").setup({
			load_breakpoints_event = { "BufReadPost" },
		})

		-- Setup DAP UI
		local dapui = require("dapui")
		dapui.setup()

		-- Automatically open the DAP UI when the debugging session begins
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "", linehl = "", numhl = "" })

		-- Keymaps for debugging
		vim.keymap.set(
			"n",
			"<leader>zb",
			require("persistent-breakpoints.api").toggle_breakpoint,
			{ desc = "Toggle debugger breakpoint" }
		)
		vim.keymap.set("n", "<leader>zs", dap.continue, { desc = "Start dap" })
		vim.keymap.set("n", "<leader>zu", dapui.toggle, { desc = "Toggle Debugger UI" })
		-- DAP Keymaps
		vim.keymap.set("n", "<leader>zl", ":lua require('dap').run_last()<CR>", { desc = "Repeat Last" })
		vim.keymap.set("n", "<leader>zc", ":lua require('dap').continue()<CR>", { desc = "Continue" })
		vim.keymap.set("n", "<leader>zt", ":lua require('dap').terminate()<CR>", { desc = "Terminate" })
		vim.keymap.set("n", "<leader>zo", ":lua require('dap').step_over()<CR>", { desc = "Step Over" })
		vim.keymap.set("n", "<leader>zi", ":lua require('dap').step_into()<CR>", { desc = "Step Into" })
		vim.keymap.set("n", "<leader>zoo", ":lua require('dap').step_out()<CR>", { desc = "Step Out" })
		vim.keymap.set(
			"n",
			"<leader><F3>",
			":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>",
			{ desc = "Set breakpoint with condition" }
		)
		vim.keymap.set("n", "<leader>zx", ":lua require('dap').clear_breakpoints()<CR>", { desc = "Clear Breakpoints" })

		-- DAP Go Keymaps
		vim.keymap.set("n", "<leader>zg", ":lua require('dap-go').debug_test()<CR>", { desc = "Debug Go Code" })
	end,
}
