return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			-- Enable treesitter highlighting and indent only when a parser is available
			-- (avoids disabling built-in syntax for filetypes without a parser)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local ok, parser = pcall(vim.treesitter.get_parser, ev.buf)
					if ok and parser then
						vim.treesitter.start(ev.buf)
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
