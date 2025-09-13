-- Pull in the wezterm API
local wezterm = require("wezterm")

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
--
-- config.color_scheme = "Dracula"
config.font_size = 14
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })

config.initial_rows = 100 -- Optional: Set initial window size
config.initial_cols = 180 -- Optional: Set initial window size
config.window_decorations = "RESIZE"
--
-- load the session manager
local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
	wezterm.log_info("Session saved!")
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)

wezterm.on("gui-startup", function(window, pane)
	wezterm.log_info("GUI startup event triggered")
	session_manager.restore_state(window)
end)

-- tmux
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
	-- Leader + , for renaming the tab
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename Tab:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "s", mods = "LEADER", action = wezterm.action({ EmitEvent = "save_session" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ EmitEvent = "load_session" }) },
	{ key = "r", mods = "LEADER", action = wezterm.action({ EmitEvent = "restore_session" }) },
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			win:perform_action(
				wezterm.action.SplitPane({
					direction = "Right", -- creates a vertical split (side-by-side)
					size = { Percent = 40 }, -- or use PixelWidth = <value> if you want exact pixel control
				}),
				pane
			)
		end),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = "LEADER",
		key = "z",
		action = wezterm.action.TogglePaneZoomState,
	},
}

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

-- Color overrides for a purple theme
config.window_padding = {
	left = 0,
	right = 0,
	top = 30,
	bottom = 00,
}

-- Define custom tab names
local tab_names = {
	"config",
	"web",
	"web-lr",
	"personal",
	"mock",
	"binder",
}

-- Function to get custom tab title with index
local function tab_title(tab)
	local index = tab.tab_index
	local name = tab_names[index + 1] or tab.title -- Default name for other tabs
	return tostring(index) .. ":" .. name
end

wezterm.on("format-tab-title", function(tab)
	return {
		{ Text = " " .. tab_title(tab) .. " " },
	}
end)

-- Custom tab setup
--
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thin,
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
	},
	sections = {
		tabline_a = {},
		tabline_b = { "  STOP  " },
		tabline_c = {},
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime" },
		tabline_z = {},
	},
})

config.text_background_opacity = 1.0 -- Optional: keep text fully opaque

return config
