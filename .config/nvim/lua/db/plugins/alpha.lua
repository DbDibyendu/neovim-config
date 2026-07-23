return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = {
		"nhattVim/alpha-ascii.nvim",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local title = {
			type = "text",
			val = "NEOVIM",
			opts = {
				position = "center",
				hl = "AlphaTitle",
			},
		}

		dashboard.section.buttons.val = {
			dashboard.button("ff", "  Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("fr", "  Recent files", "<cmd>Telescope oldfiles cwd_only=true<CR>"),
		}
		dashboard.section.footer.val = {}
		dashboard.config.layout = {
			{ type = "padding", val = 4 },
			dashboard.section.header,
			{ type = "padding", val = 1 },
			title,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
		}
		dashboard.config.opts.noautocmd = true

		vim.api.nvim_set_hl(0, "AlphaNormal", { bg = "#071426" })
		vim.api.nvim_set_hl(0, "AlphaTitle", { fg = "#bfdbfe", bg = "#071426", bold = true })
		vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#93c5fd", bg = "#071426", bold = true })
		vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#67e8f9", bg = "#071426", bold = true })

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButton"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt_local.winhighlight = table.concat({
					"Normal:AlphaNormal",
					"NormalNC:AlphaNormal",
					"EndOfBuffer:AlphaNormal",
					"SignColumn:AlphaNormal",
				}, ",")
			end,
		})

		require("alpha_ascii").setup({
			header = "cute_girl",
			use_default = false,
			user_path = vim.fn.stdpath("config") .. "/ascii",
		})

		alpha.setup(dashboard.config)
	end,
}
