return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")

		-- Initialize with empty config
		npairs.setup({
			disable_filetype = { "TelescopePrompt", "vim" },
			enable_check_bracket_line = false,
		})

		-- Clear all default rules
		npairs.clear_rules()

		-- Add only the `{}` rule
		npairs.add_rules({
			Rule("{", "}"):with_pair(function()
				return true
			end),
		})
	end,
}
