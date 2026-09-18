
local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    local Camera = Workspace.CurrentCamera

    local FromRGB = Color3.fromRGB
    local Vector2New = Vector2.new

    local MathFloor = math.floor
    local MathCeil = math.ceil
    local MathClamp = math.clamp
    local MathMax = math.max
    local MathMin = math.min

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableSort = table.sort
    local TableUnpack = table.unpack

    local StringFormat = string.format

    Library = {
        Flags = { },

        Theme = {
            ["Accent"] = FromRGB(177, 156, 217),
            ["Background"] = FromRGB(28, 28, 28),
            ["Dark Background"] = FromRGB(20, 20, 20),
            ["Border"] = FromRGB(50, 50, 50),
            ["Dim"] = FromRGB(180, 180, 180),
            ["Black"] = FromRGB(0, 0, 0),
            ["White"] = FromRGB(255, 255, 255),
        },

        DPIScale = _G.DPIScale or 1,

        Layout = {
            SectionPadding = 7,
            SectionGap = 6,
            SectionMiddleGap = 4,
            SectionHeaderHeight = 26,
            SectionInnerPadding = 5,
            SectionPickerRowHeight = 20,
            SwatchWidth = 28,
            SwatchGap = 3,
        },

        Input = {
            Mouse = nil,
            MouseX = 0,
            MouseY = 0,
            MouseDown = false,
            MouseClicked = false,
            RightClicked = false,
            MousePrevious = false,
            RightPrevious = false,
            Consumed = false,
            FocusedTextbox = nil,
            ActiveKeyPickers = { },
        },

        Windows = { },

        Folders = {
            Directory = "Goop",
            Files = "Goop/Files",
            Fonts = "Goop/Files/Fonts",
            Images = "Goop/Files/Images",
            Configs = "Goop/" .. tostring(game.GameId) .. "/Configs",
        },

        Fonts = {
            Data = {List = {}, Fonts = {}},
            Stored = {
                {"ProggyClean.ttf",       "ProggyClean.json",       "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/ProggyClean.ttf"},
                {"Minecraftia.ttf",       "Minecraftia.json",       "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/Minecraftia.ttf"},
                {"Verdana.ttf",           "Verdana.json",           "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/Verdana.ttf"},
                {"Visitor.ttf",           "Visitor.json",           "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/Visitor.ttf"},
                {"SmallestPixel.ttf",     "SmallestPixel.json",     "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/SmallestPixel.ttf"},
                {"Windows-XP-Tahoma.ttf", "Windows-XP-Tahoma.json", "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/Windows-XP-Tahoma.ttf"},
                {"Monaco.ttf",            "Monaco.json",            "https://github.com/lec1e/Severe-UI-Libraries/raw/refs/heads/main/fonts/Monaco.ttf"},
            },
        }
    }

    Library.Camera = Camera
    Library.Viewport = Camera.ViewportSize * Library.DPIScale

    local Theme = Library.Theme

    local Keys = {
        ["LeftMouse"] = "mb1", ["RightMouse"] = "mb2",
        ["Escape"] = "esc",
        ["F1"] = "f1", ["F2"] = "f2", ["F3"] = "f3", ["F4"] = "f4",
        ["F5"] = "f5", ["F6"] = "f6", ["F7"] = "f7", ["F8"] = "f8",
        ["F9"] = "f9", ["F10"] = "f10", ["F11"] = "f11", ["F12"] = "f12",
        ["PrintScreen"] = "prt",
        ["Insert"] = "ins", ["Delete"] = "del",
        ["MediaPrevTrack"] = "prev", ["MediaPlayPause"] = "play", ["MediaNextTrack"] = "next",
        ["OEM_3"] = "`",
        ["1"] = "1", ["2"] = "2", ["3"] = "3", ["4"] = "4", ["5"] = "5",
        ["6"] = "6", ["7"] = "7", ["8"] = "8", ["9"] = "9", ["0"] = "0",
        ["OEM_MINUS"] = "-", ["OEM_PLUS"] = "=",
        ["Backspace"] = "bs",
        ["NumLock"] = "num", ["Divide"] = "np/", ["Multiply"] = "np*",
        ["Tab"] = "tab",
        ["Q"] = "q", ["W"] = "w", ["E"] = "e", ["R"] = "r", ["T"] = "t",
        ["Y"] = "y", ["U"] = "u", ["I"] = "i", ["O"] = "o", ["P"] = "p",
        ["OEM_4"] = "[", ["OEM_6"] = "]", ["OEM_5"] = "\\",
        ["Numpad7"] = "np7", ["Numpad8"] = "np8", ["Numpad9"] = "np9",
        ["Subtract"] = "np-", ["Add"] = "np+",
        ["Numpad6"] = "np6", ["Numpad5"] = "np5", ["Numpad4"] = "np4",
        ["Enter"] = "enter",
        ["OEM_7"] = "'", ["OEM_1"] = ";",
        ["L"] = "l", ["K"] = "k", ["J"] = "j", ["H"] = "h", ["G"] = "g",
        ["F"] = "f", ["D"] = "d", ["S"] = "s", ["A"] = "a",
        ["CapsLock"] = "caps",
        ["Shift"] = "shft", ["LeftShift"] = "ls", ["RightShift"] = "rs",
        ["Z"] = "z", ["X"] = "x", ["C"] = "c", ["V"] = "v",
        ["B"] = "b", ["N"] = "n", ["M"] = "m",
        ["OEM_COMMA"] = ",", ["OEM_PERIOD"] = ".", ["OEM_2"] = "/",
        ["UpArrow"] = "↑",
        ["Numpad1"] = "np1", ["Numpad2"] = "np2", ["Numpad3"] = "np3",
        ["Decimal"] = "np.", ["Numpad0"] = "np0",
        ["RightArrow"] = "→", ["DownArrow"] = "↓", ["LeftArrow"] = "←",
        ["Ctrl"] = "ctrl", ["LeftCtrl"] = "lc", ["RightCtrl"] = "rc",
        ["Applications"] = "menu",
        ["Alt"] = "alt", ["LeftAlt"] = "la", ["RightAlt"] = "ra",
        ["Space"] = "spce",
    }

    local Characters = {
        ["A"] = "a", ["B"] = "b", ["C"] = "c", ["D"] = "d", ["E"] = "e",
        ["F"] = "f", ["G"] = "g", ["H"] = "h", ["I"] = "i", ["J"] = "j",
        ["K"] = "k", ["L"] = "l", ["M"] = "m", ["N"] = "n", ["O"] = "o",
        ["P"] = "p", ["Q"] = "q", ["R"] = "r", ["S"] = "s", ["T"] = "t",
        ["U"] = "u", ["V"] = "v", ["W"] = "w", ["X"] = "x", ["Y"] = "y", ["Z"] = "z",
        ["Zero"] = "0", ["One"] = "1", ["Two"] = "2", ["Three"] = "3", ["Four"] = "4",
        ["Five"] = "5", ["Six"] = "6", ["Seven"] = "7", ["Eight"] = "8", ["Nine"] = "9",
        ["Space"] = " ", ["Minus"] = "-", ["Underscore"] = "_", ["Period"] = ".",
    }

    for _, Folder in Library.Folders do
        if not fs.folder(Folder) then
            fs.make(Folder)
        end
    end

    local function LoadFonts()
        for _, FontData in pairs(Library.Fonts.Stored) do
            local Name, Url = FontData[1]:match("([^%.]+)"), FontData[3]
            local TTFPath = Library.Folders.Fonts .. "/" .. Name .. ".bin"

            if not fs.file(TTFPath) then
                local Body = http.get({ url = Url })
                fs.write(TTFPath, Body)
            end

            local Data = fs.read(TTFPath)
            Drawing.RegisterFont(Name, 13, Data)

            Library.Fonts.Data.Fonts[Name] = true
            table.insert(Library.Fonts.Data.List, Name)
        end
    end

    LoadFonts()

    Library.FontSize = 13
    Library.Font = Library.Fonts.Data.Fonts["Verdana"] and "Verdana" or Library.Fonts.Data.List[1]

    -- // Icons \\ --

    local IconUrls = {
        Home = "https://raw.githubusercontent.com/lec1e/Severe-UI-Libraries/refs/heads/main/assets/goop/Home.png",
        Style = "https://raw.githubusercontent.com/lec1e/Severe-UI-Libraries/refs/heads/main/assets/goop/Style.png",
        Config = "https://raw.githubusercontent.com/lec1e/Severe-UI-Libraries/refs/heads/main/assets/goop/Config.png",
    }

    Library.Icons = { }

    local function LoadIcons()
        for Name, Url in pairs(IconUrls) do
            local ImagePath = Library.Folders.Images .. "/" .. Name .. ".png"

            if not fs.file(ImagePath) then
                fs.write(ImagePath, http.get({ url = Url }))
            end

            Library.Icons[Name] = fs.read(ImagePath)
        end
    end

    LoadIcons()

    -- // Core \\ --
    local OutlineColor = Vector3.new(0, 0, 0)
    local PropCache = setmetatable({ }, { __mode = "k" })

    local function NewDrawing(Type, Properties)
        local Ok, Object = pcall(Drawing.new, Type)
        if not Ok or not Object then
            return nil
        end
        local Cache = { }
        PropCache[Object] = Cache
        if Properties then
            for Key, Value in Properties do
                pcall(function()
                    Object[Key] = Value
                end)
                Cache[Key] = Value
            end
        end
        return Object
    end

    local function UpdateDrawing(Object, Properties)
        if not Object then
            return
        end
        local Cache = PropCache[Object]
        if not Cache then
            Cache = { }
            PropCache[Object] = Cache
        end
        for Key, Value in Properties do
            if Cache[Key] ~= Value then
                pcall(function()
                    Object[Key] = Value
                end)
                Cache[Key] = Value
            end
        end
    end

    local Pool = {
        Squares = { }, SquareCount = 0,
        Texts = { }, TextCount = 0,
        Images = { }, ImageCount = 0,
        Order = 0,
    }

    function Pool:Begin()
        self.SquareCount = 0
        self.TextCount = 0
        self.ImageCount = 0
        self.Order = 0
    end

    function Pool:Finish()
        for Index = self.SquareCount + 1, #self.Squares do
            UpdateDrawing(self.Squares[Index], { Visible = false })
        end
        for Index = self.TextCount + 1, #self.Texts do
            UpdateDrawing(self.Texts[Index], { Visible = false })
        end
        for Index = self.ImageCount + 1, #self.Images do
            UpdateDrawing(self.Images[Index], { Visible = false })
        end
    end

    -- // Draw Helpers \\ --

    local MAX_SQUARES = 220
    local MAX_TEXTS = 120
    local MAX_IMAGES = 24

    local function DrawRect(X, Y, W, H, Color, Opacity)
        W = MathFloor(tonumber(W) or 0)
        H = MathFloor(tonumber(H) or 0)
        X = tonumber(X) or 0
        Y = tonumber(Y) or 0
        if W < 1 or H < 1 or X ~= X or Y ~= Y then
            return
        end

        Pool.Order = Pool.Order + 1
        local Index = Pool.SquareCount + 1
        if Index > MAX_SQUARES then
            return
        end
        Pool.SquareCount = Index

        local Square = Pool.Squares[Index]
        if not Square then
            Square = NewDrawing("Square", { Filled = true, Thickness = 1 })
            Pool.Squares[Index] = Square
        end
        if not Square then
            return
        end

        UpdateDrawing(Square, {
            Visible = true,
            Position = Vector2New(X, Y),
            Size = Vector2New(W, H),
            Color = Color,
            Opacity = Opacity or 1,
            ZIndex = Pool.Order,
        })
    end

    local function DrawText(X, Y, Size, Color, Text, Opacity, Center)
        X = tonumber(X) or 0
        Y = tonumber(Y) or 0
        if X ~= X or Y ~= Y then
            return
        end

        Pool.Order = Pool.Order + 1
        local Index = Pool.TextCount + 1
        if Index > MAX_TEXTS then
            return
        end
        Pool.TextCount = Index

        local Object = Pool.Texts[Index]
        if not Object then
            Object = NewDrawing("Text", { Outline = true, OutlineColor = OutlineColor })
            Pool.Texts[Index] = Object
        end
        if not Object then
            return
        end

        UpdateDrawing(Object, {
            Visible = true,
            Position = Vector2New(X, Y),
            Size = Size,
            Color = Color,
            Text = Text,
            Center = Center or false,
            Opacity = Opacity or 1,
            Font = Library.Font,
            ZIndex = Pool.Order,
        })
    end

    local MeasureText = NewDrawing("Text", { Visible = false })

    local function GetTextBounds(Text, Size)
        UpdateDrawing(MeasureText, {
            Text = tostring(Text),
            Size = Size or Library.FontSize,
            Font = Library.Font,
        })
        return MeasureText.TextBounds
    end

    local function DrawImage(X, Y, W, H, Data, Color, Opacity, ForcedZ)
        Pool.Order = Pool.Order + 1
        local Index = Pool.ImageCount + 1
        if Index > MAX_IMAGES then
            return
        end
        Pool.ImageCount = Index

        local Object = Pool.Images[Index]
        if not Object then
            Object = NewDrawing("Image", { })
            Pool.Images[Index] = Object
        end

        UpdateDrawing(Object, {
            Visible = true,
            Position = Vector2New(X, Y),
            Size = Vector2New(W, H),
            Data = Data,
            Color = Color or Theme["White"],
            Opacity = Opacity or 1,
            ZIndex = ForcedZ or Pool.Order,
        })
    end

    local function DrawBox(X, Y, W, H, Outer, Border, Fill)
        W = tonumber(W) or 0
        H = tonumber(H) or 0
        if W < 4 or H < 4 then
            return
        end
        DrawRect(X, Y, W, H, Outer)
        DrawRect(X + 1, Y + 1, W - 2, H - 2, Border)
        DrawRect(X + 2, Y + 2, W - 4, H - 4, Fill)
    end

    local function DrawSwatch(X, Y, Color, Alpha)
        Alpha = Alpha or 255
        DrawRect(X, Y, 28, 13, Theme["Black"])
        DrawRect(X + 1, Y + 1, 26, 11, Theme["Border"])
        if Alpha < 255 then
            DrawRect(X + 2, Y + 2, 12, 4, FromRGB(160, 160, 160))
            DrawRect(X + 14, Y + 2, 12, 4, FromRGB(100, 100, 100))
            DrawRect(X + 2, Y + 6, 12, 5, FromRGB(100, 100, 100))
            DrawRect(X + 14, Y + 6, 12, 5, FromRGB(160, 160, 160))
        end
        DrawRect(X + 2, Y + 2, 24, 9, Color, Alpha / 255)
    end

    local function TruncateText(Text, MaxWidth, Size)
        if GetTextBounds(Text, Size).X <= MaxWidth then
            return Text
        end
        local Truncated = Text
        while #Truncated > 0 do
            Truncated = Truncated:sub(1, -2)
            if GetTextBounds(Truncated .. "...", Size).X <= MaxWidth then
                return Truncated .. "..."
            end
        end
        return "..."
    end

    -- // Library Helpers \\ --

    function Library:FormatInput(Name)
        local Mapped = Keys[Name]
        if Mapped then return Mapped end
        if #Name == 1 then return Name:lower() end
        local Lower = Name:lower()
        return #Lower > 4 and Lower:sub(1, 4) or Lower
    end

    function Library:HSVToRGB(H, S, V)
        local Hue6 = H * 6
        local SectorIndex = MathFloor(Hue6) % 6
        local FractionalPart = Hue6 - MathFloor(Hue6)

        local p = MathFloor(V * (1 - S) * 255)
        local q = MathFloor(V * (1 - FractionalPart * S) * 255)
        local t = MathFloor(V * (1 - (1 - FractionalPart) * S) * 255)
        local v = MathFloor(V * 255)

        if SectorIndex == 0 then return v, t, p end
        if SectorIndex == 1 then return q, v, p end
        if SectorIndex == 2 then return p, v, t end
        if SectorIndex == 3 then return p, q, v end
        if SectorIndex == 4 then return t, p, v end
        return v, p, q
    end

    function Library:RGBToHSV(R, G, B)
        R, G, B = R / 255, G / 255, B / 255

        local MaxComponent = MathMax(R, G, B)
        local MinComponent = MathMin(R, G, B)
        local Delta = MaxComponent - MinComponent

        local Saturation = MaxComponent == 0 and 0 or Delta / MaxComponent
        local Value = MaxComponent
        local Hue = 0

        if Delta > 0 then
            if MaxComponent == R then
                Hue = ((G - B) / Delta) % 6
            elseif MaxComponent == G then
                Hue = (B - R) / Delta + 2
            else
                Hue = (R - G) / Delta + 4
            end
            Hue = Hue / 6
        end

        return Hue, Saturation, Value
    end

    function Library:UpdateInput()
        local Input = self.Input

        self.Viewport = self.Camera.ViewportSize * self.DPIScale

        Input.Mouse = UserInputService:GetMouseLocation()
        Input.MouseX = Input.Mouse.X * self.DPIScale
        Input.MouseY = Input.Mouse.Y * self.DPIScale
        Input.MouseClicked = isleftpressed() and not Input.MousePrevious
        Input.RightClicked = isrightpressed() and not Input.RightPrevious
        Input.MouseDown = isleftpressed()
        Input.MousePrevious = isleftpressed()
        Input.RightPrevious = isrightpressed()
    end

    function Library:IsHovering(X, Y, Width, Height)
        local Input = self.Input
        return Input.MouseX >= X and Input.MouseX <= X + Width
            and Input.MouseY >= Y and Input.MouseY <= Y + Height
    end

    -- // Attached Pickers \\ --

    local SW = Library.Layout.SwatchWidth
    local SG = Library.Layout.SwatchGap

    local function SwatchX(RightEdge, Index)
        return RightEdge - SW - Index * (SW + SG)
    end

    local NewColorPicker, NewKeyPicker

    local function RenderAttachedPickers(Host, AnchorX, BadgeY, LeftAlign)
        local function SlotX(Index)
            if LeftAlign then
                return AnchorX + Index * (SW + SG)
            end
            return SwatchX(AnchorX, Index)
        end

        for Index, Picker in Host.AttachedColorPickers do
            local X = SlotX(Index - 1)
            DrawSwatch(X, BadgeY, FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]), Picker.Alpha * 255)
            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, BadgeY, SW, 13) then
                Library.Input.Consumed = true
                Library:ToggleColorPickerWindow(Picker, X - 200, BadgeY + 17)
            end
        end

        local Keypicker = Host.AttachedKeyPicker
        if Keypicker then
            local X = SlotX(#Host.AttachedColorPickers)
            local Hovered = Library:IsHovering(X, BadgeY, SW, 13)
            local Label = Keypicker.Capturing and "..." or Library:FormatInput(Keypicker.BoundKey)

            DrawBox(X, BadgeY, SW, 13,
                Theme["Black"],
                Keypicker.Capturing and Theme["Accent"] or Theme["Border"],
                Keypicker.Capturing and Theme["Accent"] or (Hovered and Theme["Dark Background"] or Theme["Background"]))

            local Bounds = GetTextBounds(Label, 11)
            DrawText(X + MathFloor((SW - Bounds.X) / 2), BadgeY + MathFloor((13 - Bounds.Y) / 2), 11,
                Keypicker.Capturing and Theme["White"] or Theme["Dim"], Label)

            if Library.Input.MouseClicked and not Library.Input.Consumed and Hovered then
                Library.Input.Consumed = true
                Keypicker.Capturing = true
                Keypicker.ContextOpen = false
                Keypicker.CapturingTime = tick()
                Library.CapturingKeyPicker = Keypicker
            end

            if Library.Input.RightClicked and not Library.Input.Consumed and Hovered then
                Library.Input.Consumed = true
                Keypicker.ContextOpen = not Keypicker.ContextOpen
                Library.KeyPickerContext = Keypicker.ContextOpen and { Element = Keypicker, X = X, Y = BadgeY + 16 } or nil
            end
        end
    end

    -- // ColorPicker Element \\ --

    function NewColorPicker(Section, Data)
        Data = Data or { }

        local DefaultColor = Data.Default or FromRGB(177, 156, 217)
        local ColorPicker = {
            Section = Section,
            Type = "ColorPicker",
            Name = Data.Name or "",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,

            Color = { DefaultColor.R * 255, DefaultColor.G * 255, DefaultColor.B * 255 },
            Alpha = Data.Alpha or 1,

            Height = 20,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
            AttachedColorPickers = { },
            AttachedKeyPicker = nil,
        }

        if ColorPicker.Flag then
            Library.Flags[ColorPicker.Flag] = { Color = DefaultColor, Alpha = ColorPicker.Alpha }
        end

        function ColorPicker:SyncFlag()
            if not self.Flag then return end
            Library.Flags[self.Flag] = {
                Color = FromRGB(self.Color[1], self.Color[2], self.Color[3]),
                Alpha = MathClamp(self.Alpha, 0, 1),
            }
        end

        function ColorPicker:Render()
            local X, Y = self.X, self.Y
            local AnchorRight = self.SectionRightEdge or (X + self.Width)

            DrawText(X, Y + 2, Library.FontSize, Theme["White"], self.Name)

            local SwX = SwatchX(AnchorRight, 0)
            DrawSwatch(SwX, Y + 1, FromRGB(self.Color[1], self.Color[2], self.Color[3]), self.Alpha * 255)

            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(SwX, Y + 1, SW, 13) then
                Library.Input.Consumed = true
                Library:ToggleColorPickerWindow(self, SwX - 200, Y + 18)
            end
        end

        return ColorPicker
    end

    -- // KeyPicker Element \\ --

    function NewKeyPicker(Section, Data)
        Data = Data or { }

        local KeyPicker = {
            Section = Section,
            Type = "KeyPicker",
            Name = Data.Name or "",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,
            HasCallback = Data.Callback ~= nil,
            ToggleElement = Data.ToggleElement,

            BoundKey = Data.Default or "None",
            Mode = "Toggle",
            Capturing = false,
            CapturingTime = 0,
            ContextOpen = false,
            ToggledState = false,

            Height = 0,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }

        if KeyPicker.Flag then
            Library.Flags[KeyPicker.Flag] = { Key = KeyPicker.BoundKey, Mode = KeyPicker.Mode }
            local Active = Library.Input.ActiveKeyPickers
            Active[#Active + 1] = KeyPicker
        end

        function KeyPicker:SyncFlag()
            if not self.Flag then return end
            Library.Flags[self.Flag] = { Key = self.BoundKey, Mode = self.Mode }
        end

        function KeyPicker:Render() end

        return KeyPicker
    end

    -- // Attach Helpers \\ --
    -- Shared by Toggle and Label so both rows can host a swatch / badge.

    local function AttachColorPicker(Host, Section, Data)
        assert(#Host.AttachedColorPickers < 2, "A Toggle/Label can only have a maximum of 2 attached ColorPickers")
        Data = Data or { }
        Data.Name = Data.Name or Host.Name

        local Picker = NewColorPicker(Section, Data)
        Picker.Hidden = true
        Picker.HostName = Host.Name
        Host.AttachedColorPickers[#Host.AttachedColorPickers + 1] = Picker
        Section.Elements[#Section.Elements + 1] = Picker
        return Picker
    end

    local function AttachKeyPicker(Host, Section, Data)
        assert(Host.AttachedKeyPicker == nil, "A Toggle/Label can only have one attached KeyPicker")
        Data = Data or { }
        -- A Toggle drives its own .Value; a Label relies on its own Callback.
        if Host.Type == "Toggle" then
            Data.ToggleElement = Host
        end

        local Picker = NewKeyPicker(Section, Data)
        Picker.Hidden = true
        Picker.HostName = Host.Name
        Host.AttachedKeyPicker = Picker
        Section.Elements[#Section.Elements + 1] = Picker
        return Picker
    end

    -- Find the most recent Toggle/Label to host a picker, skipping the hidden
    -- pickers already attached to elements below it.
    local function FindPickerHost(Section)
        for Index = #Section.Elements, 1, -1 do
            local Element = Section.Elements[Index]
            if Element.Hidden and (Element.Type == "ColorPicker" or Element.Type == "KeyPicker") then
                -- skip
            elseif Element.Type == "Toggle" or Element.Type == "Label" then
                return Element
            else
                return nil
            end
        end
    end

    -- // Sections \\ --
    -- Each element is built by a self-contained factory below: it owns its state,
    -- its :Render (drawing + input + flag), and any attach methods. The Section
    -- render loop just calls Element:Render() on every visible element in order.

    local Sections = { }
    Sections.__index = Sections
    Library.Sections = Sections

    function Sections:Toggle(Data)
        Data = Data or { }

        local Toggle = {
            Section = self,
            Type = "Toggle",
            Name = Data.Name or "",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,

            Value = Data.Default or false,
            HasRealCallback = Data.Callback ~= nil,

            Height = 20,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
            AttachedColorPickers = { },
            AttachedKeyPicker = nil,
        }

        if Toggle.Flag then
            Library.Flags[Toggle.Flag] = Toggle.Value
        end

        function Toggle:SyncFlag()
            if self.Flag then
                Library.Flags[self.Flag] = self.Value
            end
        end

        function Toggle:Set(Value)
            self.Value = Value
            self:SyncFlag()
            self.Callback(self.Value)
        end

        function Toggle:Render()
            local X, Y, Width = self.X, self.Y, self.Width
            local AnchorRight = self.SectionRightEdge or (X + Width)

            DrawBox(X, Y, 15, 15,
                Theme["Black"],
                self.Value and Theme["Accent"] or Theme["Border"],
                self.Value and Theme["Accent"] or Theme["Background"])
            DrawText(X + 18, Y + 1, Library.FontSize, Theme["White"], self.Name)

            RenderAttachedPickers(self, AnchorRight, Y + 1)

            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, Y, Width, 15) then
                Library.Input.Consumed = true
                self.Value = not self.Value
                self:SyncFlag()
                self.Callback(self.Value)
            end
        end

        function Toggle:ColorPicker(Data) return AttachColorPicker(self, self.Section, Data) end
        function Toggle:KeyPicker(Data) return AttachKeyPicker(self, self.Section, Data) end

        self.Elements[#self.Elements + 1] = Toggle
        return Toggle
    end

    function Sections:Slider(Data)
        Data = Data or { }

        local Slider = {
            Section = self,
            Type = "Slider",
            Name = Data.Name or "",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,

            Min = Data.Min or 0,
            Max = Data.Max or 100,
            Value = Data.Default or Data.Min or 0,
            Decimals = (Data.Decimals ~= nil) and Data.Decimals or 1,
            Suffix = (Data.Suffix ~= nil and Data.Suffix ~= "") and Data.Suffix or "",

            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }
        Slider.Height = (Slider.Name ~= "") and 35 or 20

        if Slider.Flag then
            Library.Flags[Slider.Flag] = { Value = Slider.Value }
        end

        function Slider:SyncFlag()
            if self.Flag then
                Library.Flags[self.Flag] = { Value = self.Value }
            end
        end

        function Slider:Render()
            local X, Y, Width = self.X, self.Y, self.Width

            local BarY = Y
            if self.Name ~= "" then
                DrawText(X, Y, Library.FontSize, Theme["White"], self.Name)
                BarY = Y + 15
            end

            DrawBox(X, BarY, Width, 15, Theme["Black"], Theme["Border"], Theme["Background"])

            local Fraction = (self.Value - self.Min) / (self.Max - self.Min)
            local FillWidth = MathFloor((Width - 2) * Fraction)
            if FillWidth > 0 then
                DrawRect(X + 1, BarY + 1, FillWidth, 13, Theme["Accent"])
                DrawRect(X + 2, BarY + 2, MathMax(FillWidth - 2, 0), 11, Theme["Accent"])
            end

            local ValueText = tostring(self.Value) .. "/" .. tostring(self.Max) .. self.Suffix
            local Bounds = GetTextBounds(ValueText)
            DrawText(X + MathFloor((Width - Bounds.X) / 2), BarY + 1, Library.FontSize, Theme["White"], ValueText)

            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, BarY, Width, 15) then
                Library.ActiveSlider = self
                Library.Input.Consumed = true
            end

            if Library.ActiveSlider == self and Library.Input.MouseDown then
                local Raw = self.Min + ((Library.Input.MouseX - X - 2) / (Width - 4)) * (self.Max - self.Min)
                local Stepped = MathFloor(Raw / self.Decimals + 0.5) * self.Decimals
                local NewValue = MathClamp(Stepped, self.Min, self.Max)
                -- Round to avoid floating-point display noise.
                local Precision = MathMax(0, MathCeil(-math.log10(self.Decimals + 1e-9)))
                NewValue = tonumber(StringFormat("%." .. Precision .. "f", NewValue))
                if NewValue ~= self.Value then
                    self.Value = NewValue
                    self:SyncFlag()
                    self.Callback(self.Value)
                end
            end

            if not Library.Input.MouseDown and Library.ActiveSlider == self then
                Library.ActiveSlider = nil
            end
        end

        self.Elements[#self.Elements + 1] = Slider
        return Slider
    end

    function Sections:Dropdown(Data)
        Data = Data or { }

        local Dropdown = {
            Section = self,
            Type = "Dropdown",
            Name = Data.Name or "",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,

            Options = Data.Options or { },
            Multi = Data.Multi or false,
            Open = false,

            Height = 42,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }

        if Dropdown.Multi then
            Dropdown.SelectedIndices = { }
            local Defaults = Data.Default or { }
            if type(Defaults) == "table" then
                for _, Index in Defaults do
                    Dropdown.SelectedIndices[Index] = true
                end
            elseif type(Defaults) == "number" then
                Dropdown.SelectedIndices[Defaults] = true
            end
        else
            Dropdown.SelectedIndex = type(Data.Default) == "number" and Data.Default or 1
        end

        function Dropdown:SyncFlag()
            if not self.Flag then return end
            if self.Multi then
                local Valid = { }
                for Index, Selected in self.SelectedIndices do
                    if Selected then Valid[#Valid + 1] = self.Options[Index] end
                end
                TableSort(Valid)
                Library.Flags[self.Flag] = { Value = Valid }
            else
                Library.Flags[self.Flag] = { Value = self.Options[self.SelectedIndex] }
            end
        end

        Dropdown:SyncFlag()

        function Dropdown:Render()
            local X, Y, Width = self.X, self.Y, self.Width
            local MaxTextWidth = Width - 20
            local DisplayText

            if self.Multi then
                local Valid = { }
                for Index, Selected in self.SelectedIndices do
                    if Selected then Valid[#Valid + 1] = self.Options[Index] end
                end
                TableSort(Valid)
                local Raw = #Valid == 0 and "None" or TableConcat(Valid, ", ")
                DisplayText = TruncateText(Raw, MaxTextWidth)
            else
                DisplayText = TruncateText(self.Options[self.SelectedIndex], MaxTextWidth)
            end

            DrawText(X, Y, Library.FontSize, Theme["White"], self.Name)

            local BarY = Y + 15
            DrawRect(X, BarY, Width, 22, Theme["Black"])
            DrawRect(X + 1, BarY + 1, Width - 2, 20, self.Open and Theme["Accent"] or Theme["Border"])
            DrawRect(X + 2, BarY + 2, Width - 4, 18, Theme["Background"])
            DrawText(X + 5, BarY + 4, Library.FontSize, Theme["White"], DisplayText)
            DrawText(X + Width - 14, BarY + 4, Library.FontSize, Theme["Accent"], self.Open and "-" or "+")

            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, BarY, Width, 22) then
                Library.Input.Consumed = true
                if Library.ActiveDropdown == self then
                    Library.ActiveDropdown = nil
                    self.Open = false
                else
                    if Library.ActiveDropdown then Library.ActiveDropdown.Open = false end
                    Library.ActiveDropdown = self
                    self.Open = true
                end
            end

            if self.Open and Library.ActiveDropdown == self then
                Library.DropdownOverlay = { X = X, Y = BarY + 22, Width = Width, Element = self }
            end
        end

        self.Elements[#self.Elements + 1] = Dropdown
        return Dropdown
    end

    function Sections:Button(Data)
        Data = Data or { }

        local Button = {
            Section = self,
            Type = "Button",
            Name = Data.Name or "",
            Callback = Data.Callback or function() end,

            Height = 26,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }

        function Button:SyncFlag() end

        function Button:Render()
            local X, Y, Width = self.X, self.Y, self.Width
            local Hovered = Library:IsHovering(X, Y, Width, 22) and not Library.Input.Consumed

            DrawBox(X, Y, Width, 22, Theme["Black"], Theme["Border"], Hovered and Theme["Dark Background"] or Theme["Background"])
            DrawText(X + 4, Y + 4, Library.FontSize, Hovered and Theme["Accent"] or Theme["White"], self.Name)

            if Library.Input.MouseClicked and Hovered then
                Library.Input.Consumed = true
                self.Callback()
            end
        end

        self.Elements[#self.Elements + 1] = Button
        return Button
    end

    function Sections:Separator()
        local Separator = {
            Section = self,
            Type = "Separator",
            Height = 8,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }

        function Separator:SyncFlag() end

        function Separator:Render()
            DrawRect(self.X, self.Y + 3, self.Width, 1, Theme["Border"], 0.5)
        end

        self.Elements[#self.Elements + 1] = Separator
        return Separator
    end

    function Sections:Label(Data)
        Data = Data or { }

        local Label = {
            Section = self,
            Type = "Label",
            Name = Data.Name or "",
            TextColor = Data.Color,

            Height = 16,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
            AttachedColorPickers = { },
            AttachedKeyPicker = nil,
        }

        function Label:SyncFlag() end

        function Label:Render()
            local X, Y = self.X, self.Y
            local AnchorRight = self.SectionRightEdge or (X + self.Width)
            DrawText(X, Y, Library.FontSize, self.TextColor or Theme["Dim"], self.Name)
            RenderAttachedPickers(self, AnchorRight, Y)
        end

        function Label:ColorPicker(Data) return AttachColorPicker(self, self.Section, Data) end
        function Label:KeyPicker(Data) return AttachKeyPicker(self, self.Section, Data) end

        self.Elements[#self.Elements + 1] = Label
        return Label
    end

    function Sections:Textbox(Data)
        Data = Data or { }

        local Textbox = {
            Section = self,
            Type = "Textbox",
            Flag = Data.Flag,
            Callback = Data.Callback or function() end,

            Value = Data.Default or "",
            Placeholder = Data.Placeholder or "Type here...",
            MaxLength = Data.MaxLength or 64,
            PrevKeys = { },

            Height = 28,
            Hidden = false,
            X = 0, Y = 0, Width = 0,
        }

        if Textbox.Flag then
            Library.Flags[Textbox.Flag] = Textbox.Value
        end

        function Textbox:SyncFlag()
            if self.Flag then
                Library.Flags[self.Flag] = self.Value
            end
        end

        function Textbox:Render()
            local X, Y, Width = self.X, self.Y, self.Width
            local IsFocused = (Library.Input.FocusedTextbox == self)

            DrawBox(X, Y, Width, 22,
                Theme["Black"],
                IsFocused and Theme["Accent"] or Theme["Border"],
                Theme["Background"])

            local DisplayText = self.Value ~= "" and self.Value or self.Placeholder
            local TextColor = self.Value ~= "" and Theme["White"] or Theme["Dim"]
            local Bounds = GetTextBounds(DisplayText, 12)
            DrawText(X + 5, Y + MathFloor((22 - Bounds.Y) / 2), 12, TextColor, DisplayText)

            if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, Y, Width, 22) then
                Library.Input.Consumed = true
                Library.Input.FocusedTextbox = self
            end

            if IsFocused then
                for _, Key in getpressedkeys() do
                    if not TableFind(self.PrevKeys, Key) then
                        if Key == "Enter" then
                            Library.Input.FocusedTextbox = nil
                            self.PrevKeys = { }
                            self:SyncFlag()
                            self.Callback(self.Value)
                            break
                        elseif Key == "Backspace" then
                            self.Value = self.Value:sub(1, -2)
                            self:SyncFlag()
                        elseif Characters[Key] and #self.Value < self.MaxLength then
                            self.Value = self.Value .. Characters[Key]
                            self:SyncFlag()
                        end
                    end
                end
                self.PrevKeys = getpressedkeys() or { }
            end
        end

        self.Elements[#self.Elements + 1] = Textbox
        return Textbox
    end

    function Sections:ColorPicker(Data)
        Data = Data or { }

        -- Section = true attaches the swatch to the section header itself.
        if Data.Section then
            assert(#self.AttachedColorPickers < 2, "A Section can only have a maximum of 2 attached ColorPickers")
            local Picker = NewColorPicker(self, Data)
            Picker.Hidden = true
            Picker.HostName = self.Name
            self.AttachedColorPickers[#self.AttachedColorPickers + 1] = Picker
            self.Elements[#self.Elements + 1] = Picker
            return Picker
        end

        local Host = FindPickerHost(self)
        if Host then
            return AttachColorPicker(Host, self, Data)
        end

        -- No host -> standalone ColorPicker row (stays visible).
        local Picker = NewColorPicker(self, Data)
        self.Elements[#self.Elements + 1] = Picker
        return Picker
    end

    function Sections:KeyPicker(Data)
        Data = Data or { }

        -- Section = true attaches the badge to the section header itself.
        if Data.Section then
            assert(self.AttachedKeyPicker == nil, "A Section can only have one attached KeyPicker")
            local Picker = NewKeyPicker(self, Data)
            Picker.Hidden = true
            Picker.HostName = self.Name
            self.AttachedKeyPicker = Picker
            self.Elements[#self.Elements + 1] = Picker
            return Picker
        end

        local Host = Data.ToggleElement or FindPickerHost(self)
        assert(Host, "KeyPicker must be preceded by a Toggle or Label (or pass Section = true)")
        assert(Host.Type == "Toggle" or Host.Type == "Label", "KeyPicker host must be a Toggle or Label")
        return AttachKeyPicker(Host, self, Data)
    end

    function Sections:GetContentHeight()
        local TotalHeight = Library.Layout.SectionHeaderHeight
        if self.AttachedKeyPicker or #self.AttachedColorPickers > 0 then
            TotalHeight = TotalHeight + Library.Layout.SectionPickerRowHeight
        end
        for _, Element in self.Elements do
            if not Element.Hidden then
                TotalHeight = TotalHeight + Element.Height
            end
        end
        return TotalHeight + Library.Layout.SectionInnerPadding
    end

    function Sections:Render(X, Y, Width, MaxHeight)
        self.X, self.Y, self.Width = X, Y, Width

        local Padding = Library.Layout.SectionInnerPadding
        local HeaderHeight = Library.Layout.SectionHeaderHeight
        local Wanted = self:GetContentHeight()
        if type(MaxHeight) == "number" and MaxHeight > 0 then
            self.Height = MathMin(Wanted, MaxHeight)
        else
            self.Height = Wanted
        end

        if Width < 4 or self.Height < 4 then
            return
        end

        DrawRect(X, Y, Width, self.Height, Theme["Border"])
        DrawRect(X + 1, Y + 1, Width - 2, self.Height - 2, Theme["Black"])
        DrawRect(X + 2, Y + 2, Width - 4, self.Height - 4, Theme["Dark Background"])
        DrawRect(X + 2, Y + 2, Width - 4, 2, Theme["Accent"])
        DrawText(X + 5, Y + 6, Library.FontSize, Theme["White"], self.Name)

        local CursorX = X + Padding
        local CursorY = Y + HeaderHeight
        local InnerWidth = Width - Padding * 2
        local SectionRightEdge = CursorX + InnerWidth
        local ClipBottom = Y + self.Height - Padding

        if self.AttachedKeyPicker or #self.AttachedColorPickers > 0 then
            local RowH = Library.Layout.SectionPickerRowHeight
            local BadgeY = CursorY + MathFloor((RowH - 13) / 2)
            RenderAttachedPickers(self, CursorX, BadgeY, true)
            CursorY = CursorY + RowH
        end

        for _, Element in self.Elements do
            if not Element.Hidden then
                if CursorY + Element.Height > ClipBottom then
                    break
                end
                Element.X, Element.Y, Element.Width = CursorX, CursorY, InnerWidth
                Element.SectionRightEdge = SectionRightEdge
                Element:Render()
                CursorY = CursorY + Element.Height
            end
        end
    end

    -- // Pages \\ --

    local Pages = { }
    Pages.__index = Pages
    Library.Pages = Pages

    local function CreateSection(Page, Data)
        local Section = setmetatable({
            Page = Page,
            Window = Page.Window,
            Name = Data.Name or "Section",
            Side = Data.Side or 1,
            Elements = { },
            AttachedColorPickers = { },
            AttachedKeyPicker = nil,
            X = 0, Y = 0, Width = 0, Height = 0,
        }, Sections)
        Page.Sections[#Page.Sections + 1] = Section
        return Section
    end

    function Pages:Section(Data)
        return CreateSection(self, Data or { })
    end

    -- A fixed-height section whose content scrolls behind a draggable thumb.
    -- Retained drawings have no clip region, so elements that don't fully fit in
    -- the view are culled (whole-element, never partially drawn).
    function Pages:ScrollableSection(Data)
        Data = Data or { }

        local Section = setmetatable({
            Page = self,
            Window = self.Window,
            Name = Data.Name or "Section",
            Side = Data.Side or 1,
            Size = Data.Size or 175,
            Scrollable = true,
            ScrollOffset = 0,
            ScrollDragging = false,
            Elements = { },
            AttachedColorPickers = { },
            AttachedKeyPicker = nil,
            X = 0, Y = 0, Width = 0, Height = 0,
        }, Sections)

        function Section:Render(X, Y, Width, MaxHeight)
            self.X, self.Y, self.Width = X, Y, Width
            local Size = self.Size or 175
            if type(MaxHeight) == "number" and MaxHeight > 0 then
                Size = MathMin(Size, MaxHeight)
            end
            Size = MathMax(Size, Library.Layout.SectionHeaderHeight + 8)
            self.Height = Size

            if Width < 4 or Size < 4 then
                return
            end

            local Padding = Library.Layout.SectionInnerPadding
            local HeaderHeight = Library.Layout.SectionHeaderHeight

            DrawRect(X, Y, Width, Size, Theme["Border"])
            DrawRect(X + 1, Y + 1, Width - 2, Size - 2, Theme["Black"])
            DrawRect(X + 2, Y + 2, Width - 4, Size - 4, Theme["Dark Background"])
            DrawRect(X + 2, Y + 2, Width - 4, 2, Theme["Accent"])
            DrawText(X + 5, Y + 6, Library.FontSize, Theme["White"], self.Name)

            local ContentTop = Y + HeaderHeight
            local ContentBottom = Y + Size - Padding
            local ViewHeight = ContentBottom - ContentTop
            if ViewHeight < 1 then
                return
            end

            local ContentHeight = 0
            for _, Element in self.Elements do
                if not Element.Hidden then
                    ContentHeight = ContentHeight + Element.Height
                end
            end

            local MaxScroll = MathMax(0, ContentHeight - ViewHeight)
            self.ScrollOffset = MathClamp(self.ScrollOffset, 0, MaxScroll)

            local CursorX = X + Padding
            local InnerWidth = Width - Padding * 2 - (MaxScroll > 0 and 6 or 0)
            local SectionRightEdge = CursorX + InnerWidth

            -- Render visible elements; cull any whose box isn't fully in view.
            local CursorY = ContentTop - self.ScrollOffset
            for _, Element in self.Elements do
                if not Element.Hidden then
                    if CursorY >= ContentTop and CursorY + Element.Height <= ContentBottom then
                        Element.X, Element.Y, Element.Width = CursorX, CursorY, InnerWidth
                        Element.SectionRightEdge = SectionRightEdge
                        Element:Render()
                    end
                    CursorY = CursorY + Element.Height
                end
            end

            -- Scrollbar (only when there's something to scroll).
            if MaxScroll > 0 then
                local TrackX = X + Width - 5
                local TrackY = ContentTop
                local ThumbHeight = MathMax(20, MathFloor(ViewHeight * (ViewHeight / ContentHeight)))
                local ThumbY = TrackY + MathFloor((ViewHeight - ThumbHeight) * (self.ScrollOffset / MaxScroll))

                if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(TrackX - 2, TrackY, 8, ViewHeight) then
                    self.ScrollDragging = true
                    Library.Input.Consumed = true
                end
                if not Library.Input.MouseDown then self.ScrollDragging = false end
                if self.ScrollDragging then
                    -- Centre the thumb on the cursor as it's dragged.
                    local Fraction = MathClamp((Library.Input.MouseY - TrackY - ThumbHeight / 2) / MathMax(1, ViewHeight - ThumbHeight), 0, 1)
                    self.ScrollOffset = Fraction * MaxScroll
                    ThumbY = TrackY + MathFloor((ViewHeight - ThumbHeight) * Fraction)
                end

                local Hovered = self.ScrollDragging or Library:IsHovering(TrackX - 2, ThumbY, 8, ThumbHeight)
                DrawRect(TrackX, TrackY, 3, ViewHeight, Theme["Black"])
                DrawRect(TrackX, ThumbY, 3, ThumbHeight, Hovered and Theme["Accent"] or Theme["Accent"])
            end
        end

        self.Sections[#self.Sections + 1] = Section
        return Section
    end

    -- A single section frame split into N tabbed sub-sections; only the active
    -- one's elements render. Returns each sub-section so you can fill them:
    --   local A, B = Page:MultiSection({ Sections = { "A", "B" } })
    function Pages:MultiSection(Data)
        Data = Data or { }

        local Names = Data.Sections or { "Section 1", "Section 2" }

        local Multi = {
            Page = self,
            Window = self.Window,
            Side = Data.Side or 1,
            IsMultiSection = true,
            Tabs = { },
            Active = 1,
            Elements = { }, -- empty; the sub-sections below own the real elements
            X = 0, Y = 0, Width = 0, Height = 0,
        }

        -- A MultiSection supports at most 3 sub-sections.
        for Index = 1, MathMin(#Names, 3) do
            local Name = Names[Index]
            local Sub = setmetatable({
                Page = self,
                Window = self.Window,
                MultiSection = Multi,
                Name = Name,
                Elements = { },
                AttachedColorPickers = { },
                AttachedKeyPicker = nil,
                X = 0, Y = 0, Width = 0, Height = 0,
            }, Sections)

            Multi.Tabs[Index] = Sub
            -- Registered so config/keybind passes see their elements; Pages:Render
            -- skips them since the MultiSection draws their content itself.
            self.Sections[#self.Sections + 1] = Sub
        end

        function Multi:Render(X, Y, Width, MaxHeight)
            self.X, self.Y, self.Width = X, Y, Width

            local Padding = Library.Layout.SectionInnerPadding
            local TabRowHeight = 28
            local StripHeight = TabRowHeight - 4

            local ActiveSection = self.Tabs[self.Active]
            local ContentHeight = 0
            for _, Element in ActiveSection.Elements do
                if not Element.Hidden then
                    ContentHeight = ContentHeight + Element.Height
                end
            end

            self.Height = TabRowHeight + ContentHeight + Padding
            if type(MaxHeight) == "number" and MaxHeight > 0 then
                self.Height = MathMin(self.Height, MaxHeight)
            end
            if Width < 4 or self.Height < 4 then
                return
            end

            -- Frame. The content fill spans everything, so the active tab (which
            -- keeps this fill) blends straight into the panel below it.
            DrawRect(X, Y, Width, self.Height, Theme["Border"])
            DrawRect(X + 1, Y + 1, Width - 2, self.Height - 2, Theme["Black"])
            DrawRect(X + 2, Y + 2, Width - 4, self.Height - 4, Theme["Dark Background"])

            -- Tabs: side by side, tiled to fill the width exactly.
            local TabCount = #self.Tabs
            local StripBottom = Y + 2 + StripHeight
            for Index, Tab in self.Tabs do
                local TabX = X + 2 + MathFloor((Width - 4) * (Index - 1) / TabCount)
                local TabWidth = (X + 2 + MathFloor((Width - 4) * Index / TabCount)) - TabX
                local Active = (self.Active == Index)

                -- Inactive tabs sit on a lighter fill and keep a bottom divider; the
                -- active tab has neither, so it merges with the content background.
                if not Active then
                    DrawRect(TabX, Y + 2, TabWidth, StripHeight, Theme["Background"])
                    DrawRect(TabX, StripBottom - 1, TabWidth, 1, Theme["Border"])
                end

                -- Divider between adjacent tabs, but only when one of the pair is
                -- the active tab — two side-by-side inactive tabs read as one strip.
                if Index > 1 and (Active or self.Active == Index - 1) then
                    DrawRect(TabX, Y + 2, 1, StripHeight, Theme["Border"])
                end

                local Bounds = GetTextBounds(Tab.Name)
                DrawText(TabX + MathFloor((TabWidth - Bounds.X) / 2), Y + 2 + MathFloor((StripHeight - Bounds.Y) / 2),
                    Library.FontSize, Active and Theme["Accent"] or Theme["Dim"], Tab.Name)

                if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(TabX, Y + 2, TabWidth, StripHeight) then
                    Library.Input.Consumed = true
                    self.Active = Index
                end
            end

            -- Accent line across the very top, over the tab strip. Matches the 2px
            -- accent bar drawn by regular and scrollable sections.
            DrawRect(X + 2, Y + 2, Width - 4, 2, Theme["Accent"])

            -- Active sub-section's elements.
            local CursorX = X + Padding
            local CursorY = Y + TabRowHeight
            local InnerWidth = Width - Padding * 2
            local SectionRightEdge = CursorX + InnerWidth

            for _, Element in ActiveSection.Elements do
                if not Element.Hidden then
                    if CursorY + Element.Height > Y + self.Height - Padding then
                        break
                    end
                    Element.X, Element.Y, Element.Width = CursorX, CursorY, InnerWidth
                    Element.SectionRightEdge = SectionRightEdge
                    Element:Render()
                    CursorY = CursorY + Element.Height
                end
            end
        end

        self.Sections[#self.Sections + 1] = Multi
        return TableUnpack(Multi.Tabs)
    end

    function Pages:Render(X, Y, Width, Height)
        local Columns = self.Columns
        local Pad = Library.Layout.SectionPadding
        local MiddleGap = Library.Layout.SectionMiddleGap
        local ColumnWidth = MathFloor((Width - Pad * 2 - (Columns - 1) * MiddleGap) / Columns)
        if ColumnWidth < 8 then
            return
        end

        local PageBottom = Y + (Height or 0)
        if not Height or Height <= 0 then
            PageBottom = Y + 10000
        end

        local ColumnCursorY = { }
        for Col = 1, Columns do
            ColumnCursorY[Col] = Y + Pad
        end

        for _, Section in self.Sections do
            if not Section.MultiSection then
                local Col = MathClamp(Section.Side or 1, 1, Columns)
                local ColX = X + Pad + (Col - 1) * (ColumnWidth + MiddleGap)
                local SecY = ColumnCursorY[Col]
                local Remain = PageBottom - Pad - SecY
                if Remain >= 20 then
                    Section:Render(ColX, SecY, ColumnWidth, Remain)
                    ColumnCursorY[Col] = SecY + (Section.Height or 0) + Library.Layout.SectionGap
                end
            end
        end
    end

    -- // Windows \\ --

    local WindowClass = { }
    WindowClass.__index = WindowClass

    local function CreatePage(Window, Data)
        local Page = setmetatable({
            Window = Window,
            Name = Data.Name or "Page",
            Columns = Data.Columns or 1,
            Sections = { },
        }, Pages)
        Window.Pages[#Window.Pages + 1] = Page
        return Page
    end

    function WindowClass:Page(Data)
        return CreatePage(self, Data or { })
    end

    function WindowClass:Notify(Text, Duration)
        TableInsert(self.Notifications, { Text = Text, Start = tick(), Duration = Duration or 3 })
    end

    function WindowClass:BindKey(Name, Code, Element)
        self.Keybinds[#self.Keybinds + 1] = { Key = Name, Code = Code, Element = Element, Name = Element.Name }
        self.KeybindAnimations[Name] = { X = 120, Alpha = 0 }
    end

    function WindowClass:RenderKeybindList()
        if not self.KeybindListVisible then return end

        local ActivePickers = { }
        for _, Page in self.Pages do
            for _, Section in Page.Sections do
                for _, Element in Section.Elements do
                    if Element.Type == "KeyPicker" and Element.BoundKey and Element.BoundKey ~= "None" then
                        ActivePickers[#ActivePickers + 1] = Element
                    end
                end
            end
        end

        if #ActivePickers == 0 then return end

        if not self.KeybindWindow then
            self.KeybindWindow = {
                X = 10,
                Y = Library.Viewport.Y / 2 - (#ActivePickers * 24 + 52) / 2,
                Width = 185,
                Dragging = false,
                DragOffsetX = 0,
                DragOffsetY = 0,
            }
        end

        local KW = self.KeybindWindow
        local RowH = 22
        local HeaderH = 28
        local Padding = 8
        local TotalH = HeaderH + #ActivePickers * RowH + Padding

        if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(KW.X, KW.Y, KW.Width, HeaderH) then
            KW.Dragging = true
            KW.DragOffsetX = Library.Input.MouseX - KW.X
            KW.DragOffsetY = Library.Input.MouseY - KW.Y
            Library.Input.Consumed = true
        end
        if not Library.Input.MouseDown then KW.Dragging = false end
        if KW.Dragging then
            KW.X = Library.Input.MouseX - KW.DragOffsetX
            KW.Y = Library.Input.MouseY - KW.DragOffsetY
        end

        local X, Y, W = KW.X, KW.Y, KW.Width

        DrawBox(X, Y, W, TotalH, Theme["Black"], Theme["Border"], Theme["Background"])
        DrawRect(X + 2, Y + 2, W - 4, 2, Theme["Accent"])
        local HeaderBounds = GetTextBounds("Keybinds")
        DrawText(X + MathFloor((W - HeaderBounds.X) / 2), Y + 8, Library.FontSize, Theme["White"], "Keybinds")

        local CX = X + 4
        local CY = Y + HeaderH
        local CW = W - 8

        DrawRect(CX, CY, CW, TotalH - HeaderH - Padding, Theme["Border"])
        DrawRect(CX + 1, CY + 1, CW - 2, TotalH - HeaderH - Padding - 2, Theme["Dark Background"])

        for Index, Keypicker in ActivePickers do
            local TE = Keypicker.ToggleElement
            local State = (TE and TE.Value) or Keypicker.ToggledState or false
            local DisplayName = (TE and TE.Name) or Keypicker.HostName or Keypicker.Name or "Keybind"
            local RowY = CY + (Index - 1) * RowH + 2

            DrawText(CX + 6, RowY + 5, Library.FontSize, State and Theme["White"] or Theme["Dim"], DisplayName)

            local KeyLabel = "[" .. Library:FormatInput(Keypicker.BoundKey) .. "]"
            local Bounds = GetTextBounds(KeyLabel)
            DrawText(CX + CW - Bounds.X - 6, RowY + 5, Library.FontSize, Theme["Accent"], KeyLabel)

            if Index < #ActivePickers then
                DrawRect(CX + 2, RowY + RowH - 1, CW - 4, 1, Theme["Border"], 0.5)
            end
        end
    end

    function WindowClass:RenderNotifications()
        local BaseHeight = 24
        local Padding = 6
        local ToRemove = { }
        local ScreenW = Library.Viewport.X

        for Index, N in self.Notifications do
            local Elapsed = tick() - N.Start
            local Duration = N.Duration

            if Elapsed >= Duration then
                TableInsert(ToRemove, Index)
            else
                local Bounds = GetTextBounds(N.Text)
                local NW = Bounds.X + Padding * 2
                local NH = MathMax(BaseHeight, Bounds.Y + Padding * 2)
                local BaseX = ScreenW - NW - 10
                local Y = 10 + (Index - 1) * (NH + 6)

                local OffsetX = 0
                local FadeIn = 0.4
                local FadeOut = 0.4

                if Elapsed < FadeIn then
                    local T = Elapsed / FadeIn
                    local Ease = T < 0.5 and 2 * T * T or -1 + (4 - 2 * T) * T
                    OffsetX = (1 - Ease) * (NW + 10)
                elseif Elapsed > Duration - FadeOut then
                    local T = (Elapsed - (Duration - FadeOut)) / FadeOut
                    local Ease = T < 0.5 and 2 * T * T or -1 + (4 - 2 * T) * T
                    OffsetX = Ease * (NW + 10)
                end

                local X = BaseX + OffsetX

                DrawRect(X, Y, NW, NH, Theme["Black"], 0.9)
                DrawRect(X, Y, NW, 2, Theme["Accent"])
                DrawText(X + Padding, Y + Padding - 1, Library.FontSize, Theme["White"], N.Text)
            end
        end

        for Index = #ToRemove, 1, -1 do
            TableRemove(self.Notifications, ToRemove[Index])
        end
    end

    -- PowerPoint-style soft snapping. Given the raw dragged position, nudge each of
    -- the window's edges/centre onto a nearby edge/centre of another visible window
    -- or the screen (within SnapDist), and record 1px guide rects for the render loop
    -- to draw. Movement stays free: outside the threshold nothing is altered, and
    -- holding Alt (or clearing Library.WindowSnapping) disables it entirely.
    local function ComputeWindowSnap(Window, ProposedX, ProposedY)
        Library.SnapGuides = nil

        if Library.WindowSnapping == false then
            return ProposedX, ProposedY
        end

        local Pressed = getpressedkeys() or { }
        if TableFind(Pressed, "LeftAlt") or TableFind(Pressed, "RightAlt") then
            return ProposedX, ProposedY
        end

        local SnapDist = 8 * Library.DPIScale
        local W, H = Window.Width, Window.Height

        local DragXs = { ProposedX, ProposedX + W / 2, ProposedX + W }
        local DragYs = { ProposedY, ProposedY + H / 2, ProposedY + H }

        local BestX, BestXDelta, GuideX, GuideXTarget = SnapDist + 1, 0, nil, nil
        local BestY, BestYDelta, GuideY, GuideYTarget = SnapDist + 1, 0, nil, nil

        local function Consider(TXs, TYs, T)
            for _, DX in DragXs do
                for _, TX in TXs do
                    local Dist = math.abs(TX - DX)
                    if Dist < BestX then
                        BestX, BestXDelta, GuideX, GuideXTarget = Dist, TX - DX, TX, T
                    end
                end
            end
            for _, DY in DragYs do
                for _, TY in TYs do
                    local Dist = math.abs(TY - DY)
                    if Dist < BestY then
                        BestY, BestYDelta, GuideY, GuideYTarget = Dist, TY - DY, TY, T
                    end
                end
            end
        end

        for _, Other in Library.Windows do
            if Other ~= Window and Other.Visible then
                Consider(
                    { Other.X, Other.X + Other.Width / 2, Other.X + Other.Width },
                    { Other.Y, Other.Y + Other.Height / 2, Other.Y + Other.Height },
                    { Left = Other.X, Right = Other.X + Other.Width, Top = Other.Y, Bottom = Other.Y + Other.Height }
                )
            end
        end

        -- Screen edges + centre.
        local VX, VY = Library.Viewport.X, Library.Viewport.Y
        Consider(
            { 0, VX / 2, VX },
            { 0, VY / 2, VY },
            { Left = 0, Right = VX, Top = 0, Bottom = VY }
        )

        local FinalX = GuideX and (ProposedX + BestXDelta) or ProposedX
        local FinalY = GuideY and (ProposedY + BestYDelta) or ProposedY

        if GuideX or GuideY then
            local Guides = { }
            if GuideX then
                -- Vertical guide, spanning both the window and the aligned target.
                local Top = MathMin(FinalY, GuideXTarget.Top)
                local Bottom = MathMax(FinalY + H, GuideXTarget.Bottom)
                Guides[#Guides + 1] = { GuideX, Top, 1, Bottom - Top }
            end
            if GuideY then
                -- Horizontal guide.
                local Left = MathMin(FinalX, GuideYTarget.Left)
                local Right = MathMax(FinalX + W, GuideYTarget.Right)
                Guides[#Guides + 1] = { Left, GuideY, Right - Left, 1 }
            end
            Library.SnapGuides = Guides
        end

        return FinalX, FinalY
    end

    function WindowClass:Render()
        -- Consume clicks that land inside an open colorpicker window.
        if Library.ActiveColorPicker and Library.ActiveColorPicker.LastRect and Library.Input.MouseClicked then
            local Rect = Library.ActiveColorPicker.LastRect
            if Library:IsHovering(Rect[1], Rect[2], Rect[3], Rect[4]) then
                Library.Input.Consumed = true
            end
        end

        -- Close an open dropdown if the click lands outside it.
        if Library.LastDropdownRect and Library.ActiveDropdown and Library.ActiveDropdown.Open and Library.Input.MouseClicked then
            local Rect = Library.LastDropdownRect
            if Library:IsHovering(Rect[1], Rect[2], Rect[3], Rect[4]) then
                Library.Input.Consumed = true
            elseif not Library:IsHovering(Rect[5], Rect[6], Rect[7], Rect[8]) then
                Library.ActiveDropdown.Open = false
                Library.ActiveDropdown = nil
            end
        end

        local X, Y = self.X, self.Y

        -- X close button, checked before drag so the header click isn't consumed first.
        local CloseX = X + self.Width - 22
        if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(CloseX, Y + 4, 16, 16) then
            Library.Input.Consumed = true
            self.Visible = false
            return
        end

        if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X, Y, self.Width - 24, 26) then
            self.Dragging = true
            self.DragOffsetX = Library.Input.MouseX - X
            self.DragOffsetY = Library.Input.MouseY - Y
            Library.Input.Consumed = true
        end
        if not Library.Input.MouseDown then self.Dragging = false end
        if self.Dragging then
            local ProposedX = Library.Input.MouseX - self.DragOffsetX
            local ProposedY = Library.Input.MouseY - self.DragOffsetY
            self.X, self.Y = ComputeWindowSnap(self, ProposedX, ProposedY)
            X, Y = self.X, self.Y
        end

        DrawBox(X, Y, self.Width, self.Height, Theme["Black"], Theme["Accent"], Theme["Background"])
        DrawText(X + 9, Y + 8, Library.FontSize, Theme["White"], self.Name)

        local CloseHovered = Library:IsHovering(CloseX, Y + 4, 16, 16)
        DrawRect(CloseX, Y + 4, 16, 16, Theme["Background"])
        DrawText(CloseX + 4, Y + 5, Library.FontSize, CloseHovered and Theme["Accent"] or Theme["White"], "X")

        local CX, CY = X + 9, Y + 26
        local CW, CH = self.Width - 18, self.Height - 35
        DrawRect(CX, CY, CW, CH, Theme["Border"])
        DrawRect(CX + 1, CY + 1, CW - 2, CH - 2, Theme["Black"])
        DrawRect(CX + 2, CY + 2, CW - 4, CH - 4, Theme["Dark Background"])

        local NumTabs = #self.Pages

        if self.IsSubWindow then
            local IX, IY = CX + 7, CY + 4
            local IW, IH = CW - 14, CH - 11
            DrawRect(IX, IY, IW, IH, Theme["Border"])
            DrawRect(IX + 1, IY + 1, IW - 2, IH - 2, Theme["Background"])
            local CurrentPage = self.Pages[self.CurrentPageIndex]
            if CurrentPage then
                CurrentPage:Render(IX, IY, IW, IH)
            end
        else
            local TabGap = 2
            local TotalGaps = (NumTabs - 1) * TabGap
            local TotalTabWidth = CW - 14
            local TabWidth = MathFloor((TotalTabWidth - TotalGaps) / NumTabs)
            local TabY = CY + 4

            for Index, Page in self.Pages do
                local TabX = CX + 7 + (Index - 1) * (TabWidth + TabGap)
                local IsActive = (self.CurrentPageIndex == Index)

                DrawRect(TabX, TabY, TabWidth, 23, Theme["Border"])
                DrawRect(TabX + 1, TabY + 1, TabWidth - 2, IsActive and 22 or 21, IsActive and Theme["Background"] or Theme["Dark Background"])
                if IsActive then
                    DrawRect(TabX, TabY + 22, TabWidth, 9, Theme["Border"])
                    DrawRect(TabX + 1, TabY + 22, TabWidth - 2, 9, Theme["Background"])
                end

                local Bounds = GetTextBounds(Page.Name)
                DrawText(TabX + MathFloor((TabWidth - Bounds.X) / 2), TabY + 5, Library.FontSize,
                    IsActive and Theme["White"] or Theme["Dim"], Page.Name)

                if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(TabX, TabY, TabWidth, 23) then
                    Library.Input.Consumed = true
                    self.CurrentPageIndex = Index
                    if Library.ActiveDropdown then Library.ActiveDropdown.Open = false end
                    Library.ActiveDropdown = nil
                    Library.ActiveColorPicker = nil
                    Library.KeyPickerContext = nil
                    Library.Input.FocusedTextbox = nil
                end
            end

            local IX, IY = CX + 7, CY + 30
            local IW, IH = CW - 14, CH - 37
            local ActiveTabX = IX + (self.CurrentPageIndex - 1) * (TabWidth + TabGap)

            DrawRect(IX, IY, IW, IH, Theme["Border"])
            DrawRect(IX + 1, IY + 1, IW - 2, IH - 2, Theme["Background"])
            DrawRect(ActiveTabX, IY, TabWidth, 1, Theme["Background"])

            local CurrentPage = self.Pages[self.CurrentPageIndex]
            if CurrentPage then
                CurrentPage:Render(IX, IY, IW, IH)
            end
        end

        -- Dropdown overlay (drawn above everything else on this window).
        if Library.DropdownOverlay then
            local Overlay = Library.DropdownOverlay
            local Element = Overlay.Element
            local OX, OY, OW = Overlay.X, Overlay.Y, Overlay.Width

            -- Cap the list at 8 rows; anything beyond that scrolls (whole rows).
            local RowH = 20
            local OptionCount = #Element.Options
            local VisibleRows = MathMin(OptionCount, 8)
            local ViewHeight = VisibleRows * RowH
            local OverflowRows = OptionCount - VisibleRows
            local Scrollable = OverflowRows > 0

            Element.DropScrollRow = MathClamp(Element.DropScrollRow or 0, 0, OverflowRows)

            Library.LastDropdownRect = {
                OX, OY, OW, ViewHeight,
                OX, OY - 22, OW, 22 + ViewHeight,
            }

            -- Bordered panel: outline -> border -> background.
            DrawRect(OX, OY, OW, ViewHeight, Theme["Black"])
            DrawRect(OX + 1, OY + 1, OW - 2, ViewHeight - 2, Theme["Border"])
            DrawRect(OX + 2, OY + 2, OW - 4, ViewHeight - 4, Theme["Background"])

            local RowW = OW - (Scrollable and 7 or 0)

            for Slot = 0, VisibleRows - 1 do
                local Index = Element.DropScrollRow + Slot + 1
                local Option = Element.Options[Index]
                if Option then
                    local OptionY = OY + Slot * RowH
                    local Hovered = Library:IsHovering(OX, OptionY, RowW, RowH)
                    local Selected = Element.Multi
                        and (Element.SelectedIndices[Index] == true)
                        or (not Element.Multi and Index == Element.SelectedIndex)

                    if Hovered then
                        DrawRect(OX + 2, OptionY + 1, RowW - 4, RowH - 2, Theme["Border"])
                    end
                    if Selected or Hovered then
                        DrawRect(OX + 2, OptionY + 2, 2, RowH - 4, Theme["Accent"])
                    end
                    DrawText(OX + 7, OptionY + 3, Library.FontSize, Selected and Theme["Accent"] or Theme["White"], Option)

                    if Library.Input.MouseClicked and Hovered then
                        Library.Input.Consumed = true
                        if Element.Multi then
                            Element.SelectedIndices[Index] = not Element.SelectedIndices[Index] or nil
                            Element:SyncFlag()
                            local Valid = { }
                            for I, Sel in Element.SelectedIndices do
                                if Sel then Valid[#Valid + 1] = Element.Options[I] end
                            end
                            TableSort(Valid)
                            Element.Callback(Valid)
                        else
                            Element.SelectedIndex = Index
                            Element.Open = false
                            Library.ActiveDropdown = nil
                            Element:SyncFlag()
                            Element.Callback(Element.Options[Index])
                        end
                    end
                end
            end

            -- Scrollbar (same draggable thumb as ScrollableSection, stepped by row).
            if Scrollable then
                local TrackX = OX + OW - 5
                local TrackY = OY + 2
                local TrackH = ViewHeight - 4
                local ThumbH = MathMax(16, MathFloor(TrackH * VisibleRows / OptionCount))
                local ThumbY = TrackY + MathFloor((TrackH - ThumbH) * (Element.DropScrollRow / OverflowRows))

                -- No `not Consumed` guard: the dropdown's outside-click check at the top
                -- of Window:Render already consumes clicks inside the panel, so the thumb
                -- claims the grab on MouseClicked + hover (the option rows do the same).
                if Library.Input.MouseClicked and Library:IsHovering(TrackX - 2, TrackY, 8, TrackH) then
                    Element.DropScrollDragging = true
                    Library.Input.Consumed = true
                end
                if not Library.Input.MouseDown then Element.DropScrollDragging = false end
                if Element.DropScrollDragging then
                    local Fraction = MathClamp((Library.Input.MouseY - TrackY - ThumbH / 2) / MathMax(1, TrackH - ThumbH), 0, 1)
                    Element.DropScrollRow = MathFloor(Fraction * OverflowRows + 0.5)
                    ThumbY = TrackY + MathFloor((TrackH - ThumbH) * (Element.DropScrollRow / OverflowRows))
                end

                local ThumbHovered = Element.DropScrollDragging or Library:IsHovering(TrackX - 2, ThumbY, 8, ThumbH)
                DrawRect(TrackX, TrackY, 3, TrackH, Theme["Black"])
                DrawRect(TrackX, ThumbY, 3, ThumbH, ThumbHovered and Theme["Accent"] or Theme["Border"])
            end
        end

        -- KeyPicker right-click context menu (Toggle / Hold mode).
        if Library.KeyPickerContext then
            local Keypicker = Library.KeyPickerContext.Element
            local MX = Library.KeyPickerContext.X
            local MY = Library.KeyPickerContext.Y
            local MenuW = 90
            local Modes = { "Toggle", "Hold" }
            local MenuH = 4 + #Modes * 22 + 4

            DrawBox(MX, MY, MenuW, MenuH, Theme["Black"], Theme["Border"], Theme["Dark Background"])
            DrawRect(MX + 2, MY + 2, MenuW - 4, 2, Theme["Accent"])

            for Index, Mode in Modes do
                local OptionY = MY + 4 + (Index - 1) * 22
                local Hovered = Library:IsHovering(MX + 4, OptionY, MenuW - 8, 20)
                local Active = (Keypicker.Mode == Mode)

                DrawRect(MX + 4, OptionY, MenuW - 8, 20, Theme["Black"])
                DrawRect(MX + 5, OptionY + 1, MenuW - 10, 18, Hovered and Theme["Border"] or Theme["Background"])

                DrawBox(MX + 8, OptionY + 4, 11, 11,
                    Theme["Black"],
                    Active and Theme["Accent"] or Theme["Border"],
                    Active and Theme["Accent"] or Theme["Dark Background"])

                DrawText(MX + 23, OptionY + 3, Library.FontSize, Active and Theme["White"] or Theme["Dim"], Mode)

                if Library.Input.MouseClicked and Hovered then
                    Keypicker.Mode = Mode
                    Keypicker.ContextOpen = false
                    Library.KeyPickerContext = nil
                    Library.Input.Consumed = true
                    Keypicker:SyncFlag()
                end
            end

            if Library.Input.MouseClicked and not Library.Input.Consumed then
                Keypicker.ContextOpen = false
                Library.KeyPickerContext = nil
            end
        end

        Library:RenderColorPicker()

        if Library.Input.MouseClicked and Library.ActiveDropdown and Library.ActiveDropdown.Open and not Library.Input.Consumed then
            Library.ActiveDropdown.Open = false
            Library.ActiveDropdown = nil
        end
    end

    function Library:Window(Data)
        Data = Data or { }

        local Window = setmetatable({
            Name = Data.Name or "Window",
            Width = (Data.Size and Data.Size.X) or 550,
            Height = (Data.Size and Data.Size.Y) or 600,
            Pages = { },
            CurrentPageIndex = 1,
            Visible = true,
            Dragging = false,
            DragOffsetX = 0,
            DragOffsetY = 0,
            PreviousToggleState = false,
            Keybinds = { },
            KeybindAnimations = { },
            KeybindPreviousStates = { },
            KeybindListVisible = true,
            Notifications = { },
            MenuToggleKey = "RightShift",
        }, WindowClass)

        if Data.Position then
            Window.X = Data.Position.X
            Window.Y = Data.Position.Y
        else
            Window.X = Library.Viewport.X / 2 - Window.Width / 2
            Window.Y = Library.Viewport.Y / 2 - Window.Height / 2
        end

        Library.Windows[#Library.Windows + 1] = Window

        RunService.PostLocal:Connect(function()
            local PressedKeys = getpressedkeys() or { }
            local function IsKeyPressed(Target) return TableFind(PressedKeys, Target) ~= nil end

            if Library.CapturingKeyPicker then
                local Keypicker = Library.CapturingKeyPicker
                if IsKeyPressed("Escape") then
                    Keypicker.Capturing = false
                    Library.CapturingKeyPicker = nil
                else
                    if tick() - Keypicker.CapturingTime >= 0.4 then
                        for _, Key in PressedKeys do
                            if Key ~= "LeftButton" and Key ~= "RightButton" and Key ~= "MB1" and Key ~= "MB2" and Key ~= "" and Key ~= "Escape" then
                                Keypicker.BoundKey = Key
                                Keypicker.Capturing = false
                                Keypicker:SyncFlag()
                                Library.CapturingKeyPicker = nil
                                break
                            end
                        end
                    end
                end
            end

            for _, Keybind in Window.Keybinds do
                if IsKeyPressed(Keybind.Code) then
                    if not (Window.KeybindPreviousStates[Keybind.Key] or false) then
                        if Keybind.Element.Type == "Toggle" then
                            Keybind.Element.Value = not Keybind.Element.Value
                            Keybind.Element:SyncFlag()
                            Keybind.Element.Callback(Keybind.Element.Value)
                        end
                        Window.KeybindPreviousStates[Keybind.Key] = true
                    end
                else
                    Window.KeybindPreviousStates[Keybind.Key] = nil
                end
            end

            for _, Keypicker in Library.Input.ActiveKeyPickers do
                if Keypicker.BoundKey ~= "None" then
                    local TE = Keypicker.ToggleElement
                    local KeyIsActive = IsKeyPressed(Keypicker.BoundKey)

                    if Keypicker.Mode == "Toggle" then
                        if KeyIsActive and not (Keypicker.PrevPressed or false) then
                            if TE then
                                if Keypicker.HasCallback then
                                    Keypicker.Callback(not TE.Value)
                                else
                                    TE.Value = not TE.Value
                                    TE:SyncFlag()
                                    TE.Callback(TE.Value)
                                end
                            else
                                Keypicker.ToggledState = not (Keypicker.ToggledState or false)
                                if Keypicker.HasCallback then
                                    Keypicker.Callback(Keypicker.ToggledState)
                                end
                            end
                            Keypicker.PrevPressed = true
                        elseif not KeyIsActive then
                            Keypicker.PrevPressed = false
                        end

                    elseif Keypicker.Mode == "Hold" then
                        if TE then
                            if Keypicker.HasCallback then
                                Keypicker.Callback(KeyIsActive)
                            elseif TE.Value ~= KeyIsActive then
                                TE.Value = KeyIsActive
                                TE:SyncFlag()
                                TE.Callback(TE.Value)
                            end
                        elseif Keypicker.HasCallback then
                            Keypicker.Callback(KeyIsActive)
                        end
                    end
                end
            end
        end)

        return Window
    end

    -- // Color Picker Window \\ --

    function Library:ToggleColorPickerWindow(ColorPicker, SpawnX, SpawnY)
        if self.ActiveColorPicker == ColorPicker then
            self.ActiveColorPicker = nil
            return
        end

        self.ActiveColorPicker = ColorPicker
        ColorPicker.WindowX = SpawnX
        ColorPicker.WindowY = SpawnY

        -- Layout constants mirrored exactly by RenderColorPicker.
        local TitleH = 18
        local WinPad = 6
        local ContPad = 5
        local SVSize = 150
        local HueBarGap = 5
        local HueBarW = 14
        local AlphaBarH = 14
        local AlphaBarGap = 6
        local ButtonH = 16
        local ButtonGap = 6

        local TotalContentW = SVSize + HueBarGap + HueBarW
        local ContW = ContPad + TotalContentW + ContPad
        local ContH = ContPad + SVSize + AlphaBarGap + AlphaBarH + ButtonGap + ButtonH + ContPad

        ColorPicker.WindowWidth = WinPad + ContW + WinPad
        ColorPicker.WindowHeight = TitleH + WinPad + ContH + WinPad

        local H, S, V = self:RGBToHSV(ColorPicker.Color[1], ColorPicker.Color[2], ColorPicker.Color[3])
        ColorPicker.Hue = H
        ColorPicker.Saturation = S
        ColorPicker.Value = V
    end

    function Library:RenderColorPicker()
        local Picker = self.ActiveColorPicker
        if not Picker then return end

        local WX, WY = Picker.WindowX, Picker.WindowY
        local WW, WH = Picker.WindowWidth, Picker.WindowHeight

        local CloseX = WX + WW - 22
        if self.Input.MouseClicked and self:IsHovering(CloseX, WY + 4, 16, 16) then
            self.ActiveColorPicker = nil
            return
        end
        if self.Input.MouseClicked and self:IsHovering(WX, WY, WW - 24, 22) then
            Picker.WindowDragging = true
            Picker.WindowDragOffsetX = self.Input.MouseX - WX
            Picker.WindowDragOffsetY = self.Input.MouseY - WY
        end
        if not self.Input.MouseDown then Picker.WindowDragging = false end
        if Picker.WindowDragging then
            Picker.WindowX = self.Input.MouseX - Picker.WindowDragOffsetX
            Picker.WindowY = self.Input.MouseY - Picker.WindowDragOffsetY
            WX, WY = Picker.WindowX, Picker.WindowY
        end

        Picker.LastRect = { WX, WY, WW, WH }

        DrawBox(WX, WY, WW, WH, Theme["Black"], Theme["Accent"], Theme["Background"])
        DrawText(WX + 8, WY + 6, Library.FontSize, Theme["White"], Picker.Name .. " Color")

        local CloseHovered = self:IsHovering(CloseX, WY + 4, 16, 16)
        DrawRect(CloseX, WY + 4, 16, 16, Theme["Background"])
        DrawText(CloseX + 4, WY + 5, Library.FontSize, CloseHovered and Theme["Accent"] or Theme["White"], "X")

        local TitleH = 18
        local WinPad = 6
        local ContPad = 5
        local SVSize = 150
        local HueBarGap = 5
        local HueBarW = 14
        local AlphaBarH = 14
        local AlphaBarGap = 6
        local ButtonH = 16
        local ButtonGap = 6
        local SwatchSize = AlphaBarH
        local SwatchGap = 5
        local TotalContentW = SVSize + HueBarGap + HueBarW
        local AlphaW = TotalContentW - SwatchGap - SwatchSize
        local ContW = ContPad + TotalContentW + ContPad
        local ContH = ContPad + SVSize + AlphaBarGap + AlphaBarH + ButtonGap + ButtonH + ContPad
        local SVSteps = 24

        local ContX = WX + WinPad
        local ContY = WY + TitleH + WinPad
        DrawBox(ContX, ContY, ContW, ContH, Theme["Black"], Theme["Border"], Theme["Background"])

        local CX = ContX + ContPad
        local CY = ContY + ContPad

        -- Saturation / Value square. Cell colours are cached per hue: HSVToRGB only
        -- re-runs when the hue changes, so dragging Saturation/Value (or idling)
        -- just redraws the cached grid instead of recomputing every cell each frame.
        local SVX, SVY = CX, CY
        local CellW = SVSize / SVSteps
        local CellH = SVSize / SVSteps

        if Picker.SVCacheHue ~= Picker.Hue then
            Picker.SVCacheHue = Picker.Hue
            local Cache = Picker.SVCache or { }
            Picker.SVCache = Cache
            for ColumnIndex = 0, SVSteps - 1 do
                local Column = Cache[ColumnIndex + 1] or { }
                Cache[ColumnIndex + 1] = Column
                local S = ColumnIndex / (SVSteps - 1)
                for RowIndex = 0, SVSteps - 1 do
                    local R, G, B = self:HSVToRGB(Picker.Hue, S, 1 - RowIndex / (SVSteps - 1))
                    Column[RowIndex + 1] = FromRGB(R, G, B)
                end
            end
        end

        DrawRect(SVX - 1, SVY - 1, SVSize + 2, SVSize + 2, Theme["Black"])
        for ColumnIndex = 0, SVSteps - 1 do
            local Column = Picker.SVCache[ColumnIndex + 1]
            local CellX = SVX + ColumnIndex * CellW
            for RowIndex = 0, SVSteps - 1 do
                DrawRect(CellX, SVY + RowIndex * CellH, CellW + 1, CellH + 1, Column[RowIndex + 1])
            end
        end

        local CursorX = SVX + MathFloor(Picker.Saturation * (SVSize - 1))
        local CursorY = SVY + MathFloor((1 - Picker.Value) * (SVSize - 1))
        DrawRect(CursorX - 4, CursorY - 4, 9, 9, Theme["White"])
        DrawRect(CursorX - 3, CursorY - 3, 7, 7, Theme["Black"])
        DrawRect(CursorX - 2, CursorY - 2, 5, 5, FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]))

        if self.Input.MouseClicked and self:IsHovering(SVX, SVY, SVSize, SVSize) then
            Picker.DraggingSV = true
        end
        if Picker.DraggingSV and self.Input.MouseDown then
            Picker.Saturation = MathClamp((self.Input.MouseX - SVX) / SVSize, 0, 1)
            Picker.Value = MathClamp(1 - (self.Input.MouseY - SVY) / SVSize, 0, 1)
            Picker.Color[1], Picker.Color[2], Picker.Color[3] = self:HSVToRGB(Picker.Hue, Picker.Saturation, Picker.Value)
            Picker:SyncFlag()
            Picker.Callback(FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]))
        end
        if not self.Input.MouseDown then Picker.DraggingSV = false end

        -- Hue bar. The gradient is fixed (hue 0..1 at full S/V), so it's built once
        -- for the session and just redrawn each frame instead of recomputed.
        local HueX = SVX + SVSize + HueBarGap
        local HueY = SVY
        local HueStep = 2

        if not Library.HueBarCache then
            local Cache = { }
            for Step = 0, SVSize - 1, HueStep do
                local R, G, B = self:HSVToRGB(Step / SVSize, 1, 1)
                Cache[#Cache + 1] = FromRGB(R, G, B)
            end
            Library.HueBarCache = Cache
        end

        DrawRect(HueX - 1, HueY - 1, HueBarW + 2, SVSize + 2, Theme["Black"])
        for Index, Color in Library.HueBarCache do
            DrawRect(HueX, HueY + (Index - 1) * HueStep, HueBarW, HueStep, Color)
        end

        local HueCursorY = HueY + MathFloor(Picker.Hue * (SVSize - 1))
        DrawRect(HueX - 2, HueCursorY - 2, HueBarW + 4, 5, Theme["White"])
        DrawRect(HueX - 1, HueCursorY - 1, HueBarW + 2, 3, Theme["Black"])

        if self.Input.MouseClicked and self:IsHovering(HueX - 2, HueY - 2, HueBarW + 4, SVSize + 4) then
            Picker.DraggingHue = true
        end
        if Picker.DraggingHue and self.Input.MouseDown then
            Picker.Hue = MathClamp((self.Input.MouseY - HueY) / SVSize, 0, 0.999)
            Picker.Color[1], Picker.Color[2], Picker.Color[3] = self:HSVToRGB(Picker.Hue, Picker.Saturation, Picker.Value)
            Picker:SyncFlag()
            Picker.Callback(FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]))
        end
        if not self.Input.MouseDown then Picker.DraggingHue = false end

        -- Alpha bar + preview swatch (together they span the full content width).
        local AlphaX = CX
        local AlphaY = SVY + SVSize + AlphaBarGap

        local CheckStep = 7
        for AX = 0, AlphaW - 1, CheckStep do
            local Dark = (MathFloor(AX / CheckStep) % 2 == 0)
            local ChunkW = MathMin(CheckStep, AlphaW - AX)
            DrawRect(AlphaX + AX, AlphaY, ChunkW, AlphaBarH / 2, Dark and FromRGB(100, 100, 100) or FromRGB(160, 160, 160))
            DrawRect(AlphaX + AX, AlphaY + AlphaBarH / 2, ChunkW, AlphaBarH / 2, Dark and FromRGB(160, 160, 160) or FromRGB(100, 100, 100))
        end

        -- Gapless, non-overlapping tiles (each edge snaps to the next tile's start) so
        -- the semi-transparent steps don't double-blend into vertical seams.
        local Steps = 48
        local AlphaColor = FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3])
        for Step = 0, Steps - 1 do
            local StepX = AlphaX + MathFloor(Step * AlphaW / Steps)
            local NextX = AlphaX + MathFloor((Step + 1) * AlphaW / Steps)
            DrawRect(StepX, AlphaY, NextX - StepX, AlphaBarH, AlphaColor, (Step + 0.5) / Steps)
        end

        DrawRect(AlphaX - 1, AlphaY - 1, AlphaW + 2, 1, Theme["Black"])
        DrawRect(AlphaX - 1, AlphaY + AlphaBarH, AlphaW + 2, 1, Theme["Black"])
        DrawRect(AlphaX - 1, AlphaY - 1, 1, AlphaBarH + 2, Theme["Black"])
        DrawRect(AlphaX + AlphaW, AlphaY - 1, 1, AlphaBarH + 2, Theme["Black"])

        local AlphaCursorX = AlphaX + MathFloor(Picker.Alpha * (AlphaW - 1))
        DrawRect(AlphaCursorX - 2, AlphaY - 2, 5, AlphaBarH + 4, Theme["White"])
        DrawRect(AlphaCursorX - 1, AlphaY - 1, 3, AlphaBarH + 2, Theme["Black"])

        if self.Input.MouseClicked and self:IsHovering(AlphaX - 2, AlphaY - 2, AlphaW + 4, AlphaBarH + 4) then
            Picker.DraggingAlpha = true
        end
        if Picker.DraggingAlpha and self.Input.MouseDown then
            Picker.Alpha = MathClamp((self.Input.MouseX - AlphaX) / AlphaW, 0, 1)
            Picker:SyncFlag()
            Picker.Callback(FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]))
        end
        if not self.Input.MouseDown then Picker.DraggingAlpha = false end

        local SwatchPreviewX = AlphaX + AlphaW + SwatchGap
        local SwatchPreviewY = AlphaY

        DrawRect(SwatchPreviewX, SwatchPreviewY, SwatchSize / 2, SwatchSize / 2, FromRGB(160, 160, 160))
        DrawRect(SwatchPreviewX + SwatchSize / 2, SwatchPreviewY, SwatchSize / 2, SwatchSize / 2, FromRGB(100, 100, 100))
        DrawRect(SwatchPreviewX, SwatchPreviewY + SwatchSize / 2, SwatchSize / 2, SwatchSize / 2, FromRGB(100, 100, 100))
        DrawRect(SwatchPreviewX + SwatchSize / 2, SwatchPreviewY + SwatchSize / 2, SwatchSize / 2, SwatchSize / 2, FromRGB(160, 160, 160))

        DrawRect(SwatchPreviewX, SwatchPreviewY, SwatchSize, SwatchSize, FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]), Picker.Alpha)

        DrawRect(SwatchPreviewX - 1, SwatchPreviewY - 1, SwatchSize + 2, 1, Theme["Black"])
        DrawRect(SwatchPreviewX - 1, SwatchPreviewY + SwatchSize, SwatchSize + 2, 1, Theme["Black"])
        DrawRect(SwatchPreviewX - 1, SwatchPreviewY - 1, 1, SwatchSize + 2, Theme["Black"])
        DrawRect(SwatchPreviewX + SwatchSize, SwatchPreviewY - 1, 1, SwatchSize + 2, Theme["Black"])

        -- Copy / Paste row. Copy stores this picker's colour in a shared slot;
        -- Paste applies that slot to whichever picker is open (no system clipboard).
        local ButtonY = AlphaY + AlphaBarH + ButtonGap
        local HalfGap = 4
        local HalfW = MathFloor((TotalContentW - HalfGap) / 2)
        local PasteX = CX + HalfW + HalfGap

        local CopyHovered = self:IsHovering(CX, ButtonY, HalfW, ButtonH)
        DrawBox(CX, ButtonY, HalfW, ButtonH, Theme["Black"], Theme["Border"], CopyHovered and Theme["Dark Background"] or Theme["Background"])
        local CopyBounds = GetTextBounds("Copy")
        DrawText(CX + MathFloor((HalfW - CopyBounds.X) / 2), ButtonY + MathFloor((ButtonH - CopyBounds.Y) / 2),
            Library.FontSize, CopyHovered and Theme["Accent"] or Theme["White"], "Copy")
        if self.Input.MouseClicked and CopyHovered then
            self.Input.Consumed = true
            self.CopiedColor = { Picker.Color[1], Picker.Color[2], Picker.Color[3], Picker.Alpha }
        end

        local PasteHovered = self:IsHovering(PasteX, ButtonY, HalfW, ButtonH)
        DrawBox(PasteX, ButtonY, HalfW, ButtonH, Theme["Black"], Theme["Border"], PasteHovered and Theme["Dark Background"] or Theme["Background"])
        local PasteBounds = GetTextBounds("Paste")
        DrawText(PasteX + MathFloor((HalfW - PasteBounds.X) / 2), ButtonY + MathFloor((ButtonH - PasteBounds.Y) / 2),
            Library.FontSize, PasteHovered and Theme["Accent"] or Theme["White"], "Paste")
        if self.Input.MouseClicked and PasteHovered and self.CopiedColor then
            self.Input.Consumed = true
            Picker.Color[1], Picker.Color[2], Picker.Color[3] = self.CopiedColor[1], self.CopiedColor[2], self.CopiedColor[3]
            Picker.Alpha = self.CopiedColor[4] or Picker.Alpha
            local PH, PS, PV = self:RGBToHSV(Picker.Color[1], Picker.Color[2], Picker.Color[3])
            Picker.Hue, Picker.Saturation, Picker.Value = PH, PS, PV
            Picker:SyncFlag()
            Picker.Callback(FromRGB(Picker.Color[1], Picker.Color[2], Picker.Color[3]))
        end
    end

    -- // Config (Flags) \\ --

    function Library:ExportFlags()
        local Lines = { "return {" }
        for Flag, Value in self.Flags do
            local Type = type(Value)
            if Type == "boolean" or Type == "number" then
                Lines[#Lines + 1] = StringFormat('  ["%s"] = %s,', Flag, tostring(Value))
            elseif Type == "table" then
                local Parts = { }
                if Value.Color then
                    local Color = Value.Color
                    Parts[#Parts + 1] = StringFormat("Color = Color3.fromRGB(%d,%d,%d)",
                        MathFloor(Color.R * 255), MathFloor(Color.G * 255), MathFloor(Color.B * 255))
                end
                if Value.Alpha ~= nil then
                    Parts[#Parts + 1] = "Alpha = " .. tostring(Value.Alpha)
                end
                if Value.Value ~= nil then
                    if type(Value.Value) == "table" then
                        local Items = { }
                        for _, Item in Value.Value do
                            Items[#Items + 1] = '"' .. tostring(Item) .. '"'
                        end
                        Parts[#Parts + 1] = "Value = {" .. TableConcat(Items, ", ") .. "}"
                    else
                        Parts[#Parts + 1] = "Value = " .. (type(Value.Value) == "string" and ('"' .. Value.Value .. '"') or tostring(Value.Value))
                    end
                end
                if Value.Key ~= nil then Parts[#Parts + 1] = 'Key = "' .. tostring(Value.Key) .. '"' end
                if Value.Mode ~= nil then Parts[#Parts + 1] = 'Mode = "' .. tostring(Value.Mode) .. '"' end
                Lines[#Lines + 1] = StringFormat('  ["%s"] = {%s},', Flag, TableConcat(Parts, ", "))
            end
        end
        Lines[#Lines + 1] = "}"
        return TableConcat(Lines, "\n")
    end

    function Library:ApplyFlags(LoadedFlags)
        for _, Window in self.Windows do
            for _, Page in Window.Pages do
                for _, Section in Page.Sections do
                    for _, Element in Section.Elements do
                        if Element.Flag and LoadedFlags[Element.Flag] ~= nil then
                            local Saved = LoadedFlags[Element.Flag]

                            if Element.Type == "Toggle" then
                                Element.Value = Saved == true
                                Element:SyncFlag()
                                pcall(Element.Callback, Element.Value)

                            elseif Element.Type == "Slider" then
                                Element.Value = tonumber(Saved.Value) or Element.Value
                                Element:SyncFlag()
                                pcall(Element.Callback, Element.Value)

                            elseif Element.Type == "Dropdown" then
                                if Element.Multi then
                                    Element.SelectedIndices = { }
                                    if type(Saved.Value) == "table" then
                                        for _, SavedVal in Saved.Value do
                                            for I, Opt in Element.Options do
                                                if Opt == SavedVal then
                                                    Element.SelectedIndices[I] = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    Element:SyncFlag()
                                    local Valid = { }
                                    for I, Sel in Element.SelectedIndices do
                                        if Sel then Valid[#Valid + 1] = Element.Options[I] end
                                    end
                                    TableSort(Valid)
                                    pcall(Element.Callback, Valid)
                                else
                                    for I, Opt in Element.Options do
                                        if Opt == Saved.Value then
                                            Element.SelectedIndex = I
                                            break
                                        end
                                    end
                                    Element:SyncFlag()
                                    pcall(Element.Callback, Element.Options[Element.SelectedIndex])
                                end

                            elseif Element.Type == "ColorPicker" then
                                if Saved.Color then
                                    Element.Color = { Saved.Color.R * 255, Saved.Color.G * 255, Saved.Color.B * 255 }
                                end
                                if Saved.Alpha ~= nil then
                                    Element.Alpha = Saved.Alpha
                                end
                                Element:SyncFlag()
                                pcall(Element.Callback, FromRGB(Element.Color[1], Element.Color[2], Element.Color[3]))

                            elseif Element.Type == "KeyPicker" then
                                if Saved.Key then Element.BoundKey = Saved.Key end
                                if Saved.Mode then Element.Mode = Saved.Mode end
                                Element:SyncFlag()
                            end
                        end
                    end
                end
            end
        end
    end

    -- // Style Window \\ --

    function Library:StyleWindow()
        assert(#self.Windows > 0, "No windows exist")
        local MainWin = self.Windows[1]

        local StyleWindow = Library:Window({
            Name = "Style",
            Size = Vector2New(300, 420),
            Position = Vector2New(MainWin.X + MainWin.Width + 8, MainWin.Y),
        })
        StyleWindow.Visible = false
        StyleWindow.MenuToggleKey = ""
        StyleWindow.IsSubWindow = true

        local StylePage = StyleWindow:Page({ Name = "Style", Columns = 1 })
        local StyleSection = StylePage:Section({ Name = "Theme", Side = 1 })

        local ThemeKeys = { "Accent", "Background", "Dark Background", "Border" }
        local ThemePickers = { }
        for _, Key in ThemeKeys do
            ThemePickers[Key] = StyleSection:ColorPicker({
                Name = Key,
                Flag = "Theme_" .. Key,
                Default = self.Theme[Key],
                Alpha = 1,
                Callback = function(Color)
                    Library.Theme[Key] = Color
                end,
            })
        end

        StyleSection:Separator()

        local Presets = {
            { Name = "Default", Colors = {
                ["Accent"] = FromRGB(177, 156, 217),
                ["Background"] = FromRGB(28, 28, 28),
                ["Dark Background"] = FromRGB(20, 20, 20),
                ["Border"] = FromRGB(50, 50, 50),
            } },
            { Name = "Vermillion", Colors = {
                ["Accent"] = FromRGB(218, 20, 2),
                ["Background"] = FromRGB(30, 32, 46),
                ["Dark Background"] = FromRGB(30, 32, 46),
                ["Border"] = FromRGB(32, 32, 57),
            } },
            { Name = "Github", Colors = {
                ["Accent"] = FromRGB(47, 129, 247),
                ["Background"] = FromRGB(22, 27, 34),
                ["Dark Background"] = FromRGB(13, 17, 23),
                ["Border"] = FromRGB(48, 54, 61),
            } },
            { Name = "Gamesense", Colors = {
                ["Accent"] = FromRGB(181, 249, 21),
                ["Background"] = FromRGB(28, 28, 28),
                ["Dark Background"] = FromRGB(24, 24, 24),
                ["Border"] = FromRGB(37, 37, 37),
            } },
            { Name = "Severe", Colors = {
                ["Accent"] = FromRGB(1, 128, 254),
                ["Background"] = FromRGB(21, 20, 27),
                ["Dark Background"] = FromRGB(16,16,20),
                ["Border"] = FromRGB(33, 32, 45),
            } },
            { Name = "Midnight", Colors = {
                ["Accent"] = FromRGB(110, 167, 212),
                ["Background"] = FromRGB(48, 47, 54),
                ["Dark Background"] = FromRGB(45, 43, 50),
                ["Border"] = FromRGB(64, 63, 69),
            } },
            { Name = "Parchment", Colors = {
                ["Accent"] = FromRGB(219, 202, 189),
                ["Background"] = FromRGB(30, 31, 30),
                ["Dark Background"] = FromRGB(30, 31, 30),
                ["Border"] = FromRGB(36, 36, 36),
            } },
            { Name = "Emerald", Colors = {
                ["Accent"] = FromRGB(0, 230, 118),
                ["Background"] = FromRGB(25, 27, 25),
                ["Dark Background"] = FromRGB(18, 20, 18),
                ["Border"] = FromRGB(40, 38, 40),
            } },
        }

        local PresetByName, PresetNames = { }, { }
        for _, Preset in Presets do
            PresetByName[Preset.Name] = Preset
            PresetNames[#PresetNames + 1] = Preset.Name
        end

        StyleSection:Dropdown({
            Name = "Preset",
            Options = PresetNames,
            Default = 1,
            Callback = function(Selection)
                local Preset = PresetByName[Selection]
                if not Preset then return end

                for Key, Color in Preset.Colors do
                    Library.Theme[Key] = Color

                    local Picker = ThemePickers[Key]
                    if Picker then
                        Picker.Color = { Color.R * 255, Color.G * 255, Color.B * 255 }
                        Picker:SyncFlag()
                    end
                end

                MainWin:Notify("Theme: " .. Preset.Name, 2)
            end,
        })

        StyleSection:Separator()

        StyleSection:Dropdown({
            Name = "Font Selector",
            Options = Library.Fonts.Data.List,
            Default = TableFind(Library.Fonts.Data.List, Library.Font) or 1,
            Flag = "UI_Font",
            Callback = function(Selection)
                Library.Font = Selection
            end,
        })

        StyleSection:Separator()

        StyleSection:Toggle({
            Name = "Show Keybind List",
            Flag = "UI_KeybindList",
            Default = true,
            Callback = function(Value)
                MainWin.KeybindListVisible = Value
            end,
        })

        StyleSection:Toggle({
            Name = "Show Watermark",
            Flag = "UI_Watermark",
            Default = true,
            Callback = function(Value)
                if Library.WatermarkData then
                    Library.WatermarkData.Visible = Value
                end
            end,
        })

        local MenuKeyLabel = StyleSection:Label({ Name = "Menu Toggle Key" })
        MenuKeyLabel:KeyPicker({
            Flag = "UI_MenuKey",
            Default = "RightShift",
            Callback = function() end,
        })

        local MenuKP = MenuKeyLabel.AttachedKeyPicker
        if MenuKP then
            local OrigSync = MenuKP.SyncFlag
            function MenuKP:SyncFlag()
                OrigSync(self)
                MainWin.MenuToggleKey = self.BoundKey
            end
            MainWin.MenuToggleKey = MenuKP.BoundKey
        end

        return StyleWindow
    end

    -- // Config Window \\ --

    function Library:ConfigWindow()
        assert(#self.Windows > 0, "No windows exist")
        local MainWin = self.Windows[1]

        local ConfigWin = Library:Window({
            Name = "Configurations",
            Size = Vector2New(300, 420),
            Position = Vector2New(MainWin.X - 8 - 300, MainWin.Y),
        })
        ConfigWin.Visible = false
        ConfigWin.MenuToggleKey = ""
        ConfigWin.IsSubWindow = true

        local ConfigPage = ConfigWin:Page({ Name = "Config", Columns = 1 })
        local ConfigSection = ConfigPage:Section({ Name = "Config", Side = 1 })

        local State = { List = { }, Selected = nil }

        local function RefreshList()
            State.List = { }
            if isfolder(Library.Folders.Configs) then
                for _, Path in listfiles(Library.Folders.Configs) do
                    local Name = Path:match("([^/\\]+)$")
                    if Name and Name:sub(-4) == ".lua" then
                        State.List[#State.List + 1] = Name:sub(1, -5)
                    end
                end
            end
            TableSort(State.List)
            if State.Selected then
                local Found = false
                for _, N in State.List do
                    if N == State.Selected then Found = true break end
                end
                if not Found then State.Selected = nil end
            end
        end

        RefreshList()

        local BoxRows = 7
        local RowH = 16
        local BoxH = BoxRows * RowH + 6

        local ListBox = ConfigSection:Label({ Name = "" })
        ListBox.Height = BoxH + 4

        local NameBox = ConfigSection:Textbox({
            Placeholder = "Config name...",
            MaxLength = 48,
            Callback = function() end,
        })

        function ListBox:Render()
            local X, Y, W = self.X, self.Y, self.Width
            DrawBox(X, Y, W, BoxH, Theme["Black"], Theme["Border"], Theme["Dark Background"])

            if #State.List == 0 then
                local Bounds = GetTextBounds("No configs saved", 13)
                DrawText(X + MathFloor((W - Bounds.X) / 2), Y + MathFloor((BoxH - Bounds.Y) / 2), 14, Theme["Dim"], "No configs saved")
                return
            end

            for Index, Name in State.List do
                if Index > BoxRows then break end
                local RY = Y + 3 + (Index - 1) * RowH
                local Selected = (State.Selected == Name)
                local Bounds = GetTextBounds(Name, 12)
                DrawText(X + MathFloor((W - Bounds.X) / 2), RY + MathFloor((RowH - Bounds.Y) / 2), 12,
                    Selected and Theme["Accent"] or Theme["Dim"], Name)

                if Library.Input.MouseClicked and not Library.Input.Consumed and Library:IsHovering(X + 2, RY, W - 4, RowH) then
                    Library.Input.Consumed = true
                    State.Selected = Name
                    NameBox.Value = Name
                end
            end
        end

        local function MakeButtonRow(LabelA, CallbackA, LabelB, CallbackB)
            local Row = ConfigSection:Label({ Name = "" })
            Row.Height = 26
            function Row:Render()
                local X, Y, W = self.X, self.Y, self.Width
                local BW = MathFloor((W - 3) / 2)
                local function DrawBtn(BX, Text, Callback)
                    local Hovered = Library:IsHovering(BX, Y, BW, 22) and not Library.Input.Consumed
                    DrawBox(BX, Y, BW, 22, Theme["Black"], Theme["Border"], Hovered and Theme["Dark Background"] or Theme["Background"])
                    local Bounds = GetTextBounds(Text, 11)
                    DrawText(BX + MathFloor((BW - Bounds.X) / 2), Y + MathFloor((22 - Bounds.Y) / 2), 11,
                        Hovered and Theme["Accent"] or Theme["White"], Text)
                    if Library.Input.MouseClicked and Hovered then
                        Library.Input.Consumed = true
                        Callback()
                    end
                end
                DrawBtn(X, LabelA, CallbackA)
                DrawBtn(X + BW + 3, LabelB, CallbackB)
            end
        end

        local function SaveConfig()
            local Name = NameBox.Value ~= "" and NameBox.Value or State.Selected
            if not Name or Name == "" then MainWin:Notify("Enter a config name", 2) return end
            local Ok = pcall(writefile, Library.Folders.Configs .. "/" .. Name .. ".lua", Library:ExportFlags())
            if Ok then
                State.Selected = Name
                RefreshList()
                MainWin:Notify("Saved: " .. Name)
            else
                MainWin:Notify("Save failed")
            end
        end

        local function LoadConfig()
            local Name = State.Selected
            if not Name then MainWin:Notify("No config selected", 2) return end
            local Path = Library.Folders.Configs .. "/" .. Name .. ".lua"
            if not isfile(Path) then MainWin:Notify("File not found", 2) return end
            local Fn = loadstring(readfile(Path))
            if not Fn then MainWin:Notify("Parse error") return end
            local Ok, Data = pcall(Fn)
            if not Ok or type(Data) ~= "table" then MainWin:Notify("Load error", 2) return end
            Library:ApplyFlags(Data)
            MainWin:Notify("Loaded: " .. Name, 2)
        end

        local function DeleteConfig()
            local Name = State.Selected
            if not Name then MainWin:Notify("No config selected", 2) return end
            local Path = Library.Folders.Configs .. "/" .. Name .. ".lua"
            if not isfile(Path) then MainWin:Notify("File not found", 2) return end
            delfile(Path)
            NameBox.Value = ""
            RefreshList()
            MainWin:Notify("Deleted: " .. Name, 2)
        end

        MakeButtonRow("Save", SaveConfig, "Load", LoadConfig)
        MakeButtonRow("Delete", DeleteConfig, "Refresh", function()
            RefreshList()
            MainWin:Notify("Refreshed", 2)
        end)

        return ConfigWin
    end

    -- // Nav Bar \\ --

    function Library:NavigationBar(Main, Style, Configuration)
        local ButtonSize = 28
        local ButtonGap = 3
        local Pad = 6
        local Amount = 3
        local Width = Pad + Amount * ButtonSize + (Amount - 1) * ButtonGap + Pad
        local Height = Pad + ButtonSize + Pad + 4

        Library.NavigationBarData = {
            X = Library.Viewport.X / 2 - Width / 2,
            Y = 40,
            Width = Width,
            Height = Height,
            Buttons = {
                { Icon = Library.Icons.Home,   Window = Main },
                { Icon = Library.Icons.Style,  Window = Style },
                { Icon = Library.Icons.Config, Window = Configuration },
            },
        }

        -- The icon Image objects are created lazily (and rebuilt on colour change)
        -- by the render loop; see the NavigationBar section of the render loop.
    end

    -- // Watermark \\ --

    function Library:Watermark(Name)
        self.WatermarkData = self.WatermarkData or {
            X = 10, Y = 10,
            Dragging = false, DragOffsetX = 0, DragOffsetY = 0,
            Visible = true,
        }
        self.WatermarkData.Name = Name or "Watermark"
        return self.WatermarkData
    end

    function Library:RenderWatermark()
        local WM = self.WatermarkData
        if not WM or not WM.Visible then return end

        local Text = WM.Name .. "  |  " .. MathFloor(get_overlay_fps()) .. " FPS"
        local Bounds = GetTextBounds(Text)
        local Width = MathCeil(Bounds.X) + 20
        local Height = MathMax(22, MathCeil(Bounds.Y) + 10)

        if self.Input.MouseClicked and not self.Input.Consumed and self:IsHovering(WM.X, WM.Y, Width, Height) then
            WM.Dragging = true
            WM.DragOffsetX = self.Input.MouseX - WM.X
            WM.DragOffsetY = self.Input.MouseY - WM.Y
            self.Input.Consumed = true
        end
        if not self.Input.MouseDown then WM.Dragging = false end
        if WM.Dragging then
            WM.X = self.Input.MouseX - WM.DragOffsetX
            WM.Y = self.Input.MouseY - WM.DragOffsetY
        end

        local X, Y = WM.X, WM.Y
        DrawBox(X, Y, Width, Height, Theme["Black"], Theme["Border"], Theme["Background"])
        DrawRect(X + 2, Y + 2, Width - 4, 2, Theme["Accent"])
        DrawText(X + 10, Y + MathFloor((Height - Bounds.Y) / 2) + 1, Library.FontSize, Theme["White"], Text)
    end

    -- // Group Ranked Players \\ --

    function Library:GroupList(GroupId, Ranks)
        assert(type(GroupId) == "number", "GroupList: GroupId must be a number")
        assert(type(Ranks) == "table", "GroupList: Ranks must be a table of rank names")

        local RankSet = { }
        for _, Name in Ranks do
            RankSet[tostring(Name):lower()] = true
        end

        local Data = {
            GroupId = GroupId,
            Matching = { },
            Title = "Moderator List",
            Width = 210,
            X = self.Viewport.X - 210 - 10,
            Y = self.Viewport.Y / 2 - 80,
            Visible = true,
            Dragging = false,
            DragOffsetX = 0,
            DragOffsetY = 0,
        }
        self.GroupRankedData = Data

        local Roles = { }

        local function Rebuild()
            Data.Matching = { }
            for _, Entry in Roles do
                if type(Entry.Role) == "string" and RankSet[Entry.Role:lower()] then
                    Data.Matching[#Data.Matching + 1] = { Name = Entry.Name, Role = Entry.Role }
                end
            end
            TableSort(Data.Matching, function(A, B) return A.Name:lower() < B.Name:lower() end)
        end

        local function ResolveRole(UserId)
            local Url = StringFormat("https://groups.roblox.com/v1/users/%d/groups/roles", UserId)

            local Ok, Body = pcall(function() return game:HttpGet(Url) end)
            if not Ok or type(Body) ~= "string" then return nil end

            local Decoded
            Ok, Decoded = pcall(function() return crypt.json.decode(Body) end)
            if not Ok or type(Decoded) ~= "table" or type(Decoded.data) ~= "table" then return nil end

            for _, Entry in Decoded.data do
                if Entry.group and Entry.group.id == GroupId and Entry.role then
                    return Entry.role.name
                end
            end
            return nil
        end

        task.spawn(function()
            while Library.GroupRankedData == Data do
                local Present = { }
                for _, Player in Players:GetChildren() do
                    local Id = Player.UserId
                    Present[Id] = true
                    local Entry = Roles[Id]
                    if Entry then
                        Entry.Name = Player.Name
                    else
                        Roles[Id] = { Name = Player.Name, Role = ResolveRole(Id) or false }
                        Rebuild()
                        task.wait(0.1)
                    end
                end

                for Id in Roles do
                    if not Present[Id] then Roles[Id] = nil end
                end

                Rebuild()
                task.wait(2)
            end
        end)

        return Data
    end

    function Library:RenderGroupRanked()
        local Data = self.GroupRankedData
        if not Data or not Data.Visible then return end

        local Input = self.Input
        local RowH = 22
        local HeaderH = 28
        local Padding = 8
        local Count = #Data.Matching
        local TotalH = HeaderH + MathMax(Count, 1) * RowH + Padding

        if Input.MouseClicked and not Input.Consumed and self:IsHovering(Data.X, Data.Y, Data.Width, HeaderH) then
            Data.Dragging = true
            Data.DragOffsetX = Input.MouseX - Data.X
            Data.DragOffsetY = Input.MouseY - Data.Y
            Input.Consumed = true
        end
        if not Input.MouseDown then Data.Dragging = false end
        if Data.Dragging then
            Data.X = Input.MouseX - Data.DragOffsetX
            Data.Y = Input.MouseY - Data.DragOffsetY
        end

        local X, Y, W = Data.X, Data.Y, Data.Width

        DrawBox(X, Y, W, TotalH, Theme["Black"], Theme["Border"], Theme["Background"])
        DrawRect(X + 2, Y + 2, W - 4, 2, Theme["Accent"])

        local TitleBounds = GetTextBounds(Data.Title)
        DrawText(X + MathFloor((W - TitleBounds.X) / 2), Y + 8, Library.FontSize, Theme["White"], Data.Title)

        local CX = X + 4
        local CY = Y + HeaderH
        local CW = W - 8
        local ContentH = TotalH - HeaderH - Padding
        DrawRect(CX, CY, CW, ContentH, Theme["Border"])
        DrawRect(CX + 1, CY + 1, CW - 2, ContentH - 2, Theme["Dark Background"])

        if Count == 0 then
            local NoneBounds = GetTextBounds("None in server")
            DrawText(CX + MathFloor((CW - NoneBounds.X) / 2), CY + MathFloor((RowH - NoneBounds.Y) / 2) + 2, Library.FontSize, Theme["Dim"], "None in server")
            return
        end

        for Index, Entry in Data.Matching do
            local RowY = CY + (Index - 1) * RowH + 2

            DrawText(CX + 6, RowY + 5, Library.FontSize, Theme["White"], Entry.Name)

            local RoleBounds = GetTextBounds(Entry.Role)
            DrawText(CX + CW - RoleBounds.X - 6, RowY + 5, Library.FontSize, Theme["Accent"], Entry.Role)

            if Index < Count then
                DrawRect(CX + 2, RowY + RowH - 1, CW - 4, 1, Theme["Border"], 0.5)
            end
        end
    end

    -- // Main Render Loop \\ --

    Library.MasterVisible = true
    Library.MasterPrevState = false
    Library.MasterSavedStates = { }
    Library.WindowSnapping = true
    Library.SnapGuides = nil

    local RenderConnection = RunService.Render:Connect(function()
        Library:UpdateInput()
        Library.Input.Consumed = false
        Library.DropdownOverlay = nil
        Library.SnapGuides = nil

        local MainWin = Library.Windows[1]
        if not MainWin then return end

        Pool:Begin()

        local MenuKey = MainWin.MenuToggleKey or "RightShift"
        local PressedKeys = getpressedkeys() or { }
        local MenuKeyDown = TableFind(PressedKeys, MenuKey) ~= nil

        if MenuKeyDown and not Library.MasterPrevState then
            if Library.MasterVisible then
                Library.MasterSavedStates = { }
                for _, Window in Library.Windows do
                    Library.MasterSavedStates[Window] = Window.Visible
                    Window.Visible = false
                end
                Library.MasterVisible = false
            else
                for _, Window in Library.Windows do
                    Window.Visible = Library.MasterSavedStates[Window] or false
                end
                Library.MasterVisible = true
            end
            Library.MasterPrevState = true
            Library.Input.FocusedTextbox = nil
        elseif not MenuKeyDown then
            Library.MasterPrevState = false
        end

        Library:RenderWatermark()
        Library:RenderGroupRanked()

        MainWin:RenderKeybindList()

        for _, Window in Library.Windows do
            if Window.Visible then
                Window:Render()
            end
        end

        if Library.SnapGuides then
            for _, G in Library.SnapGuides do
                DrawRect(G[1], G[2], G[3], G[4], Theme["Accent"])
            end
        end

        for _, Window in Library.Windows do
            Window:RenderNotifications()
        end

        if Library.NavigationBarData and Library.MasterVisible then
            local NB = Library.NavigationBarData
            local BtnSize = 28
            local BtnGap = 3
            local Pad = 6

            DrawBox(NB.X, NB.Y, NB.Width, NB.Height, Theme["Black"], Theme["Accent"], Theme["Background"])

            for Index, Btn in NB.Buttons do
                local BX = NB.X + Pad + (Index - 1) * (BtnSize + BtnGap)
                local BY = NB.Y + Pad
                local Active = Btn.Window and Btn.Window.Visible
                local Hovered = Library:IsHovering(BX, BY, BtnSize, BtnSize) and not Library.Input.Consumed

                DrawBox(BX, BY, BtnSize, BtnSize,
                    Theme["Black"],
                    Active and Theme["Accent"] or Theme["Border"],
                    Active and Theme["Accent"] or (Hovered and Theme["Dark Background"] or Theme["Background"]))

                local IconPad = 6
                local IW = BtnSize - IconPad * 2
                local IH = IW

                local IconColor = Active and Theme["White"] or (Hovered and Theme["Accent"] or Theme["Dim"])

                if not Btn._Drawing or Btn._IconColor ~= IconColor then
                    if Btn._Drawing then Btn._Drawing:Remove() end
                    Btn._Drawing = NewDrawing("Image", {
                        Visible = true,
                        Position = Vector2New(BX + IconPad, BY + IconPad),
                        Size = Vector2New(IW, IH),
                        Data = Btn.Icon,
                        Color = IconColor,
                        Opacity = 1,
                        ZIndex = 10000,
                    })
                    Btn._IconColor = IconColor
                end

                if Library.Input.MouseClicked and Hovered and Btn.Window then
                    Library.Input.Consumed = true
                    Btn.Window.Visible = not Btn.Window.Visible
                end
            end
        elseif Library.NavigationBarData then
            for _, Btn in Library.NavigationBarData.Buttons do
                if Btn._Drawing then
                    Btn._Drawing:Remove()
                    Btn._Drawing = nil
                    Btn._IconColor = nil
                end
            end
        end

        Pool:Finish()
    end)

    function Library:Unload()
        if RenderConnection then
            RenderConnection:Disconnect()
            RenderConnection = nil
        end
        for _, Square in Pool.Squares do Square:Remove() end
        for _, Object in Pool.Texts do Object:Remove() end
        for _, Image in Pool.Images do Image:Remove() end
        Pool.Squares, Pool.SquareCount = { }, 0
        Pool.Texts, Pool.TextCount = { }, 0
        Pool.Images, Pool.ImageCount = { }, 0

        if Library.NavigationBarData and Library.NavigationBarData.Buttons then
            for _, Btn in ipairs(Library.NavigationBarData.Buttons) do
                if Btn._Drawing then
                    Btn._Drawing:Remove()
                    Btn._Drawing = nil
                end
            end
        end
    end
end

return Library