-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local watch = require('awful.widget.watch')

local getfs = require("gears.filesystem")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local bling = require("bling")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

package.loaded["naughty.dbus"] = {}

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(getfs.get_configuration_dir() .. "theme/theme.lua")
beautiful.get().wallpaper = os.getenv("HOME") .. "/.local/share/bg"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
browser = "brave"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile,

    bling.layout.mstab,
    bling.layout.vertical,
    bling.layout.centered,
    -- bling.layout.horizontal,
    -- bling.layout.equalarea,
    -- bling.layout.deck,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

awful.screen.set_auto_dpi_enabled(true)

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu }
-- local menu_terminal = { "log out", function() awesome.quit() end }
local menu_logout = { "sleep", "systemctl suspend" }
local menu_reboot = { "reboot", "systemctl reboot" }
local menu_poweroff = { "poweroff", "systemctl poweroff" }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after = {
            menu_terminal,
            menu_logout,
            menu_reboot,
            menu_poweroff
        }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            menu_terminal,
        }
    })
end

local wifiicon = wibox.widget.textbox()
wifiicon.font = beautiful.iconfont .. " 11"

local ethicon = wibox.widget.textbox()
ethicon.font = beautiful.iconfont .. " 11"

local bticon = wibox.widget.textbox()
bticon.font = beautiful.iconfont .. " 11"

-- Get Bluetooth status
local function sb_bluetooth()
    awful.spawn.easy_async_with_shell("bluetoothctl show | grep Powered | awk '{print $2}'", function(is_bluetooth_on)

        if string.match(is_bluetooth_on, "yes") then
            awful.spawn.easy_async_with_shell("bluetoothctl info >> /dev/null && echo connected  || echo on ",
                function(is_connected)
                    if string.match(is_connected, "connected") then
                        awful.spawn.easy_async_with_shell("bluetoothctl <<< 'info' | grep Name | cut -d ' ' -f2-",
                            function(bluetooth_device)
                                bticon.text = '󰂱  ' .. bluetooth_device
                            end)
                    else
                        bticon.text = '󰂯 '
                    end
                end)
        end
    end)
end



-- Get Ethernet status
-- if it's not working properly you can replace en* with the full name
local function sb_ethernet()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/en*/operstate' ", function(out)
        if string.match(out, "up") then
            ethicon.text = '󰈁 '
        else
            ethicon.text = ''
        end
    end)
end

-- Get Wifi status
-- if it's not working properly you can replace wl* with the full name
local function sb_wifi()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/wl*/flags' ", function(out)
        if string.match(out, "0x1003") then
            local getstrength = [[  awk '/^\s*w/ { print  int($3 * 100 / 70) }' /proc/net/wireless   ]]
            awful.spawn.easy_async_with_shell(getstrength, function(stdout)
                local strength = tonumber(stdout) or 0
                if strength > 80 then
                    wifiicon.text = '󰤨 '
                elseif strength > 60 then
                    wifiicon.text = '󰤥 '
                elseif strength > 40 then
                    wifiicon.text = '󰤢 '
                elseif strength > 20 then
                    wifiicon.text = '󰤟 '
                else
                    wifiicon.text = '󰤯 '
                end
            end)
        else
            wifiicon.text = '󰤭'
        end
    end)
end

-- wifi/ethernet widget
local network = wibox.widget {
    wibox.widget {
        ethicon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    wibox.widget {
        wifiicon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    spacing = dpi(3),
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell('net nmtui' ..
                "; echo 'sb_ethernet()' | awesome-client; echo 'sb_wifi()' | awesome-client")
            sb_ethernet()
            sb_wifi()
        end)) }

vpnwidget = wibox.widget.textbox()
vpnwidget:set_text(" VPN: N/A ")
vpnwidgettimer = timer({ timeout = 2 })
vpnwidgettimer:connect_signal("timeout",
    function()
        status = io.popen("nmcli c show --active | grep vpn", "r")
        if status:read() == nil then
            vpnwidget:set_markup(" <span color='#FF0000'>VPN: OFF</span> ")
        else
            vpnwidget:set_markup(" <span color='#00FF00'>VPN: ON</span> ")
        end
        status:close()
    end
)
vpnwidgettimer:start()


