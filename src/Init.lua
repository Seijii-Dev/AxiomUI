local AxiomUI = {
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,

	TransparencyValue = 0.15,

	UIScale = 1,

	ConfigManager = nil,
	Version = "0.0.0",

	Services = require("./utils/services/Init"),

	OnThemeChangeFunction = nil,

	cloneref = nil,
	UIScaleObj = nil,

	CreateWindow = nil,

	CurrentInput = nil,
}

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

AxiomUI.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

function AxiomUI.GenerateGUID()
	return HttpService:GenerateGUID(false)
end

local CurInput = AxiomUI.GenerateGUID()

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	--[[if GameProcessed then
		return
	end]]

	task.defer(function()
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			if AxiomUI.CurrentInput and AxiomUI.CurrentInput ~= CurInput then
				return
			end

			AxiomUI.CurrentInput = CurInput
			--print(CurInput)
			--AxiomUI.InputStartedOnUI = false
		end
	end)
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessed)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		if AxiomUI.CurrentInput and AxiomUI.CurrentInput ~= CurInput then
			return
		end

		AxiomUI.CurrentInput = nil
	end
end)

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	AxiomUI.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local Creator = AxiomUI.Creator

local New = Creator.New

--local Tween = Creator.Tween
--local ServicesModule = AxiomUI.Services

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = AxiomUI.UIScale,
})

AxiomUI.UIScaleObj = UIScaleObj

AxiomUI.ScreenGui = New("ScreenGui", {
	Name = "AxiomUI",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = -99999,
}, {

	New("Folder", {
		Name = "Window",
	}),
	-- New("Folder", {
	--     Name = "Notifications"
	-- }),
	-- New("Folder", {
	--     Name = "Dropdowns"
	-- }),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})

