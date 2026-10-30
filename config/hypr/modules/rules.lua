-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

-- Floating rules
hl.window_rule({
    name = "floating-pavucontrol",
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
})

hl.window_rule({
    name = "floating-nmeditor",
    match = { class = "nm-connection-editor" },
    float = true,
})

hl.window_rule({
    name = "floating-fileroller",
    match = { class = "org.gnome.FileRoller" },
    float = true,
})

hl.window_rule({
    name = "floating-waypaper",
    match = { class = "waypaper" },
    float = true,
})

-- Windows and workspaces
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drags
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})


