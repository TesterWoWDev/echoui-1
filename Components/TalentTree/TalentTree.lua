TalentTree = {
    FORGE_TABS = {},
    FORGE_ACTIVE_SPEC = {},
    FORGE_SPECS_TAB = {},
    FORGE_SPEC_SLOTS = {},
    FORGE_SELECTED_TAB = nil,
    FORGE_SPELLS_PAGES = {},
    FORGE_CURRENT_PAGE = 0,
    FORGE_MAX_PAGE = nil,
    FORGE_TALENTS = nil,
    INITIALIZED = false,
    SELECTED_SPEC = nil,
    MaxPoints = {},
    ClassTree = nil,
    CLASS_TAB = nil,
    TalentLoadoutCache = {},
    currentLoadout = nil,
    prevLoadout = nil,
    activeString = nil
}

TreeCache = {
    Spells = {},
    PointsSpent = {},
    Investments = {},
    TotalInvests = {},
    PrereqUnlocks = {},
    PrereqRev = {},
    Points = {},
    PreviousString = {},
    IndexToFrame = {}
}

-- local Backdrop = {
--     bgFile = "Interface/Tooltips/UI-Tooltip-Background", -- Arquivo de textura do fundo
--     edgeFile = "Interface/Tooltips/UI-Tooltip-Border", -- Arquivo de textura da borda
--     tile = true,
--     tileSize = 16,
--     edgeSize = 16,
--     insets = {left = 4, right = 4, top = 4, bottom = 4}
-- }

TalentTreeWindow = CreateFrame("Frame", "TalentFrame", UIParent)
TalentTreeWindow:SetSize(1000, 800)
TalentTreeWindow:SetPoint("CENTER", 0, 50) --- LEFT/RIGHT -- --UP/DOWN --
TalentTreeWindow:SetFrameLevel(1)
TalentTreeWindow:SetFrameStrata("MEDIUM")
TalentTreeWindow:Hide()

TalentTreeWindow:SetScript(
    "OnHide",
    function(_)
        ForgedWoWMicrobarButton:SetButtonState("NORMAL")
    end
)

TalentTreeWindow:SetScript(
    "OnUpdate",
    function(_)
        if TalentTreeWindow:IsVisible() then
            ForgedWoWMicrobarButton:SetButtonState("PUSHED", 1)
        else
            ForgedWoWMicrobarButton:SetButtonState("NORMAL")
        end
    end
)

ClassSpecWindow = CreateFrame("Frame", "ClassSpecWindow", UIParent)
ClassSpecWindow:SetSize(1000, 800)
ClassSpecWindow:SetPoint("CENTER", 0, 50) --- LEFT/RIGHT -- --UP/DOWN --
ClassSpecWindow:SetFrameLevel(1)
ClassSpecWindow:SetFrameStrata("MEDIUM")
ClassSpecWindow:Hide()

ClassSpecWindow:SetScript(
    "OnUpdate",
    function(_)
        if ClassSpecWindow:IsVisible() then
            ForgedWoWMicrobarButton:SetButtonState("PUSHED", 1)
        else
            ForgedWoWMicrobarButton:SetButtonState("NORMAL")
        end
    end
)

ClassSpecWindow:SetScript(
    "OnHide",
    function(_)
        ForgedWoWMicrobarButton:SetButtonState("NORMAL")
    end
)

ClassSpecWindow:RegisterEvent("UNIT_SPELLCAST_START")
ClassSpecWindow:RegisterEvent("UNIT_SPELLCAST_STOP")
ClassSpecWindow:SetScript(
    "OnEvent",
    function(_, event, unit)
        if unit == "player" then
            local spellName = UnitCastingInfo(unit)
            if event == "UNIT_SPELLCAST_START" and spellName == "Activate Primary Spec" then
                CastingBarFrame:SetBackdrop({bgFile = "path/to/your/background/texture"})
                CastingBarFrame:SetStatusBarTexture("path/to/your/statusbar/texture")
                CastingBarFrame:SetFrameStrata("TOOLTIP")
                CastingBarFrame:ClearAllPoints()
                CastingBarFrame:SetPoint("CENTER", ClassSpecWindow, "CENTER", 0, 0)
            elseif event == "UNIT_SPELLCAST_STOP" then
                CastingBarFrame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
                CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 115)
            end
        end
    end
)

