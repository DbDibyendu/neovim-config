return {
	"fatih/vim-go",
	ft = "go",
	init = function()
		-- Disable everything except syntax — gopls handles LSP features
		vim.g.go_def_mapping_enabled = 0
		vim.g.go_doc_keywordprg_enabled = 0
		vim.g.go_fmt_autosave = 0
		vim.g.go_imports_autosave = 0
		vim.g.go_mod_fmt_autosave = 0
		vim.g.go_gopls_enabled = 0
		vim.g.go_code_completion_enabled = 0
		vim.g.go_diagnostics_enabled = 0
		vim.g.go_metalinter_enabled = {}
	end,
}
