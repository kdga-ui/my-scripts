--[[
an non obfuscated script by
____________________________________
888           888                   
888           888                   
888           888                   
888  888  .d88888  .d88b.   8888b.  
888 .88P d88" 888 d88P"88b     "88b 
888888K  888  888 888  888 .d888888 
888 "88b Y88b 888 Y88b 888 888  888 
888  888  "Y88888  "Y88888 "Y888888 
                       888          
                  Y8b d88P          
                   "Y88P"           
____________________________________
usually i obfuscate my stuff but idont reallt care if u use this if u can even figure out the usage lmao
--]]
if getgenv().NotifyToast then return end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
    SLIDE_IN_TIME = 0.4,
    SLIDE_OUT_TIME = 0.05,
    SCALE_TIME = 0.11,
    SCALE_DOWN = 0.96,
    START_Y = -1,
    SHOW_Y = 59,
    DEFAULT_DURATION = 2,
    BACKGROUND_COLOR = Color3.fromHex("#23262C"),
    TEXT_COLOR = Color3.fromRGB(247,247,248),
    TOAST_HEIGHT = 77,
    SMALL_HEIGHT = 55,
    WIDTH_OFFSET = -24,
    TITLE_SIZE = 20,
    SUBTITLE_SIZE = 15,
    ICON_SIZE = 42,
    SWIPE_THRESHOLD = 40
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToastNotification"
screenGui.DisplayOrder = 9
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.AutoLocalize = false
screenGui.ResetOnSpawn = false
screenGui.ScreenInsets = Enum.ScreenInsets.None
screenGui.Enabled = false
screenGui.Parent = CoreGui

local container = Instance.new("TextButton")
container.Name = "ToastContainer"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
container.Size = UDim2.new(1,CONFIG.WIDTH_OFFSET,0,CONFIG.TOAST_HEIGHT)
container.BackgroundTransparency = 1
container.Text = ""
container.Parent = screenGui

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MaxSize = Vector2.new(400,math.huge)
sizeConstraint.MinSize = Vector2.new(24,60)
sizeConstraint.Parent = container

local bg = Instance.new("ImageLabel")
bg.Name = "Toast"
bg.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_3x_7.png"
bg.ImageRectOffset = Vector2.new(501,960)
bg.ImageRectSize = Vector2.new(63,63)
bg.ScaleType = Enum.ScaleType.Slice
bg.SliceCenter = Rect.new(30,30,33,33)
bg.SliceScale = 0.3333333432674408
bg.ImageColor3 = CONFIG.BACKGROUND_COLOR
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundTransparency = 1
bg.Parent = container

local innerFrame = Instance.new("Frame")
innerFrame.BackgroundTransparency = 1
innerFrame.Size = UDim2.new(1,0,1,0)
innerFrame.Parent = bg

local hList = Instance.new("UIListLayout")
hList.Padding = UDim.new(0,12)
hList.FillDirection = Enum.FillDirection.Horizontal
hList.SortOrder = Enum.SortOrder.LayoutOrder
hList.VerticalAlignment = Enum.VerticalAlignment.Center
hList.Parent = innerFrame

local msgFrame = Instance.new("Frame")
msgFrame.BackgroundTransparency = 1
msgFrame.Size = UDim2.new(1,0,1,0)
msgFrame.LayoutOrder = 2
msgFrame.Parent = innerFrame

local vList = Instance.new("UIListLayout")
vList.Padding = UDim.new(0,12)
vList.SortOrder = Enum.SortOrder.LayoutOrder
vList.VerticalAlignment = Enum.VerticalAlignment.Center
vList.Parent = msgFrame

local textFrame = Instance.new("Frame")
textFrame.BackgroundTransparency = 1
textFrame.Size = UDim2.new(1,-48,0,53)
textFrame.Parent = msgFrame

local vList2 = Instance.new("UIListLayout")
vList2.SortOrder = Enum.SortOrder.LayoutOrder
vList2.VerticalAlignment = Enum.VerticalAlignment.Center
vList2.Parent = textFrame

local title = Instance.new("TextLabel")
title.Name = "ToastTitle"
title.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
title.TextColor3 = CONFIG.TEXT_COLOR
title.TextSize = CONFIG.TITLE_SIZE
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,0,22)
title.RichText = true
title.Parent = textFrame