--Disable Buttons Based On Level--
-- local function CheckPlayerLevel(button, buttonText)
--     local playerLevel = UnitLevel("player")
--     if playerLevel < 10 then
--         button:Disable()
--         button:GetNormalTexture():SetVertexColor(0.5, 0.5, 0.5, 1)
--         buttonText:SetTextColor(0.5, 0.5, 0.5, 1)

--         if ClassSpecWindow:IsVisible() or TalentTreeWindow:IsVisible() then
--             ClassSpecWindow:Hide()
--             TalentTreeWindow:Hide()
--         end
--     else
--         button:Enable()
--         button:GetNormalTexture():SetVertexColor(1, 1, 1, 1) -- Cor original (branco) para a textura
--         buttonText:SetTextColor(1, 1, 0) -- Cor original (branco) para o texto
--     end
-- end

local windows = {TalentTreeWindow, ClassSpecWindow}
for i, window in ipairs(windows) do
    -- local SpecTabButton = CreateFrame("Button", "SpecButton" .. i, window) -- Identificador único
    -- SpecTabButton:SetSize(150, 60)
    -- SpecTabButton:SetFrameStrata("MEDIUM")
    -- SpecTabButton:SetScript("OnClick", function()
    --      if TalentTreeWindow:IsVisible() then
    --      TalentTreeWindow:Hide()
    --      ClassSpecWindow:Show()
    --      end
    -- end)

    -- local normalTexture = SpecTabButton:CreateTexture()
    -- normalTexture:SetTexture("Interface\\AddOns\\ForgedWoWCommunication\\UI\\uiframestab")
    -- normalTexture:SetAllPoints(SpecTabButton)

    -- local highlightTexture = SpecTabButton:CreateTexture()
    -- highlightTexture:SetTexture("Interface\\AddOns\\ForgedWoWCommunication\\UI\\uiframestab-Highlight")
    -- highlightTexture:SetAllPoints(SpecTabButton)

    -- SpecTabButton:SetNormalTexture(normalTexture)
    -- SpecTabButton:SetHighlightTexture(highlightTexture)

    -- local SpecTabButtonText = SpecTabButton:CreateFontString()
    -- SpecTabButtonText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    -- SpecTabButtonText:SetPoint("CENTER", 0, 0)
    -- SpecTabButtonText:SetTextColor(1, 1, 0)
    -- SpecTabButtonText:SetText("Specializations")

    -- SpecTabButton:SetScript("OnUpdate", function(self, elapsed)
    -- CheckPlayerLevel(SpecTabButton, SpecTabButtonText)
    -- end)

    -- Botão Talentos
    local TalentTabButton = CreateFrame("Button", "TalentTabButton" .. i, window) -- Identificador único
    TalentTabButton:SetSize(100, 60)
    TalentTabButton:SetFrameStrata("MEDIUM")
    TalentTabButton:SetScript(
        "OnClick",
        function()
            if ClassSpecWindow:IsVisible() then
                ClassSpecWindow:Hide()
                TalentTreeWindow:Show()
            end
        end
    )

    local normalTexture2 = TalentTabButton:CreateTexture()
    normalTexture2:SetTexture("Interface\\AddOns\\ForgedWoWCommunication\\UI\\uiframestab")
    normalTexture2:SetAllPoints(TalentTabButton)

    local highlightTexture2 = TalentTabButton:CreateTexture()
    highlightTexture2:SetTexture("Interface\\AddOns\\ForgedWoWCommunication\\UI\\uiframestab-Highlight")
    highlightTexture2:SetAllPoints(TalentTabButton)

    TalentTabButton:SetNormalTexture(normalTexture2)
    TalentTabButton:SetHighlightTexture(highlightTexture2)

    local TalentTabText = TalentTabButton:CreateFontString()
    TalentTabText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    TalentTabText:SetPoint("CENTER", 0, 0)
    TalentTabText:SetTextColor(1, 1, 0)
    TalentTabText:SetText("Talents")

    if window == TalentTreeWindow then
        --SpecTabButton:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", -200, -35)
        TalentTabButton:SetPoint("LEFT", SpecTabButton, "RIGHT", 50, 0)
    elseif window == ClassSpecWindow then
        --SpecTabButton:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", -200, -35)
        TalentTabButton:SetPoint("LEFT", SpecTabButton, "RIGHT", 50, 0)
    end
