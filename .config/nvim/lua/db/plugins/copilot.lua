-- ~/.config/nvim/lua/plugins/copilot.lua
return {
	{
		"github/copilot.vim",
		event = "VimEnter",
		config = function()
			vim.cmd([[
				imap <silent><script><expr> <Tab> copilot#Accept("\<CR>")
			]])
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		keys = {
			{ "<leader>qc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
			{ "<leader>qe", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
			{ "<leader>qr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
			{ "<leader>qf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
			{ "<leader>qo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
			{ "<leader>qd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
			{ "<leader>qt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
			{ "<leader>qm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
			{ "<leader>qm", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
		},
	},
}
