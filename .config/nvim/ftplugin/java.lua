local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason"

local jdtls_path = mason_path .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local is_arm = vim.uv.os_uname().machine == "arm64"
local config = jdtls_path .. (is_arm and "/config_mac_arm" or "/config_mac")

local function java_home(version)
	local home = vim.fn.trim(vim.fn.system("/usr/libexec/java_home -v " .. version))
	if vim.v.shell_error == 0 and home ~= "" then
		return home
	end
end

-- Project root detection
local root_dir = require("jdtls.setup").find_root({
	".git",
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
})

if not root_dir then
	return
end

-- Workspace (one per project)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_hash = string.sub(vim.fn.sha256(root_dir), 1, 12)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "-" .. workspace_hash

-- Run JDTLS on the newest JDK it requires, while project compilation can still target Java 8 below.
local jdtls_java_home = java_home("25") or java_home("21")
if not jdtls_java_home then
	vim.notify("JDTLS needs Java 25 or 21 to start", vim.log.levels.ERROR)
	return
end

local java_path = jdtls_java_home .. "/bin/java"

local cmd = {
	java_path,
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xms1g",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",

	"-javaagent:" .. jdtls_path .. "/lombok.jar",
	"-jar",
	launcher,
	"-configuration",
	config,
	"-data",
	workspace_dir,
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function telescope_builtin(name, fallback)
	return function()
		local ok, telescope = pcall(require, "telescope.builtin")
		if ok then
			telescope[name]()
			return
		end

		fallback()
	end
end

local function on_attach(_, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	map("n", "gd", telescope_builtin("lsp_definitions", vim.lsp.buf.definition), "Show LSP definitions")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("n", "gr", telescope_builtin("lsp_references", vim.lsp.buf.references), "Show LSP references")
	map("n", "gi", telescope_builtin("lsp_implementations", vim.lsp.buf.implementation), "Show LSP implementations")
	map("n", "gt", telescope_builtin("lsp_type_definitions", vim.lsp.buf.type_definition), "Show LSP type definitions")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
	map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
	map("n", "<leader>K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
	map("n", "<leader>oi", jdtls.organize_imports, "Organize imports")
end

jdtls.start_or_attach({
	cmd = cmd,
	root_dir = root_dir,
	capabilities = capabilities,
	on_attach = on_attach,

	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Users/dibyendu.biswas/Library/Java/JavaVirtualMachines/corretto-1.8.0_472/Contents/Home",
						default = true,
					},
					{
						name = "JavaSE-21",
						path = "/opt/homebrew/Cellar/openjdk@21/21.0.9/libexec/openjdk.jdk/Contents/Home",
					},
					{
						name = "JavaSE-25",
						path = "/Users/dibyendu.biswas/Library/Java/JavaVirtualMachines/openjdk-25.0.1/Contents/Home",
					},
				},
			},
		},
	},
	init_options = {
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
})
