return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-dap.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		local telescope = require("telescope")

		-- or create your custom action
		local actions = require("telescope.actions")
		require("telescope").load_extension("dap")
		telescope.setup({
			defaults = {
				path_display = function(_, path)
					local parts = vim.split(path, "/")
					local depth = 6 -- Maximum depth to display
					if #parts > depth then
						return table.concat(parts, "/", #parts - depth + 1)
					end
					return path
				end,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist,
					},
				},
				layout_strategy = "horizontal", -- or "vertical"
				layout_config = {
					horizontal = {
						width = 0.99, -- Adjust this to increase the width (90% of the editor width)
						preview_width = 0.4, -- Adjust the preview area width (50% of total width)
					},
					vertical = {
						width = 0.6, -- Adjust this for vertical layout (80% of editor width)
						height = 0.9, -- Adjust the height (90% of editor height)
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob=!**/.git/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						-- "--glob=!**/build/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/package-lock.json",
					},
				},
				live_grep = {
					hidden = true,
					additional_args = function()
						return {
							"--hidden",
							"--glob=!**/.git/*",
							"--glob=!**/.idea/*",
							"--glob=!**/.vscode/*",
							-- "--glob=!**/build/*",
							"--glob=!**/dist/*",
							"--glob=!**/yarn.lock",
							"--glob=!**/package-lock.json",
							"--glob=!**/*test.tsx",
							"--glob=!**/*test.go",
							"--glob=!**/english.ts",
						}
					end,
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		-- Set up Telescope for project-specific recent files
		keymap.set("n", "<leader>fr", function()
			require("telescope.builtin").oldfiles({
				cwd_only = true, -- Show only files from the current working directory
				prompt_title = "Recent Files (Current Project)",
			})
		end, { desc = "Fuzzy find recent files in the current project" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		vim.keymap.set("n", "<leader>fd", function()
			require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
		end, { desc = "Find files (current buffer dir)" })
	end,
}