local subtitle = Instance.new("TextLabel")
subtitle.Name = "ToastSubtitle"
subtitle.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
subtitle.TextColor3 = CONFIG.TEXT_COLOR
subtitle.TextSize = CONFIG.SUBTITLE_SIZE
subtitle.TextWrapped = true
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1,0,0,31)
subtitle.RichText = true
subtitle.Parent = textFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0,12)
padding.PaddingRight = UDim.new(0,12)
padding.PaddingTop = UDim.new(0,12)
padding.PaddingBottom = UDim.new(0,12)
padding.Parent = innerFrame

local scaler = Instance.new("UIScale")
scaler.Scale = 1
scaler.Parent = container

local currentCallback = nil

local function hideToast()
	TweenService:Create(container, TweenInfo.new(CONFIG.SLIDE_OUT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5,0,0,CONFIG.START_Y)}):Play()
	task.delay(CONFIG.SLIDE_OUT_TIME, function()
		screenGui.Enabled = false
	end)
end

local function NotifyToast(config)
	config = config or {}
	title.Text = config.title or ""
	subtitle.Text = config.content or config.subtitle or ""
	
	local duration = config.duration or CONFIG.DEFAULT_DURATION
	currentCallback = config.callback or function() end

	local showIcon = config.icon and config.icon ~= ""
	local iconObj = innerFrame:FindFirstChild("ToastIcon")
	if iconObj then iconObj:Destroy() end

	local iconColor = config.iconColor
	if type(iconColor) == "string" and iconColor:match("^#") then
		iconColor = Color3.fromHex(iconColor)
	end

	if showIcon then
		local req = http_request or (syn and syn.request) or request
		local isUrl = type(config.icon) == "string" and config.icon:match("^https?://")
		local isAsset = type(config.icon) == "string" and (config.icon:match("^rbxassetid://") or config.icon:match("^rbxasset://")) or type(config.icon) == "number"

		if isUrl or isAsset then
			iconObj = Instance.new("ImageLabel")
			if isUrl then
				local filename = "notify_icon_" .. os.time() .. ".png"
				local res = req({Url = config.icon, Method = "GET"}).Body
				writefile(filename, res)
				iconObj.Image = getcustomasset(filename)
			else
				local id = type(config.icon) == "number" and "rbxassetid://" .. config.icon or config.icon
				iconObj.Image = id
			end
			iconObj.ImageColor3 = iconColor or Color3.new(1,1,1)
		else
			iconObj = Instance.new("TextLabel")
			iconObj.FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Bold)
			iconObj.Text = config.icon
			iconObj.TextColor3 = iconColor or CONFIG.TEXT_COLOR
			iconObj.TextSize = CONFIG.ICON_SIZE
			iconObj.TextXAlignment = Enum.TextXAlignment.Center
			iconObj.TextYAlignment = Enum.TextYAlignment.Center
		end

		iconObj.Name = "ToastIcon"
		iconObj.BackgroundTransparency = 1
		iconObj.Size = UDim2.new(0, CONFIG.ICON_SIZE, 0, CONFIG.ICON_SIZE)
		iconObj.LayoutOrder = 1
		iconObj.Parent = innerFrame
	end

	local textOffset = showIcon and -48 or 0
	textFrame.Size = UDim2.new(1, textOffset, 0, 53)

	local hasTitle = title.Text ~= ""
	local hasSubtitle = subtitle.Text ~= ""
	title.Visible = hasTitle
	subtitle.Visible = hasSubtitle

	local toastHeight = (hasTitle and hasSubtitle) and CONFIG.TOAST_HEIGHT or CONFIG.SMALL_HEIGHT
	container.Size = UDim2.new(1,CONFIG.WIDTH_OFFSET,0,toastHeight)

	screenGui.Enabled = true
	container.Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
	scaler.Scale = 1

	TweenService:Create(container, TweenInfo.new(CONFIG.SLIDE_IN_TIME, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5,0,0,CONFIG.SHOW_Y)}):Play()

	task.delay(duration, function()
		if screenGui.Enabled then hideToast() end
	end)
end

container.MouseButton1Down:Connect(function()
	TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = CONFIG.SCALE_DOWN}):Play()
end)

container.MouseButton1Up:Connect(function()
	TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = 1}):Play()
	hideToast()
	if currentCallback then
		currentCallback()
		currentCallback = nil
	end
end)

container.MouseLeave:Connect(function()
	TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = 1}):Play()
end)

local startPos = nil
container.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		startPos = input.Position
	end
end)

container.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch and startPos then
		if startPos.Y - input.Position.Y > CONFIG.SWIPE_THRESHOLD then
			hideToast()
		end
		startPos = nil
	end
end)

getgenv().NotifyToast = NotifyToast