local diskspacewidget = wibox.widget.textbox()
diskspacewidget:set_text("")
local diskspacetimer = timer({ timeout = 10 })

diskspacetimer:connect_signal("timeout", function()
    awful.spawn.easy_async_with_shell("sh -c 'df -h | grep \"/$\" | awk \"{ print \\$3 \\\"/\\\" \\$2; }\"'", function(out)
        diskspacewidget:set_markup("🖴 " .. out)
    end)
end)
diskspacetimer:start()

-- bluetooth widget.
local bluetooth = wibox.widget {
    wibox.widget {
        bticon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn('blueberry')
            sb_bluetooth()
        end))
}


local bluetooth_network_widget = wibox.widget {
    wibox.widget {
        network,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    wibox.widget {
        bluetooth,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
}


-- create battery widgets components
local orangeicon = wibox.widget.textbox(" ")
orangeicon.font = beautiful.iconfont .. " 14"

local orangetext = wibox.widget.textbox()
orangetext.font = beautiful.uifont .. " 10"

-- update icons and percentage
local function sb_orange()
    awful.spawn.easy_async_with_shell('temperature-redshift --temperature', function(stdout)
        orangetext.text = tonumber(stdout) or 0
    end)
end

-- orange widget.
local orangewidget = wibox.widget {

    wibox.widget {
        orangeicon,
        fg = beautiful.yellow,
        widget = wibox.container.background
    },
    wibox.widget {
        orangetext,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    spacing = dpi(0),
    layout = wibox.layout.fixed.horizontal,
}

local briicon = wibox.widget.textbox("󰛨 ")
briicon.font = beautiful.iconfont .. " 14"

local briperc = wibox.widget.textbox()
briperc.font = beautiful.uifont .. " 10"

----

local function sb_brightness()
    awful.spawn.easy_async_with_shell('temperature-redshift --brightness', function(stdout)
        briperc.text = tonumber(stdout) or 0
    end)
end

-- brightness widget.
local brightwidget = wibox.widget {
    wibox.widget {
        briicon,
        fg = beautiful.yellow,
        widget = wibox.container.background
    },
    wibox.widget {
        briperc,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    spacing = dpi(0),
    layout = wibox.layout.fixed.horizontal,
}


local volicon = wibox.widget.textbox()
volicon.font = beautiful.iconfont .. " 13"
local volperc = wibox.widget.textbox()
volperc.align = 'center'
volperc.valign = 'center'
volperc.font = beautiful.uifont .. " 10"

-- widget function.
local sb_volume = function()
    -- pulse, pipewire
    local getvol = [[ pamixer --get-volume ]]
    local getmute = [[ pamixer --get-mute ]]

    -- alsa
    -- Uncomment following lines for alsa, if doesn't show properly adjust '{print $5}' and '{print $6}'
    -- getvol=[[ amixer get Master | awk '$0~/%/{print $5}' | tr -d '[%]' | head -1 ]]
    -- getmute=[[ amixer get Master | awk '$0~/%/{print $6}' | tr -d '[]' | grep 'on' >/dev/null || echo true ]]

    awful.spawn.easy_async_with_shell(getvol, function(stdout)
        local vol = tonumber(stdout)
        awful.spawn.easy_async_with_shell(getmute, function(out)
            if string.match(out, "true") then
                volicon.markup = "<span foreground = '" .. beautiful.red .. "'>󰝟 </span>"
            else
                volperc.text = vol .. "%"
                -- pactl command can be used without pulseaudio running, with libpulse package. so this should work for both pipewire and pulseaudio.
                awful.spawn.easy_async_with_shell(
                    'LANG=C pactl list sinks | grep "Active Port" | grep headphone > /dev/null && echo headphones',
                    function(out)
                        if string.match(out, "headphones") then
                            volicon.text = '󰋋 '
                        else
                            if vol >= 65 then
                                volicon.text = ' '
                            elseif vol >= 10 then
                                volicon.text = ' '
                            else
                                volicon.text = ' '
                            end
                        end
                    end)
            end
        end)
    end)
end


-- run once on startup
sb_volume()

-- the volume widget
local volumewidget = wibox.widget {
    wibox.widget {
        volicon,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    wibox.widget {
        volperc,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    spacing = dpi(0),
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell('pavucontrol' .. "; echo 'sb_volume()' | awesome-client")
        end),
        awful.button({}, 3, function()
            awful.spawn.with_shell('pamixer -t')
            sb_volume()
        end),
        awful.button({}, 4, function()
            awful.spawn.with_shell('pamixer --allow-boost -i 3')
            sb_volume()
        end),
        awful.button({}, 5, function()
            awful.spawn.with_shell('pamixer --allow-boost -d 3')
            sb_volume()
        end))
}


local baticon = wibox.widget.textbox()
baticon.font = beautiful.iconfont .. " 12"

local batperc = wibox.widget.textbox()
batperc.font = beautiful.uifont .. " 10"

local battery = wibox.widget {
    wibox.widget {
        baticon,
        fg = beautiful.green,
        widget = wibox.container.background
    },
    wibox.widget {
        batperc,
        fg = beautiful.green,
        widget = wibox.container.background
    },
    spacing = dpi(0),
    layout = wibox.layout.fixed.horizontal,
}

function sb_battery()
    --  if battery widget is not visible or correctly showing replace BA* in a scripts below with (BAT1, BAT0 whatever you have.)
    awful.spawn.easy_async_with_shell('cat /sys/class/power_supply/BA*/capacity', function(stdout)
        local battery = tonumber(stdout)
        awful.spawn.easy_async_with_shell('cat /sys/class/power_supply/BA*/status', function(out)
            batperc.text = tonumber(battery) .. "%"
            if string.match(out, "Charging") then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󰂄 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 10 then
                baticon.markup = "<span foreground = '" .. beautiful.red .. "'>󰂃 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.red .. "'>" .. tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 20 then
                baticon.markup = "<span foreground = '" .. beautiful.red .. "'>󰁺 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.red .. "'>" .. tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 30 then
                baticon.markup = "<span foreground = '" .. beautiful.yellow .. "'>󰁼 </span>"
                batperc.markup = "<span foreground = '" ..
                    beautiful.yellow .. "'>" .. tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 40 then
                baticon.markup = "<span foreground = '" .. beautiful.yellow .. "'>󰁽 </span>"
                batperc.markup = "<span foreground = '" ..
                    beautiful.yellow .. "'>" .. tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 50 then
                baticon.markup = "<span foreground = '" .. beautiful.yellow .. "'>󰁽 </span>"
                batperc.markup = "<span foreground = '" ..
                    beautiful.yellow .. "'>" .. tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 60 then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󰁿 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 70 then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󰂀 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 80 then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󰂁 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 90 then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󰂂 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            elseif battery <= 100 then
                baticon.markup = "<span foreground = '" .. beautiful.green .. "'>󱟢 </span>"
                batperc.markup = "<span foreground = '" .. beautiful.green .. "'>" ..
                    tonumber(battery) .. "%" .. "</span>"
            end
        end)
    end)
end

sb_battery()

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout.font = beautiful.uifont .. " 10"

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%a %b %d, %H:%M:%S", 1)
mytextclock.font = beautiful.uifont .. " 10"

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local sep_widget = wibox.widget {
    text = "  ",
    widget = wibox.widget.textbox
}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", height = dpi(20), screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            sep_widget,
            sep_widget,
            mytextclock,
            sep_widget,
            sep_widget,
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
            sep_widget,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,

            sep_widget,
            wibox.widget.systray(),

            vpnwidget,

            sep_widget,
            orangewidget,

            sep_widget,
            brightwidget,

            sep_widget,
            bluetooth_network_widget,

            sep_widget,
            diskspacewidget,

            sep_widget,
            volumewidget,

            sep_widget,
            battery,
            -- s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
-- awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
--           {description="show help", group="awesome"}),
-- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
--           {description = "view previous", group = "tag"}),
-- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
--           {description = "view next", group = "tag"}),
-- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
--           {description = "go back", group = "tag"}),

    awful.key({ modkey }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, ",", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey }, ".", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),

    -- awful.key({ modkey           }, "Tab", awful.tag.viewtoggle,
    --           {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey }, "t", function() awful.spawn(terminal .. " -e tmux new-session -A -s main") end,
        { description = "open a terminal with tmux", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "t", function() awful.spawn("rofi-tmux") end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Shift", "Control" }, "t", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "o", function() awful.spawn(terminal .. " -e org_tmux_session") end,
        { description = "orgmode refile.org", group = "launcher" }),
    awful.key({ modkey }, "w", function() awful.spawn(browser) end,
        { description = "open a browser", group = "launcher" }),
    awful.key({ modkey, }, "Print", function() awful.spawn("copy-selected-area") end,
        { description = "copy screen", group = "launcher" }),
    awful.key({ modkey, }, "XF86Calculator", function() awful.spawn("speedcrunch") end,
        { description = "copy screen", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "Print", function() awful.spawn("maimpick-rofi") end,
        { description = "copy screen selection", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "w", function() awful.spawn(terminal .. " -e nmtui") end,
        { description = "nmtui", group = "launcher" }),
    awful.key({ modkey, }, "e", function() awful.spawn("telegram-desktop") end,
        { description = "telegram", group = "launcher" }),
    awful.key({ modkey, }, "m", function() awful.spawn(terminal .. " -e ncmpcpp") end,
        { description = "ncmpcpp", group = "launcher" }),
    awful.key({ modkey, }, "n", function() awful.spawn("mpc next") end,
        { description = "next song", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "n", function() awful.spawn("mpc prev") end,
        { description = "prev song", group = "launcher" }),
    awful.key({ modkey, "Control" }, "n", function() awful.spawn("mpc seek +00:00:05") end,
        { description = "play song +5sec", group = "launcher" }),
    awful.key({ modkey, "Control", "Shift" }, "n", function() awful.spawn("mpc seek -00:00:05") end,
        { description = "play song -5sec", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "e", function() awful.spawn("thunderbird") end,
        { description = "thunderbird", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "b", function() awful.spawn("rofi-books") end,
        { description = "search for books", group = "launcher" }),
    awful.key({ modkey, }, "i", function() awful.spawn("rofi-innop") end,
        { description = "search in innop folder", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "r", function() awful.spawn(terminal .. " -e htop") end,
        { description = "htop", group = "launcher" }),
    awful.key({ modkey, }, "p",
        function() awful.spawn("rofi -terminal alacritty -show run -icon-theme \"Papirus\" -show-icons") end,
        { description = "program launcher", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "p",
        function() awful.spawn("rofi -terminal alacritty -show emoji -icon-theme \"Papirus\" -show-icons") end,
        { description = "emoji picker", group = "launcher" }),
    awful.key({ modkey, "Control" }, "p", function() awful.spawn("systemctl --user restart pipewire") end,
        { description = "emoji picker", group = "launcher" }),

    awful.key({ modkey, }, "-", function()
            awful.spawn("pamixer --allow-boost -d 5")
            sb_volume()
        end,
        { description = "decrease volume", group = "launcher" }),

    awful.key({ modkey, }, "=", function()
            awful.spawn("pamixer --allow-boost -i 5")
            sb_volume()
        end,
        { description = "increase volume", group = "launcher" }),
    awful.key({ modkey, }, "XF86AudioRaiseVolume", function() awful.spawn("pamixer --allow-boost -i 5") end,
        { description = "increase volume", group = "launcher" }),
    awful.key({ modkey, }, "XF86AudioLowerVolume", function() awful.spawn("pamixer --allow-boost -d 5") end,
        { description = "decrease volume", group = "launcher" }),
    awful.key({ modkey, }, "XF86AudioMute", function() awful.spawn("pamixer -t") end,
        { description = "decrease volume", group = "launcher" }),
    awful.key({ modkey, }, "BackSpace", function() awful.spawn("powermenu") end,
        { description = "show power menu", group = "launcher" }),
    awful.key({ modkey, }, "F12", function() awful.spawn("showcam") end,
        { description = "show web cam if any", group = "launcher" }),



    awful.key({ modkey, "Control" }, "-", function()
            awful.spawn("temperature-redshift --dec-temp")
            sb_orange()
        end,
        { description = "decrease light temperature", group = "launcher" }),
    awful.key({ modkey, "Control" }, "=", function()
            awful.spawn("temperature-redshift --inc-temp")
            sb_orange()
        end,
        { description = "increase light temperature", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "=", function()
            awful.spawn("temperature-redshift --inc-bright")
            sb_brightness()
        end,
        { description = "increase light temperature", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "-", function()
            awful.spawn("temperature-redshift --dec-bright")
            sb_brightness()
        end,
        { description = "decrease light temperature", group = "launcher" }),
    awful.key({ modkey, }, "XF86MonBrightnessUp", function()
            awful.spawn("temperature-redshift --inc-bright")
            sb_brightness()
        end,
        { description = "increase light temperature", group = "launcher" }),
    awful.key({ modkey, }, "XF86MonBrightnessDown", function()
            awful.spawn("temperature-redshift --dec-bright")
            sb_brightness()
        end,
        { description = "decrease light temperature", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "Escape", function() awful.spawn("launch-polybar") end,
        { description = "restart polybar", group = "launcher" }),
    awful.key({ modkey, }, "b", function() awful.spawn("polybar-toggle") end,
        { description = "toggle polybar", group = "launcher" }),
    awful.key({ modkey, "Control", "Shift" }, "c", function() awful.spawn("bluetooth-connect") end,
        { description = "reconnect to available devices", group = "launcher" }),
    awful.key({ modkey, "Control" }, "b", function() awful.spawn("blueberry") end,
        { description = "blueberry", group = "launcher" }),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "o", function() awful.layout.inc(1) end,
        { description = "select previous", group = "layout" })
-- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--           {description = "increase the number of master clients", group = "layout"}),
-- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--           {description = "decrease the number of master clients", group = "layout"}),
-- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--           {description = "increase the number of columns", group = "layout"}),
-- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--           {description = "decrease the number of columns", group = "layout"}),

-- awful.key({ modkey, "Control" }, "n",
--           function ()
--               local c = awful.client.restore()
--               -- Focus restored client
--               if c then
--                 c:emit_signal(
--                     "request::activate", "key.unminimize", {raise = true}
--                 )
--               end
--           end,
--           {description = "restore minimized", group = "client"}),

)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "c", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "c",
        function(c)
            if c.pid then
                awful.spawn("kill -9 " .. c.pid)
            end
        end
    ),
    awful.key({ modkey }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, "Shift" }, ".", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, "Shift" }, ",", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" })

-- awful.key({ modkey           }, "t",      function (c) c.ontop = not c.ontop            end,
--           {description = "toggle keep on top", group = "client"})

-- awful.key({ modkey           }, "n",
--     function (c)
--         -- The client currently has the input focus, so it cannot be
--         -- minimized, since minimized clients can't have the focus.
--         c.minimized = true
--     end ,
--     {description = "minimize", group = "client"}),

-- awful.key({ modkey           }, "m",
--     function (c)
--         c.maximized = not c.maximized
--         c:raise()
--     end ,
--     {description = "(un)maximize", group = "client"}),

-- awful.key({ modkey, "Control" }, "m",
--     function (c)
--         c.maximized_vertical = not c.maximized_vertical
--         c:raise()
--     end ,
--     {description = "(un)maximize vertically", group = "client"}),

-- awful.key({ modkey, "Shift"   }, "m",
--     function (c)
--         c.maximized_horizontal = not c.maximized_horizontal
--         c:raise()
--     end ,
--     {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).


awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
                "speedcrunch",
            },
            class = {
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "dialog" }
        },
        properties = { titlebars_enabled = true }
    },

    {
        rule_any = { type = { "normal" }
        },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {     -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- bling.module.flash_focus.enable()


tag.connect_signal("request::screen", function(t)
    for s in screen do
        if s ~= t.screen and
            s.geometry.x == t.screen.geometry.x and
            s.geometry.y == t.screen.geometry.y and
            s.geometry.width == t.screen.geometry.width and
            s.geometry.height == t.screen.geometry.height then
            local t2 = awful.tag.find_by_name(s, t.name)
            if t2 then
                t:swap(t2)
            else
                t.screen = s
            end
            return
        end
    end
end)


watch('sh -c', 3, function()
    sb_wifi()      -- update wifi status
    sb_ethernet()  -- update ethernet status
    sb_bluetooth() -- update bluetooth status
end)

watch('sh -c', 60, function()
    sb_battery()
    sb_brightness()
    sb_orange()
    sb_volume()
end)

screen.connect_signal("arrange", function(s)
    local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if (max or only_one) and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