AxiomUI.NotificationGui = New("ScreenGui", {
	Name = "AxiomUI/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
AxiomUI.DropdownGui = New("ScreenGui", {
	Name = "AxiomUI/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
AxiomUI.TooltipGui = New("ScreenGui", {
	Name = "AxiomUI/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(AxiomUI.ScreenGui)
ProtectGui(AxiomUI.NotificationGui)
ProtectGui(AxiomUI.DropdownGui)
ProtectGui(AxiomUI.TooltipGui)

Creator.Init(AxiomUI)

function AxiomUI:SetParent(parent)
	if AxiomUI.ScreenGui then
		AxiomUI.ScreenGui.Parent = parent
	end
	if AxiomUI.NotificationGui then
		AxiomUI.NotificationGui.Parent = parent
	end
	if AxiomUI.DropdownGui then
		AxiomUI.DropdownGui.Parent = parent
	end
	if AxiomUI.TooltipGui then
		AxiomUI.TooltipGui.Parent = parent
	end
end
math.clamp(AxiomUI.TransparencyValue, 0, 1)

local Holder = AxiomUI.NotificationModule.Init(AxiomUI.NotificationGui)

function AxiomUI:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = AxiomUI.Window
	--Config.AxiomUI = AxiomUI
	return AxiomUI.NotificationModule.New(Config)
end

function AxiomUI:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function AxiomUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function AxiomUI:OnThemeChange(func)
	AxiomUI.OnThemeChangeFunction = func
end

function AxiomUI:AddTheme(LTheme)
	AxiomUI.Themes[LTheme.Name] = LTheme
	return LTheme
end

function AxiomUI:SetTheme(Value)
	if AxiomUI.Themes[Value] then
		AxiomUI.Theme = AxiomUI.Themes[Value]
		Creator.SetTheme(AxiomUI.Themes[Value])

		if AxiomUI.OnThemeChangeFunction then
			AxiomUI.OnThemeChangeFunction(Value)
		end

		return AxiomUI.Themes[Value]
	end
	return nil
end

function AxiomUI:GetThemes()
	return AxiomUI.Themes
end
function AxiomUI:GetCurrentTheme()
	return AxiomUI.Theme.Name
end
function AxiomUI:GetTransparency()
	return AxiomUI.Transparent or false
end
function AxiomUI:GetWindowSize()
	return AxiomUI.Window.UIElements.Main.Size
end
function AxiomUI:Localization(LocalizationConfig)
	return AxiomUI.LocalizationModule:New(LocalizationConfig, Creator)
end

function AxiomUI:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function AxiomUI:ToggleAcrylic(Value)
	if AxiomUI.Window and AxiomUI.Window.AcrylicPaint and AxiomUI.Window.AcrylicPaint.Model then
		AxiomUI.Window.Acrylic = Value
		AxiomUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end

function AxiomUI:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)

			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end

			local transparency = stop.Transparency or 0

			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
	end

	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}

	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end

	return gradientData
end

function AxiomUI:Popup(PopupConfig)
	PopupConfig.AxiomUI = AxiomUI
	return require("./components/popup/Init").new(PopupConfig, AxiomUI.ScreenGui.Popups)
end

AxiomUI.Themes = require("./themes/Init")(AxiomUI, Creator)

Creator.Themes = AxiomUI.Themes

AxiomUI:SetTheme("Dark")
AxiomUI:SetLanguage(Creator.Language)

function AxiomUI:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		if not isfolder("AxiomUI") then
			makefolder("AxiomUI")
		end
		if Config.Folder then
			makefolder(Config.Folder)
		else
			makefolder(Config.Title)
		end
	end

	Config.AxiomUI = AxiomUI
	Config.Window = AxiomUI.Window
	Config.Parent = AxiomUI.ScreenGui.Window

	if AxiomUI.Window then
		warn("You cannot create more than one window")
		return
	end

	local CanLoadWindow = true

	local Theme = AxiomUI.Themes[Config.Theme or "Dark"]

	--AxiomUI.Theme = Theme
	Creator.SetTheme(Theme)

	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end

	local Filename = hwid()

	if Config.KeySystem then
		CanLoadWindow = false

		local function loadKeysystem()
			KeySystem.new(Config, Filename, function(c)
				CanLoadWindow = c
			end)
		end

		local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"

		if Config.KeySystem.KeyValidator then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isValid = Config.KeySystem.KeyValidator(savedKey)

				if isValid then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		elseif not Config.KeySystem.API then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isKey = (type(Config.KeySystem.Key) == "table") and table.find(Config.KeySystem.Key, savedKey)
					or tostring(Config.KeySystem.Key) == tostring(savedKey)

				if isKey then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		else
			if isfile(keyPath) then
				local fileKey = readfile(keyPath)
				local isSuccess = false

				for _, i in next, Config.KeySystem.API do
					local serviceData = AxiomUI.Services[i.Type]
					if serviceData then
						local args = {}
						for _, argName in next, serviceData.Args do
							table.insert(args, i[argName])
						end

						local service = serviceData.New(table.unpack(args))
						local success = service.Verify(fileKey)
						if success then
							isSuccess = true
							break
						end
					end
				end

				CanLoadWindow = isSuccess
				if not isSuccess then
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		end

		repeat
			task.wait()
		until CanLoadWindow
	end

	local Window = CreateWindow(Config)

	AxiomUI.Transparent = Config.Transparent
	AxiomUI.Window = Window

	if Config.Acrylic then
		Acrylic.init()
	end

	-- function Window:ToggleTransparency(Value)
	--     AxiomUI.Transparent = Value
	--     AxiomUI.Window.Transparent = Value

	--     Window.UIElements.Main.Background.BackgroundTransparency = Value and AxiomUI.TransparencyValue or 0
	--     Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and AxiomUI.TransparencyValue or 0
	--     Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
	--         NumberSequenceKeypoint.new(0, 1),
	--         NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
	--     }
	-- end

	return Window
end

return AxiomUI