end

local function AdjustFrameScale(frame)
    local maxScale = 0.85
    local minScale = 0.3

    -- Obtendo as dimensões da tela e a escala da interface do usuário
    local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()
    local windowWidth, windowHeight = frame:GetWidth(), frame:GetHeight()

    -- Calculando a escala necessária para ajustar o frame na tela
    local scaleWidth = screenWidth / windowWidth
    local scaleHeight = screenHeight / windowHeight
    local newScale = math.min(scaleWidth, scaleHeight, maxScale)
    newScale = math.max(newScale, minScale)

    -- Ajustando a escala do frame
    frame:SetScale(newScale)
end

-- Evento acionado quando a tela é redimensionada
UIParent:SetScript(
    "OnSizeChanged",
    function(_, _, _)
        AdjustFrameScale(TalentTreeWindow)
    end
)

AdjustFrameScale(TalentTreeWindow)
AdjustFrameScale(ClassSpecWindow)

Bordertexture = TalentTreeWindow:CreateTexture(nil, "OVERLAY")
Bordertexture:SetTexture(CONSTANTS.UI.MAIN_BG)
Bordertexture:SetPoint("CENTER", 0, -100)
Bordertexture:SetTexCoord(0, 1, 0, 0.57)
Bordertexture:SetSize(TalentTreeWindow:GetWidth() * 1.8, TalentTreeWindow:GetHeight() * 1.3)

BorderSpec = ClassSpecWindow:CreateTexture(nil, "OVERLAY")
BorderSpec:SetTexture(CONSTANTS.UI.MAIN_BG_SPEC)
BorderSpec:SetPoint("CENTER", 0, -100)
BorderSpec:SetTexCoord(0, 1, 0, 0.57)
BorderSpec:SetSize(TalentTreeWindow:GetWidth() * 1.8, TalentTreeWindow:GetHeight() * 1.3)

ClassSpecWindow.Lockout = CreateFrame("Frame", "ClassSpecWindow.Lockout", ClassSpecWindow)
ClassSpecWindow.Lockout:SetSize(ClassSpecWindow:GetWidth() * 1.433, ClassSpecWindow:GetHeight() * 0.96)
ClassSpecWindow.Lockout:SetFrameLevel(100)
ClassSpecWindow.Lockout:EnableMouse(true)
ClassSpecWindow.Lockout:SetPoint("CENTER", -25, -5)
ClassSpecWindow.Lockout:Hide()

BackgroundSpec = ClassSpecWindow:CreateTexture(nil, "BACKGROUND")
BackgroundSpec:SetTexture(CONSTANTS.UI.BG_SPEC)
BackgroundSpec:SetPoint("CENTER", 0, -117)
BackgroundSpec:SetDrawLayer("BACKGROUND", -1)
BackgroundSpec:SetTexCoord(0, 1, 0, 0.57)
BackgroundSpec:SetSize(TalentTreeWindow:GetWidth() * 1.8, TalentTreeWindow:GetHeight() * 1.4)

SpecTitleText = ClassSpecWindow:CreateFontString()
SpecTitleText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
SpecTitleText:SetPoint("TOP", BackgroundSpec, "TOP", -20, -45)
SpecTitleText:SetTextColor(1, 1, 0)
SpecTitleText:SetText("Specializations")

