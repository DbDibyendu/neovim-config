local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason"

local jdtls_path = mason_path .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config = jdtls_path .. "/config_mac" -- linux → config_linux

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

local cmd = {
	"java",
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xms1g",
	"--add-modules=ALL-SYSTEM",
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

jdtls.start_or_attach({
	cmd = cmd,
	root_dir = root_dir,
})
