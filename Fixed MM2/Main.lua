local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local function HttpGet(Url)
    local Body = http.get({ url = Url })
    if type(Body) == "buffer" then
        local Ok, Text = pcall(buffer.tostring, Body)
        if Ok then
            return Text
        end
    end
    return Body
end

local Library = loadstring(HttpGet("https://raw.githubusercontent.com/lec1e/Severe-Scripts/refs/heads/main/Fixed%20MM2/UI%20Library/UI%20Source.lua"))()
task.wait(2)
loadstring(HttpGet("https://raw.githubusercontent.com/lec1e/Severe-Scripts/refs/heads/main/Fixed%20MM2/Module/Helper.lua"))()
task.wait(2)

local TweenService = _G.TweenService
local GetBoundingBox = _G.GetBoundingBox

local CollectSpeed = 20
local CollectRange = 200
local GunPickupHeight = 3
local ReturnDelay = 0.4
local RoleFontSize = 13
local RoleFont = "Verdana"

local Roles = {
    Knife = { Name = "Murderer", Color = Color3.fromRGB(255, 0, 0), Alpha = 1 },
    Gun = { Name = "Sheriff", Color = Color3.fromRGB(0, 0, 255), Alpha = 1 },
}

local BoxCorners = {
    { -0.5, -0.5, -0.5 }, { -0.5, -0.5, 0.5 },
    { -0.5,  0.5, -0.5 }, { -0.5,  0.5, 0.5 },
    {  0.5, -0.5, -0.5 }, {  0.5, -0.5, 0.5 },
    {  0.5,  0.5, -0.5 }, {  0.5,  0.5, 0.5 },
}

local Module = {
    Function = {},
    Stored = {
        Map = nil,
        Gun = nil,
        OldPosition = nil,
        Grabbing = false,
    },
}

local function Flag(Name)
    return Library.Flags[Name]
end

local function FlagColor(Name)
    local Value = Flag(Name)
    if type(Value) ~= "table" then
        return nil, nil
    end
    return Value.Color, Value.Alpha
end

local function ToDrawColor(Color)
    if type(Color) == "vector" then
        return Color
    end
    if Color and Color.R ~= nil then
        return vector.create(Color.R, Color.G, Color.B)
    end
    return vector.create(1, 1, 1)
end

local function ToScreen(Point)
    return vector.create(Point.X, Point.Y)
end

local function GetRoot(Character)
    Character = Character or LocalPlayer.Character
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(Character)
    Character = Character or LocalPlayer.Character
    return Character and Character:FindFirstChild("Humanoid")
end

local function Distance(A, B)
    return vector.magnitude(A - B)
end

-- Severe's native Position is a live memory view. Storing Root.Position and then
-- writing Position updates that same value, so the "saved" spot becomes the gun.
local function CopyPosition(Value)
    if not Value then
        return nil
    end
    return vector.create(Value.X, Value.Y, Value.Z)
end

-- Helper docs: only the native BasePart.Position setter actually moves a simulated
-- part / local character. CFrame writes spin the rig; copy into vector.create first.
local function SetPosition(Part, Position)
    if not Part or not Position then
        return
    end

    local Target = CopyPosition(Position)
    Part.Position = Target

    pcall(function()
        Part.AssemblyLinearVelocity = vector.create(0, 0, 0)
        Part.AssemblyAngularVelocity = vector.create(0, 0, 0)
    end)
end

local function EachPlayer(Callback)
    for _, Player in Players:GetChildren() do
        if Player.ClassName == "Player" then
            Callback(Player)
        end
    end
end

function Module.Function:GetMap()
    for _, Child in Workspace:GetChildren() do
        if Child.ClassName == "Model" and Child:FindFirstChild("CoinContainer") then
            return Child
        end
    end
end

function Module.Function:GetGun()
    local Map = Module.Stored.Map
    return Map and Map:FindFirstChild("GunDrop")
end

function Module.Function:GetCoinCount()
    local Ok, Text = pcall(function()
        return LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.Text
    end)
    if not Ok then
        return nil
    end
    return tonumber(Text)
end

function Module.Function:GetClosestCoin(FromPosition)
    local Map = Module.Stored.Map
    local Coins = Map and Map:FindFirstChild("CoinContainer")
    if not Coins then
        return
    end

    local Closest, ClosestDistance = nil, math.huge
    for _, Coin in Coins:GetChildren() do
        if Coin:FindFirstChild("CoinVisual") and Coin:FindFirstChild("TouchInterest") then
            local CoinDistance = Distance(Coin.Position, FromPosition)
            if CoinDistance < ClosestDistance then
                ClosestDistance = CoinDistance
                Closest = Coin
            end
        end
    end

    return Closest, ClosestDistance