for i, window in ipairs(windows) do
    local closeButton = CreateFrame("Button", "CloseTalentUI" .. i, window, "UIPanelCloseButton")
    closeButton:SetSize(40, 40)
    closeButton:SetFrameLevel(100)

    closeButton:SetScript(
        "OnClick",
        function()
            window:Hide()
        end
    )

    ClassIconTexture = window:CreateTexture(nil, "ARTWORK")
    ClassIconTexture:SetTexture(CONSTANTS.UI.MAIN_BG)
    ClassIconTexture:SetSize(67, 67)
    ClassIconTexture:SetDrawLayer("ARTWORK", 1)
    SetPortraitToTexture(ClassIconTexture, CONSTANTS.classIcon[string.upper(CONSTANTS.CLASS)])

    LockoutTexture = ClassSpecWindow.Lockout:CreateTexture(nil, "BACKGROUND")
    LockoutTexture:SetAllPoints()
    LockoutTexture:SetTexture("Interface\\AddOns\\ForgedWoWCommunication\\UI\\Background_DragonflightSpec.blp")
    LockoutTexture:SetTexCoord(0.083007813, 0.880859375, 0.576660156, 1)
    LockoutTexture:SetVertexColor(0, 0, 0, 0.7)
    LockoutTexture:SetDrawLayer("BACKGROUND", -1)

    ClassSpecWindow.Lockout.texture = texture

    if window == TalentTreeWindow then
        closeButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", 190, 8)
        ClassIconTexture:SetPoint("TOPLEFT", window, "TOPLEFT", -241, 12)
    elseif window == ClassSpecWindow then
        closeButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", 190, 8)
        ClassIconTexture:SetPoint("TOPLEFT", window, "TOPLEFT", -241, 12)
    end
end

TalentTreeWindow.Container = CreateFrame("Frame", "Talent.Background", TalentTreeWindow)
TalentTreeWindow.Container:SetSize(TalentTreeWindow:GetWidth() * 1.42, TalentTreeWindow:GetHeight() * 0.925) -- Talent Tree Window's Background --
TalentTreeWindow.Container:SetPoint("CENTER", -20, 0)
TalentTreeWindow.Container:SetFrameStrata("MEDIUM")

TalentTreeWindow.Container.Background = TalentTreeWindow:CreateTexture(nil, "BACKGROUND")
TalentTreeWindow.Container.Background:SetTexCoord(0.16, 1, 0.0625, 0.5625)
TalentTreeWindow.Container.Background:SetPoint("CENTER", -32, 20)
TalentTreeWindow.Container.Background:SetDrawLayer("BACKGROUND", -1)
TalentTreeWindow.Container.Background:SetSize(TalentTreeWindow:GetWidth() * 1.47, TalentTreeWindow:GetHeight() * 0.945)

TalentTreeWindow.Container.CloseButtonForgeSkills =
    CreateFrame("Button", TalentTreeWindow.Container.CloseButtonForgeSkills, TalentTreeWindow.Container)

TalentTreeWindow.Container.CloseButtonForgeSkills:SetScript(
    "OnClick",
    function()
        HideForgeSkills()
    end
)
TalentTreeWindow.Container.CloseButtonForgeSkills:SetSize(25, 25)
TalentTreeWindow.Container.CloseButtonForgeSkills:SetPoint("TOPRIGHT", -15, -75)
TalentTreeWindow.Container.CloseButtonForgeSkills.Circle =
    CreateFrame(
    "Frame",
    TalentTreeWindow.Container.CloseButtonForgeSkills.Circle,
    TalentTreeWindow.Container.CloseButtonForgeSkills
)
TalentTreeWindow.Container.CloseButtonForgeSkills.Circle:SetSize(25, 25)
TalentTreeWindow.Container.CloseButtonForgeSkills.Circle:SetPoint("CENTER", -1.5, -1)
TalentTreeWindow.Container.CloseButtonForgeSkills.Circle:SetBackdrop(
    {
        bgFile = CONSTANTS.UI.BORDER_CLOSE_BTN
    }
)
TalentTreeWindow.Container.CloseButtonForgeSkills:Hide()

