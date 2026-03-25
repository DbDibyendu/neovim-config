local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason"

local jdtls_path = mason_path .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local is_arm = vim.uv.os_uname().machine == "arm64"
local config = jdtls_path .. (is_arm and "/config_mac_arm" or "/config_mac")

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
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

-- Use Java 21 explicitly (jdtls requires Java 17+, default java is Java 8)
local java_path = vim.fn.trim(vim.fn.system("/usr/libexec/java_home -v 21")) .. "/bin/java"

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

	"-jar",
	launcher,
	"-configuration",
	config,
	"-data",
	workspace_dir,
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

jdtls.start_or_attach({
	cmd = cmd,
	root_dir = root_dir,
	capabilities = capabilities,
	init_options = {
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
})