end

function Module.Function:FindRole(Container)
    if not Container then
        return
    end

    for _, Child in Container:GetChildren() do
        local Role = Roles[Child.Name]
        if Role then
            return Role
        end
    end
end

function Module.Function:CheckRole(Player)
    local Character = Player.Character
    if not Character then
        return
    end

    return self:FindRole(Character) or self:FindRole(Player:FindFirstChild("Backpack"))
end

function Module.Function:CharacterBox(Character)
    local Ok, Box, Size = pcall(function()
        return Character:GetBoundingBox()
    end)
    if Ok and Size and Size.Y > 0 then
        return Box, Size
    end

    if GetBoundingBox then
        Ok, Box, Size = pcall(GetBoundingBox, Character)
        if Ok and Size and Size.Y > 0 then
            return Box, Size
        end
    end
end

function Module.Function:WorldBoxToScreen(Center, Size)
    local Camera = Workspace.CurrentCamera
    if not Camera then
        return 0, 0, 0, 0, false
    end

    local Origin = Center.Position or Center
    local MinX, MinY, MaxX, MaxY = math.huge, math.huge, -math.huge, -math.huge
    local OnScreen = false

    for _, Corner in BoxCorners do
        local World = vector.create(
            Origin.X + Corner[1] * Size.X,
            Origin.Y + Corner[2] * Size.Y,
            Origin.Z + Corner[3] * Size.Z
        )
        local Screen, Visible = Camera:WorldToScreenPoint(World)
        MinX = math.min(MinX, Screen.X)
        MaxX = math.max(MaxX, Screen.X)
        MinY = math.min(MinY, Screen.Y)
        MaxY = math.max(MaxY, Screen.Y)
        if Visible then
            OnScreen = true
        end
    end

    return MinX, MinY, MaxX, MaxY, OnScreen
end

function Module.Function:DrawLabel(Position, Color, Alpha, Text)
    DrawingImmediate.OutlinedText(
        ToScreen(Position),
        RoleFontSize,
        ToDrawColor(Color),
        Alpha or 1,
        Text,
        true,
        RoleFont
    )
end

function Module.Function:RenderGun()
    if not Flag("Render Gun") then
        return
    end

    local Gun = Module.Stored.Gun
    local Camera = Workspace.CurrentCamera
    if not Gun or not Camera then
        return
    end

    local Screen, OnScreen = Camera:WorldToScreenPoint(Gun.Position)
    if not OnScreen then
        return
    end

    local Color, Alpha = FlagColor("Gun Color")
    if Color then
        self:DrawLabel(Screen, Color, Alpha, "Gun")
    end
end

function Module.Function:RenderRoles()
    if not Flag("Render Roles") then
        return
    end

    EachPlayer(function(Player)
        if Player == LocalPlayer then
            return
        end

        local Role = self:CheckRole(Player)
        local Character = Player.Character
        if not Role or not Character then
            return
        end

        local Box, Size = self:CharacterBox(Character)
        if not Box then
            return
        end

        local MinX, MinY, MaxX, MaxY, OnScreen = self:WorldBoxToScreen(Box, Size)
        if OnScreen then
            self:DrawLabel(vector.create((MinX + MaxX) / 2, MaxY + 1), Role.Color, Role.Alpha, Role.Name)
        end
    end)
end

function Module.Function:Render()
    self:RenderGun()
    self:RenderRoles()
end

function Module.Function:PlayerHasGun()
    return self:FindRole(LocalPlayer.Character) == Roles.Gun
        or self:FindRole(LocalPlayer:FindFirstChild("Backpack")) == Roles.Gun
end

function Module.Function:WaitForGunPickup(DroppedGun)
    local Deadline = os.clock() + math.max(ReturnDelay, 0.75)

    while os.clock() < Deadline do
        task.wait(0.05)

        if self:PlayerHasGun() then
            return true
        end

        if not DroppedGun or not DroppedGun.Parent then
            return true
        end
    end

    return self:PlayerHasGun()
end