TalentTreeWindow.ChoiceSpecs = CreateFrame("Frame", "TalentTreeWindow.ChoiceSpecs", TalentTreeWindow.Container)
TalentTreeWindow.ChoiceSpecs:SetSize(100, 100)
TalentTreeWindow.ChoiceSpecs:SetPoint("TOP", 30, -100)
TalentTreeWindow.ChoiceSpecs:SetFrameLevel(15)
TalentTreeWindow.ChoiceSpecs:SetBackdrop(
    {
        edgeSize = 24,
        bgFile = CONSTANTS.UI.BACKGROUND_SPECS
    }
)
TalentTreeWindow.ChoiceSpecs.Spec = {}
TalentTreeWindow.ChoiceSpecs:Show()

table.insert(UISpecialFrames, "TalentTreeWindow")
table.insert(UISpecialFrames, "ClassSpecWindow")

-- Define your popup dialog
StaticPopupDialogs["CONFIRM_TALENT_WIPE"] = {
    text = "Are you sure you want to reset all of your talents?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        local playerLevel = UnitLevel("player") -- Get the player's level
        if playerLevel >= 10 then
            RevertAllTalents()
            DEFAULT_CHAT_FRAME:AddMessage("Your talents have been reset.", 1, 1, 0) -- Sends a yellow message
        else
            DEFAULT_CHAT_FRAME:AddMessage("You must be at least level 10 to reset talents.", 1, 0, 0) -- Sends a red error message
        end
        StaticPopup_Hide("CONFIRM_TALENT_WIPE")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, -- prevent taint from Blizzard UI
    OnShow = function(self)
        self:ClearAllPoints()
        self:SetPoint("CENTER", 50, 250) -- position it to center
        self:SetSize(800, 800) -- adjust the size as necessary
    end
}

local AcceptTalentsButton = CreateFrame("Button", "AcceptTalentsButton", TalentTreeWindow, "UIPanelButtonTemplate")
AcceptTalentsButton:SetSize(200, 30)
AcceptTalentsButton:SetPoint("BOTTOM", 0, 45) -- Position the button at the top right of the TalentTreeWindow
AcceptTalentsButton:SetText("Apply Changes")
AcceptTalentsButton:Show()

local resetButton = CreateFrame("Button", "ResetTalentsButton", TalentTreeWindow, "UIPanelButtonTemplate")
resetButton:SetSize(115, 40)
resetButton:SetPoint("RIGHT", AcceptTalentsButton, "RIGHT", 150, 0) -- Position the button at the top right of the TalentTreeWindow
resetButton:SetText("Reset Talents")
resetButton:Show()

resetButton:SetScript(
    "OnClick",
    function()
        StaticPopup_Show("CONFIRM_TALENT_WIPE")
    end
)

local alphaSlider = CreateFrame("Slider", "AlphaSlider", TalentTreeWindow, "OptionsSliderTemplate")
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(0.01)
alphaSlider:SetWidth(200)
alphaSlider:SetHeight(20)
alphaSlider:SetPoint("BOTTOM", AcceptTalentsButton, "BOTTOM", 0, -20) -- Posiciona a SliderBar

local lowText = alphaSlider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
lowText:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", 2, 3)

local highText = alphaSlider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highText:SetPoint("TOPRIGHT", alphaSlider, "BOTTOMRIGHT", -2, 3)

local titleText = alphaSlider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
titleText:SetPoint("TOP", alphaSlider, "BOTTOM", 0, 3)
titleText:SetText("Background Transparence")

-- Define a função para o evento OnValueChanged
alphaSlider:SetScript(
    "OnValueChanged",
    function(_, value)
        TalentTreeWindow.Container.Background:SetAlpha(value)
    end
)

-- Define o valor inicial do alpha
alphaSlider:SetValue(1) -- Começa com alpha 1 (totalmente opaco)

--Testing--
TalentLoadoutCache = TalentTree.TalentLoadoutCache

local function BuildLoadoutString()
    local out = ""

    out =
        out ..
        string.sub(
            Util.alpha,
            TalentTree.FORGE_SELECTED_TAB.TalentType + 1,
            TalentTree.FORGE_SELECTED_TAB.TalentType + 1
        )
    out = out .. string.sub(Util.alpha, TalentTree.FORGE_SELECTED_TAB.Id, TalentTree.FORGE_SELECTED_TAB.Id)
    out = out .. string.sub(Util.alpha, GetClassId(UnitClass("player")), GetClassId(UnitClass("player")))

    -- TODO: CLASS TREE
    for _, rank in ipairs(TreeCache.Spells[TalentTree.ClassTree]) do
        out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
    end

    -- Spec tree last
    for _, rank in ipairs(TreeCache.Spells[TalentTree.FORGE_SELECTED_TAB.Id]) do
        out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
    end

    return out
