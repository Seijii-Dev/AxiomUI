-- AxiomUI Safe UI Demo
-- UI showcase only: no ESP, targeting, camera control, Drawing API, or game automation.

local AxiomUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Seijii-Dev/AxiomUI/main/dist/main.lua"
))()

local State = {
    Notifications = true,
    CompactMode = false,
    Accent = "Violet",
    Scale = 85,
    Clicks = 0,
}

local Window = AxiomUI:CreateWindow({
    Title = "AxiomUI",
    Author = "Safe UI Showcase",
    Icon = "sparkles",
    Folder = "AxiomUISafeDemo",
    Theme = "Axiom",
    Size = UDim2.fromOffset(560, 500),
    MinSize = Vector2.new(420, 360),
    MaxSize = Vector2.new(900, 650),
    SideBarWidth = 190,
    Topbar = {
        Height = 58,
        ButtonsType = "Default",
    },
})

local Overview = Window:Tab({
    Title = "Overview",
    Icon = "layout-dashboard",
})

Overview:Section({
    Title = "AxiomUI visual refresh",
    TextSize = 16,
})

Overview:Paragraph({
    Title = "Safe interactive preview",
    Desc = "Use this script to test the redesigned window, navigation, spacing, controls, and notifications on mobile.",
    Icon = "sparkles",
})

Overview:Button({
    Title = "Show notification",
    Desc = "Test the refreshed notification component.",
    Icon = "bell",
    Callback = function()
        State.Clicks = State.Clicks + 1
        AxiomUI:Notify({
            Title = "AxiomUI",
            Content = "The redesigned notification is working.",
            Icon = "check",
            Duration = 3,
        })
    end,
})

Overview:Button({
    Title = "Count test clicks",
    Desc = "A harmless callback test: click count is " .. State.Clicks,
    Icon = "mouse-pointer-click",
    Callback = function()
        State.Clicks = State.Clicks + 1
        AxiomUI:Notify({
            Title = "Button callback",
            Content = "This demo has received " .. State.Clicks .. " clicks.",
            Icon = "mouse-pointer-click",
            Duration = 2,
        })
    end,
})

local Controls = Window:Tab({
    Title = "Controls",
    Icon = "sliders-horizontal",
})

Controls:Section({
    Title = "Interactive controls",
    TextSize = 16,
})

Controls:Toggle({
    Title = "Notifications",
    Desc = "Enable notification preview callbacks.",
    Value = State.Notifications,
    Callback = function(value)
        State.Notifications = value
    end,
})

Controls:Toggle({
    Title = "Compact mode",
    Desc = "Demo a layout preference toggle.",
    Value = State.CompactMode,
    Callback = function(value)
        State.CompactMode = value
        AxiomUI:Notify({
            Title = "Layout preference",
            Content = value and "Compact mode enabled." or "Comfortable mode enabled.",
            Icon = "layout-grid",
            Duration = 2,
        })
    end,
})

Controls:Slider({
    Title = "Interface scale",
    Desc = "Try different sizes for mobile readability.",
    Value = {
        Min = 70,
        Max = 110,
        Default = State.Scale,
    },
    Step = 5,
    IsTooltip = true,
    Callback = function(value)
        State.Scale = value
        AxiomUI.UIScale = value / 100
        if AxiomUI.UIScaleObj then
            AxiomUI.UIScaleObj.Scale = AxiomUI.UIScale
        end
    end,
})

Controls:Dropdown({
    Title = "Accent preview",
    Desc = "Select a palette label for the demo.",
    Values = { "Violet", "Cyan", "Emerald", "Amber" },
    Value = State.Accent,
    Callback = function(value)
        State.Accent = value
        AxiomUI:Notify({
            Title = "Accent selected",
            Content = "Preview selection: " .. tostring(value),
            Icon = "palette",
            Duration = 2,
        })
    end,
})

local Themes = Window:Tab({
    Title = "Themes",
    Icon = "palette",
})

Themes:Section({
    Title = "Theme switcher",
    TextSize = 16,
})

Themes:Paragraph({
    Title = "Try the visual system",
    Desc = "Axiom is the redesigned default. The other themes remain available for comparison.",
    Icon = "wand-sparkles",
})

Themes:Dropdown({
    Title = "Theme",
    Values = { "Axiom", "Dark", "Light", "Rose", "Plant", "Indigo", "Violet", "Emerald", "Midnight" },
    Value = "Axiom",
    Callback = function(value)
        AxiomUI:SetTheme(value)
        AxiomUI:Notify({
            Title = "Theme applied",
            Content = tostring(value) .. " is now active.",
            Icon = "paintbrush",
            Duration = 3,
        })
    end,
})

Themes:Button({
    Title = "Reset to Axiom",
    Desc = "Return to the redesigned default palette.",
    Icon = "rotate-ccw",
    Callback = function()
        AxiomUI:SetTheme("Axiom")
        AxiomUI:Notify({
            Title = "Axiom theme restored",
            Content = "The refreshed default visual system is active.",
            Icon = "check",
            Duration = 3,
        })
    end,
})

AxiomUI:Notify({
    Title = "AxiomUI demo loaded",
    Content = "Safe UI-only showcase ready for testing.",
    Icon = "sparkles",
    Duration = 4,
})

print("[AxiomUI] Safe UI demo loaded successfully")
