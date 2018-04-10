local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

local function BuildConfig()
    -- dont remake the frame if it already exists
    if ARWIC_AAM_configFrame ~= nil then return end
    
    -- frame properties
    local fontHeight = 13
    local rowHeight = 20
    local titleBarHeight = 20
    local textOffset = 15

    -- main frame
    local configFrame = CreateFrame("Frame", "ARWIC_AAM_configFrame", UIParent)
    configFrame:SetFrameStrata("HIGH")
    configFrame:SetPoint("CENTER",0,0)
    configFrame.texture = configFrame:CreateTexture(nil, "BACKGROUND")
    configFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    configFrame.texture:SetAllPoints(configFrame)
    configFrame:EnableMouse(true)
    configFrame:SetMovable(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    configFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    configFrame:SetWidth(600)
    configFrame:SetHeight(800)

    -- title bar
    local titleBar = CreateFrame("FRAME", "AAM_configTitleBarFrame", configFrame)
    titleBar:SetPoint("TOP", configFrame)
    titleBar:SetPoint("LEFT", configFrame)
    titleBar:SetPoint("RIGHT", configFrame)
    titleBar:SetHeight(titleBarHeight)
    titleBar.texture = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
    titleBar.texture:SetAllPoints(titleBar)
    NewLabel(titleBar, 20, "Arwic Alt Manager: Config"):SetAllPoints(titleBar)
    
    -- close button
    local closeButton = CreateFrame("BUTTON", "AAM_configCloseButton", AAM_titleBarFrame)
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton.texture = closeButton:CreateTexture(nil, "BACKGROUND")
    closeButton.texture:SetColorTexture(0.7, 0.0, 0.0, 1.0)
    closeButton.texture:SetAllPoints(closeButton)
    closeButton:SetScript("OnClick", function()
        configFrame:Hide()
    end)

    local realmFrame = CreateFrame("FRAME", "AAM_configRealmDisplayFrame", configFrame)
    realmFrame:SetPoint("TOPLEFT")
    realmFrame:SetWidth(150)
    realmFrame:SetPoint("BOTTOM", configFrame, "BOTTOM")
    local realmFrameLabel = NewLabel(realmFrame, fontHeight, "Realm Display:")
    local lastRealmCheckBox = realmFrameLabel
    for realmKey, realmValue in pairs(ArwicAltManagerDB.Realms) do
        local realmCheckBox = CreateFrame("CheckButton", "AAM_config_realm_display_" .. realmKey, realmFrame, "ChatConfigCheckButtonTemplate")
        _G["AAM_config_realm_display_" .. realmKey .. "Text"]:SetText("Realm: " .. realmKey)
        realmCheckBox:SetPoint("TOPLEFT", lastRealmCheckBox, "TOPLEFT")
        realmCheckBox.tooltip = "Requires Reload"
        lastRealmCheckBox = realmCheckBox
    end
end

function ARWIC_AAM_ToggleConfig()
    local firstTime = false
    if not ARWIC_AAM_configFrame then
        firstTime = true
    end
    BuildConfig()
    if not firstTime then
        ARWIC_AAM_configFrame:SetShown(not ARWIC_AAM_configFrame:IsVisible())
    end
end

function ARWIC_AAM_ShowConfig()
    BuildConfig()
    ARWIC_AAM_configFrame:Show()
end

function ARWIC_AAM_HideConfig()
    ARWIC_AAM_configFrame:Hide()
end


function AAM_InitConfigDB()
    if not ArwicAltManagerDB then ArwicAltManagerDB = {} end
    if not ArwicAltManagerDB.Config then ArwicAltManagerDB.Config = {} end
    local config = ArwicAltManagerDB.Config
    if not config.GoldThreshold then config.GoldThreshold = 10000 end
    if not config.MountSpeedThreshold then config.MountSpeedThreshold = 310 end
    if not config.ArtifactRankThreshold then config.ArtifactRankThreshold = 52 end
    if not config.OrderHallResourcesThreshold then config.OrderHallResourcesThreshold = 4000 end
    if not config.LevelThreshold then config.LevelThreshold = 110 end

end

AAM_InitConfigDB()