end

local function SetLoadoutButtonText(name)
    buttonText:SetText(name)
end

local function SaveLoadout(id, name, loadoutString)
    if not loadoutString then
        loadoutString = BuildLoadoutString()
    end
    local item = {
        name = name,
        loadout = loadoutString
    }
    TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id][id] = item

    PushForgeMessage(ForgeTopic.SAVE_LOADOUT, tostring(id) .. ";" .. name .. ";" .. loadoutString)
    SetLoadoutButtonText(name)
end

function ApplyLoadoutAndUpdateCurrent(id)
    local loadout = TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id][id]
    if loadout then
        SetLoadoutButtonText(id .. " " .. loadout.name)
        TalentTree.prevLoadout = TalentTree.currentLoadout
        TalentTree.currentLoadout = id
        TalentTree.activeString = loadout.loadout
        LoadTalentString(loadout.loadout)
    end
end

AcceptTalentsButton:SetScript(
    "OnClick",
    function()
        local out = ""

        -- tree metadata: type spec class
        out =
            out ..
            string.sub(
                Util.alpha,
                TalentTree.FORGE_SELECTED_TAB.TalentType + 1,
                TalentTree.FORGE_SELECTED_TAB.TalentType + 1
            )
        out = out .. string.sub(Util.alpha, TalentTree.FORGE_SELECTED_TAB.Id, TalentTree.FORGE_SELECTED_TAB.Id)
        out = out .. string.sub(Util.alpha, GetClassId(UnitClass("player")), GetClassId(UnitClass("player")))

        -- TODO: CLASS TREE
        for _, rank in ipairs(TreeCache.Spells[TalentTree.ClassTree]) do
            out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
        end

        -- Spec tree last
        for _, rank in ipairs(TreeCache.Spells[TalentTree.FORGE_SELECTED_TAB.Id]) do
            out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
        end

        if
            TreeCache.PreviousString[TalentTree.FORGE_SELECTED_TAB.TalentType + 1] ~= out or
                TalentTree.prevLoadout ~= TalentTree.currentLoadout
         then
            --print("Talent string to send: "..out.." length: "..string.len(out))
            local loadout = TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id][TalentTree.currentLoadout]
            SaveLoadout(TalentTree.currentLoadout, loadout.name)
            PushForgeMessage(ForgeTopic.LEARN_TALENT, out)
        end
    end
)

local LoadoutDropButton = CreateFrame("Button", "LoadoutDropButton", TalentTreeWindow)
LoadoutDropButton:SetPoint("BOTTOMLEFT", TalentTreeWindow, "BOTTOMLEFT", -200, 35)
LoadoutDropButton:SetSize(180, 32)
LoadoutDropButton:SetFrameStrata("TOOLTIP")

LoadoutDropButton.bgTexture = LoadoutDropButton:CreateTexture(nil, "BACKGROUND")
LoadoutDropButton.bgTexture:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
LoadoutDropButton.bgTexture:SetPoint("CENTER")
LoadoutDropButton.bgTexture:SetWidth(250)
LoadoutDropButton.bgTexture:SetHeight(70)

buttonText = LoadoutDropButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
buttonText:SetText("Saved Loadouts")
buttonText:SetPoint("CENTER", LoadoutDropButton, "CENTER")

local arrowButton = CreateFrame("Button", nil, LoadoutDropButton)
arrowButton:SetSize(25, 25)
arrowButton:SetPoint("RIGHT", LoadoutDropButton, "RIGHT", 0, 1)

local arrowTexture = arrowButton:CreateTexture(nil, "OVERLAY")
arrowTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
arrowTexture:SetAllPoints(arrowButton)
arrowButton:SetNormalTexture(arrowTexture)