function Module.Function:TeleportToGun()
    if Module.Stored.Grabbing then
        return
    end

    local Gun = Module.Stored.Gun
    local Root = GetRoot()
    if not Gun or not Root or self:PlayerHasGun() then
        return
    end

    Module.Stored.Grabbing = true

    local ReturnTo = nil
    if Flag("Position Track") then
        ReturnTo = CopyPosition(Root.Position)
        Module.Stored.OldPosition = ReturnTo
    end

    SetPosition(Root, Gun.Position + vector.create(0, GunPickupHeight, 0))

    if ReturnTo then
        task.spawn(function()
            self:WaitForGunPickup(Gun)
            task.wait(0.05)

            local CurrentRoot = GetRoot()
            if CurrentRoot then
                SetPosition(CurrentRoot, ReturnTo)
            end

            Module.Stored.Grabbing = false
        end)
    else
        Module.Stored.Grabbing = false
    end
end

function Module.Function:RefreshWorld()
    Module.Stored.Map = self:GetMap()
    Module.Stored.Gun = self:GetGun()

    if Flag("Auto Grab Gun") and Module.Stored.Gun and not Module.Stored.Grabbing and not self:PlayerHasGun() then
        self:TeleportToGun()
    end
end

function Module.Function:CollectLoop()
    local ActiveTween = nil

    while true do
        if not Flag("Auto Collect") then
            if ActiveTween then
                pcall(function()
                    ActiveTween:Cancel()
                end)
                ActiveTween = nil
            end
            task.wait(0.05)
            continue
        end

        local Root = GetRoot()
        if not Root or not Module.Stored.Map or not TweenService then
            task.wait()
            continue
        end

        if ActiveTween then
            if ActiveTween.Finished then
                ActiveTween = nil
            end
            task.wait(0.05)
            continue
        end

        local Coin, CoinDistance = self:GetClosestCoin(Root.Position)
        if not Coin or CoinDistance >= CollectRange then
            task.wait()
            continue
        end

        if Flag("Full Bag Suicide") and self:GetCoinCount() == 40 then
            local Humanoid = GetHumanoid()
            if Humanoid then
                Humanoid:TakeDamage(100)
            end
        end

        ActiveTween = TweenService:Create(
            Root,
            { Time = CoinDistance / CollectSpeed, EasingStyle = "Linear" },
            { Position = Coin.Position }
        )
        ActiveTween:Play()
        task.wait(0.05)
    end
end

local Window = Library:Window({ Name = "Gunkin-Ware | Murder Mystery 2", Size = Vector2.new(550, 600) })
local MainTab = Window:Page({ Name = "Main", Columns = 2 })
local VisualsSection = MainTab:Section({ Name = "Visuals", Side = 1 })
local ExploitsSection = MainTab:Section({ Name = "Exploits", Side = 2 })
local AutofarmSection = MainTab:Section({ Name = "Automation", Side = 2 })

local RenderRoles = VisualsSection:Toggle({ Name = "Render Roles", Flag = "Render Roles", Default = false })
RenderRoles:ColorPicker({
    Name = "Sheriff",
    Flag = "Sheriff Color",
    Default = Roles.Gun.Color,
    Alpha = 1,
    Callback = function(Color)
        Roles.Gun.Color = Color
    end,
})
RenderRoles:ColorPicker({
    Name = "Murderer",
    Flag = "Murderer Color",
    Default = Roles.Knife.Color,
    Alpha = 1,
    Callback = function(Color)
        Roles.Knife.Color = Color
    end,
})

VisualsSection:Toggle({ Name = "Render Gun", Flag = "Render Gun", Default = false }):ColorPicker({
    Name = "Gun Color",
    Flag = "Gun Color",
    Default = Color3.fromRGB(0, 255, 0),
    Alpha = 1,
})

AutofarmSection:Toggle({ Name = "Auto Collect Coins", Flag = "Auto Collect", Default = false })
AutofarmSection:Toggle({ Name = "Full Bag Suicide", Flag = "Full Bag Suicide", Default = false })

ExploitsSection:Toggle({ Name = "Auto Grab Gun", Flag = "Auto Grab Gun", Default = false })
ExploitsSection:Separator()
ExploitsSection:Toggle({ Name = "Position Track", Flag = "Position Track", Default = false })
ExploitsSection:Button({
    Name = "Teleport To Gun",
    Callback = function()
        Module.Function:TeleportToGun()
    end,
})

Library:Watermark("Gunkin-Ware")
Library:NavigationBar(Library.Windows[1], Library:StyleWindow(), Library:ConfigWindow())

task.spawn(function()
    Module.Function:CollectLoop()
end)

task.spawn(function()
    while true do
        task.wait(1)
        Module.Function:RefreshWorld()
    end
end)

RunService.Render:Connect(function()
    Module.Function:Render()
end)
