-- #######################################################################################
-- Jan's Hyprland config
-- Migrated from hyprlang (hyprland.conf) to Lua for Hyprland 0.57+
-- #######################################################################################

-------------------
---- MY PROGRAMS ----
-------------------

local mainMod     = "SUPER"
local shiftMod    = "SHIFT"   -- was undefined as $shiftMod in the old config
local terminal    = "kitty"
local fileManager = terminal .. " ranger"
local menu        = "rofi -show drun"

------------------
---- MONITORS ----
------------------
-- (formerly hyprland.conf.d/en14.conf)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1.0,
})

--------------------
---- AUTOSTART -----
--------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("hypridle & swaync")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("python3 ~/src/dynwalls/dynwalls update")
    hl.exec_cmd("waybar -c ~/.config/waybar/hyprland_config.jsonc & nm-applet --indicator & blueman-applet & gammastep-indicator -l 48.1:11.6")
    -- hl.exec_cmd("clipboard_monitor.sh") -- TODO: this breaks paste in slack
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

----------------------
---- LOOK AND FEEL ----
----------------------
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout        = "master",
        allow_tearing = false,
    },

    decoration = {
        rounding = 0,
        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
        -- shadow = {
        --     enabled      = true,
        --     range        = 4,
        --     render_power = 3,
        --     color        = "rgba(1a1a1aee)",
        -- },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true, -- you probably want this
    },

    master = {
        new_on_top  = false,
        orientation = "left",
    },

    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "eu",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        repeat_delay = 180,
        repeat_rate  = 60,

        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
        },
    },
})

----------------------------
---- WINDOWS AND RULES -----
----------------------------
-- (formerly: windowrule = match:title ()(Apple Music), tile on)
hl.window_rule({
    match = { title = "()(Apple Music)" },
    tile  = true,
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("hyprctl keyword general:layout dwindle"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("hyprctl keyword general:layout master"))
hl.bind(mainMod .. " + F3", hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())        -- changegroupactive, f

-- Release bind (formerly bindl)
hl.bind(mainMod .. " + A",
        hl.dsp.exec_cmd('bash -c "sleep 1 && ydotool click 0xC0 && sleep 0.1 && ydotool mousemove -x 90 -y 20 && sleep 0.05 && ydotool click 0xC0"'),
        { release = true })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("wireplumber_audio_switcher.py Sinks"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())                     -- killactive
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + backspace", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("rofimoji --action copy"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.float({ action = "toggle" })) -- togglefloating
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("ffchooser.py"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("obsidian-vault-chooser.py"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + H/L/K/J
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move windows themselves (formerly movewindoworgroup)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down",  group_aware = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window silently with mainMod + SHIFT + [0-9] (formerly movetoworkspacesilent)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + CTRL + 1",         hl.dsp.focus({ workspace = 11 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 1", hl.dsp.window.move({ workspace = 11, follow = false }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move current workspace to the monitor to the left/right
-- (formerly movecurrentworkspacetomonitor, l/r)
local function move_workspace_to_monitor(direction)
    local cur = hl.get_active_monitor()
    if not cur then return end
    local best
    for _, m in ipairs(hl.get_monitors()) do
        if m.id ~= cur.id then
            local dx = m.x - cur.x
            if (direction == "left" and dx < 0) or (direction == "right" and dx > 0) then
                if not best or math.abs(dx) < math.abs(best.x - cur.x) then
                    best = m
                end
            end
        end
    end
    if best then
        hl.dispatch(hl.dsp.workspace.move({ monitor = best.name }))
    end
end

hl.bind(mainMod .. " + Space",         function() move_workspace_to_monitor("left")  end)
hl.bind(mainMod .. " + SHIFT + Space", function() move_workspace_to_monitor("right") end)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging (formerly bindm)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keyboard backlight
hl.bind("xf86KbdBrightnessUp",   hl.dsp.exec_cmd("light -A 5"))
hl.bind("xf86KbdBrightnessDown", hl.dsp.exec_cmd("light -U 5"))

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- -n 1"))

-- Volume and Media Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"))

-- Screenshot a window
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/screenshots"))
-- Screenshot a monitor
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/screenshots"))
-- Screenshot a region
hl.bind(shiftMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/screenshots"))