-- local function UpdateLoadoutMenu()
--     local menuItems = {
--         {
--             text = "Create Loadout",
--             colorCode = "|cff00ff00",
--             func = function()
--                 StaticPopup_Show("CREATE_LOADOUT_POPUP")
--             end,
--             notCheckable = true
--         }
--     }

--     for id, loadout in pairs(TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id]) do
--         table.insert(
--             menuItems,
--             {
--                 text = id .. " " .. loadout.name,
--                 colorCode = "|cff0000ff",
--                 func = function()
--                     ApplyLoadoutAndUpdateCurrent(id)
--                     CloseDropDownMenus()
--                 end,
--                 notCheckable = true
--             }
--         )
--     end

--     return menuItemsq
-- end

-- local function UpdateLoadoutButtonText(name, isDefault)
--     if isDefault then
--         buttonText:SetText(name)
--         buttonText:SetTextColor(0, 0, 1)
--     else
--         buttonText:SetText(name)
--         buttonText:SetTextColor(0, 0.5, 1)
--     end
-- end

function DeleteLoadout(id)
    PushForgeMessage(ForgeTopic.DELETE_LOADOUT, id)
end

local function GenerateTalentString()
    local out = ""

    -- tree metadata: type spec class
    out =
        out ..
        string.sub(
            Util.alpha,
            TalentTree.FORGE_SELECTED_TAB.TalentType + 1,
            TalentTree.FORGE_SELECTED_TAB.TalentType + 1
        )
    out = out .. string.sub(Util.alpha, TalentTree.FORGE_SELECTED_TAB.Id, TalentTree.FORGE_SELECTED_TAB.Id)
    out = out .. string.sub(Util.alpha, GetClassId(UnitClass("player")), GetClassId(UnitClass("player")))

    -- CLASS TREE
    for _, rank in ipairs(TreeCache.Spells[TalentTree.ClassTree]) do
        out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
    end

    -- Spec tree last
    for _, rank in ipairs(TreeCache.Spells[TalentTree.FORGE_SELECTED_TAB.Id]) do
        out = out .. string.sub(Util.alpha, rank + 1, rank + 1)
    end

    return out
end

local function ShareTalentString()
    local talentString = GenerateTalentString()
    local name, _ = UnitName("player")
    local fakeItemID = "123456"
    local fakeItemLink =
        "|cff9d9d9d|Hitem:" .. fakeItemID .. ":::::::::::" .. talentString .. ":::|h[" .. name .. " Talent Build]|h|r"
    print(fakeItemLink)
    SendChatMessage("Check out my custom talent build: " .. fakeItemLink, "SAY") -- Modifique para o canal de chat desejado
end

hooksecurefunc(
    "SetItemRef",
    function(link, _, _, _) -- text,button,chatFrame
        local type, id = strsplit(":", link)
        if type == "item" and id == "123456" then
            -- Abre um quadro de diálogo com a string de talentos que pode ser copiada.
            local editBox = ChatEdit_ChooseBoxForSend()
            local talentString = GenerateTalentString()
            ChatEdit_ActivateChat(editBox)
            editBox:SetText(talentString)
            editBox:HighlightText()
            -- Esconde a tooltip
            HideUIPanel(ItemRefTooltip)
            -- Informa ao usuário para pressionar Ctrl+C para copiar.
            print("Press Ctrl+C to copy the Loadout")
        end
    end
)

