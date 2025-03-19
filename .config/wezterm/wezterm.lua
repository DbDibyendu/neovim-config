-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.font_size = 14

config.initial_rows = 50 -- Optional: Set initial window size
config.initial_cols = 180 -- Optional: Set initial window size
config.window_decorations = "RESIZE"

-- load the session manager
local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
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
		mods = "LEADER",
		key = "v",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
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
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- Color overrides for a purple theme
config.colors = {
	tab_bar = {
		background = "#0F172A", -- Deep navy blue background
		active_tab = {
			bg_color = "#2563EB", -- Bright royal blue
			fg_color = "#E0F2FE", -- Soft ice-blue text
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#1E3A8A", -- Muted deep blue
			fg_color = "#BFDBFE", -- Soft pastel blue
		},
		inactive_tab_hover = {
			bg_color = "#3B82F6", -- Vibrant azure blue
			fg_color = "#F0F9FF",
		},
		new_tab = {
			bg_color = "#172554", -- Deep midnight blue
			fg_color = "#93C5FD", -- Soft sky blue
		},
		new_tab_hover = {
			bg_color = "#60A5FA", -- Light bright blue
			fg_color = "#0F172A", -- Dark contrast
		},
	},
}

-- Align bottom tab bar visually by adding padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- ocean wave for leader
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local prefix = ""

	if window:leader_is_active() then
		prefix = utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#0F172A" } },
		{ Text = "                 " }, -- Add leading spaces for padding
		{ Text = prefix },
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- and finally, return the configuration to wezterm
return config
