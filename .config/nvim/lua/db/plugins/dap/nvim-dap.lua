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
		require("nvim-dap-virtual-text").setup({
			enabled = true, -- enable this plugin (the default)
			enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason = true, -- show stop reason when stopped for exceptions
			commented = false, -- prefix virtual text with comment string
			only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			all_references = false, -- show virtual text on all all references of the variable (not only definitions)
			clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
			--- A callback that determines how a variable is displayed or whether it should be omitted
			--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
			--- @param buf number
			--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
			--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
			--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
			--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
			display_callback = function(variable, buf, stackframe, node, options)
				-- by default, strip out new line characters
				if options.virt_text_pos == "inline" then
					return " = " .. variable.value:gsub("%s+", " ")
				else
					return variable.name .. " = " .. variable.value:gsub("%s+", " ")
				end
			end,
			-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
			virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

			-- experimental features:
			all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
			virt_lines = true, -- show virtual lines instead of virtual text (will flicker!)
			virt_text_win_col = 80, -- position the virtual text at a fixed window column (starting from the first text column) ,
			-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
		})
		vim.g.dap_virtual_text = true

		-- Allows breakpoints to last between sessions
		require("persistent-breakpoints").setup({
			load_breakpoints_event = { "BufReadPost" },
		})

		-- Setup DAP UI
		local dapui = require("dapui")

		local function dap_ui_setup()
			dapui.setup({
				layouts = {
					{
						-- Left sidebar layout for scopes, breakpoints, etc.
						elements = {
							{ id = "scopes", size = 0.5 },
							{ id = "breakpoints", size = 0.25 },
							-- { id = "watches", size = 0.5 },
						},
						size = 60, -- Width of the sidebar
						position = "left", -- Position of the sidebar (left, right)
					},
					{
						-- Bottom layout for repl and console
						elements = {
							{ id = "repl", size = 1 },
						},
						size = 10, -- Height of the bottom window
						position = "bottom", -- Position of the bottom layout (bottom, top)
					},
				},
				floating = {
					width = 2,
					size = 50,
					max_width = 1, -- Adjust the max width of floating windows
					max_height = 5, -- Adjust the max height of floating windows
					border = "double", -- Border style: single, double, rounded, none
					mappings = {
						close = { "q", "<Esc>" }, -- Keymaps to close floating windows
					},
				},
				windows = { indent = 2 }, -- Indentation for tree-like elements
			})
		end
		dap_ui_setup()
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
		vim.keymap.set("n", "<leader>zq", ":lua require('dap').step_out()<CR>", { desc = "Step Out" })
		vim.keymap.set(
			"n",
			"<leader><F3>",
			":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>",
			{ desc = "Set breakpoint with condition" }
		)
		vim.keymap.set("n", "<leader>zx", ":lua require('dap').clear_breakpoints()<CR>", { desc = "Clear Breakpoints" })

		-- DAP Go Keymaps
		vim.keymap.set("n", "<leader>zg", ":lua require('dap-go').debug_test()<CR>", { desc = "Debug Go Code" })

		-- RESET DAP UI

		vim.keymap.set("n", "<leader>zr", function()
			dapui.close()
			dap_ui_setup()
			dapui.open()
		end, { desc = "Reset Debugger UI" })
	end,
}