local function ShowLoadoutMenu()
    local menuItems = {}

    local maxLoadouts = 7 -- Incluindo o loadout padrão
    local currentLoadoutCount = #TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id]

    -- Adiciona o item de menu "Create Loadout", mas desabilita se o limite for atingido
    local createLoadoutItem = {
        text = "Create Loadout",
        notCheckable = true,
        func = function()
            if currentLoadoutCount < maxLoadouts then
                StaticPopup_Show("CREATE_LOADOUT_POPUP")
            end
        end,
        colorCode = currentLoadoutCount < maxLoadouts and "|cff00ff00" or "|cff808080"
    }

    table.insert(menuItems, createLoadoutItem)

    for id, loadout in pairs(TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id]) do
        -- Determine se este é o primeiro loadout no cache
        local isFirstLoadout = id == next(TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id])

        local submenu = {}
        if not isFirstLoadout then -- Se não for o primeiro loadout, adicione opções no submenu
            -- Adiciona a opção de deletar
            table.insert(
                submenu,
                {
                    text = "Delete Loadout",
                    colorCode = "|cffFF0000",
                    func = function()
                        TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id][id] = nil
                        DropDownList1:Hide()
                        buttonText:SetText("Saved Loadouts")
                        DeleteLoadout(id)
                    end,
                    notCheckable = true
                }
            )
            -- Adiciona a opção de compartilhar
            table.insert(
                submenu,
                {
                    text = "Share Loadout",
                    colorCode = "|cff00ccff",
                    func = function()
                        ShareTalentString() -- Chama a função ShareTalentString
                    end,
                    notCheckable = true
                }
            )
            table.insert(
                submenu,
                {
                    text = "Import Loadout",
                    colorCode = "|cff00ccff",
                    func = function()
                        StaticPopup_Show("IMPORT_LOADOUT_POPUP")
                    end,
                    notCheckable = true
                }
            )
        end

        table.insert(
            menuItems,
            {
                text = id .. " " .. loadout.name,
                colorCode = "|cffffffff",
                func = function()
                    ApplyLoadoutAndUpdateCurrent(id)
                end,
                notCheckable = true,
                hasArrow = not isFirstLoadout, -- Só mostra a seta se não for o primeiro loadout
                menuList = submenu
            }
        )
    end

    local menuFrame = CreateFrame("Frame", "LoadoutMenuFrame", UIParent, "UIDropDownMenuTemplate")

    UIDropDownMenu_Initialize(
        menuFrame,
        function(_, level, menuList)
            if level == 1 then
                for _, menuItem in ipairs(menuItems) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = menuItem.text
                    info.colorCode = menuItem.colorCode
                    info.notCheckable = menuItem.notCheckable
                    info.func = menuItem.func
                    info.hasArrow = menuItem.hasArrow
                    info.menuList = menuItem.menuList
                    UIDropDownMenu_AddButton(info)
                end
            elseif level == 2 and menuList then
                for _, menuItem in ipairs(menuList) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = menuItem.text
                    info.colorCode = menuItem.colorCode
                    info.notCheckable = menuItem.notCheckable
                    info.func = menuItem.func
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end,
        "MENU"
    )

    ToggleDropDownMenu(1, nil, menuFrame, "cursor", 0, 0)
end

arrowButton:SetScript(
    "OnClick",
    function(_, _, _)
        ShowLoadoutMenu()
    end
)

StaticPopupDialogs["CREATE_LOADOUT_POPUP"] = {
    text = "Enter the name of your new loadout:",
    button1 = "OK",
    button2 = "Cancel",
    OnAccept = function(self)
        local text = self.editBox:GetText()
        local index = #TalentTree.TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id] + 1
        SaveLoadout(index, text)
        buttonText:SetText(text)
        StaticPopup_Hide("CREATE_LOADOUT_POPUP")
    end,
    OnShow = function(self)
        self.editBox:SetMaxLetters(10) -- Seu código de OnShow aqui
        --local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint()
        self:ClearAllPoints()
        self:SetPoint("CENTER", TalentFrame, "CENTER", 0, 100)
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

StaticPopupDialogs["IMPORT_LOADOUT_POPUP"] = {
    text = "Import Loadout",
    button1 = "OK",
    button2 = "Cancel",
    OnAccept = function(self)
        local text = self.editBox:GetText()
        if text and text ~= "" then
            local loadout = TalentLoadoutCache[TalentTree.FORGE_SELECTED_TAB.Id][TalentTree.currentLoadout]
            loadout.talentString = text
            LoadTalentString(text)
        end
        StaticPopup_Hide("IMPORT_LOADOUT_POPUP")
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

local function UpdateButtonDisplay(loadoutName)
    if loadoutName then
        buttonText:SetText(loadoutName)
    else
        buttonText:SetText("Saved Loadouts")
    end
end

UpdateButtonDisplay()
