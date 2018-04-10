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

end

function ARWIC_AAM_ToggleConfig()
    BuildConfig()
    ARWIC_AAM_configFrame:SetShown(not ARWIC_AAM_configFrame:IsVisible())
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
    if not config.RealmsToDisplay then config.RealmsToDisplay = {} end

    local fields = {
        ["Name"] = {
            Display = true,
            Order = 0,
        },
        ["Class"] = {
            Display = true,
            Order = 0,
        },
        ["Realm"] = {
            Display = true,
            Order = 0,
        },
        ["Faction"] = {
            Display = true,
            Order = 0,
        },
        ["Race"] = {
            Display = true,
            Order = 0,
        },
        ["Gender"] = {
            Display = true,
            Order = 0,
        },
        ["Timestamp"] = {
            Display = true,
            Order = 0,
        },
        ["Money"] = {
            Display = true,
            Order = 0,
        },
        ["ClassCampaign"] = {
            Display = true,
            Order = 0,
        },
        ["ClassMount"] = {
            Display = true,
            Order = 0,
        },
        ["Level"] = {
            Display = true,
            Order = 0,
        },
        ["MountSpeed"] = {
            Display = true,
            Order = 0,
        },
        ["OrderHallUpgrades"] = {
            Display = true,
            Order = 0,
        },
        ["BalanceOfPower"] = {
            Display = true,
            Order = 0,
        },
        ["KeystoneMaster"] = {
            Display = true,
            Order = 0,
        },
        ["MageTowerPrereq"] = {
            Display = true,
            Order = 0,
        },
        ["MageTower"] = {
            Display = true,
            Order = 0,
        },
        ["TimePlayed"] = {
            Display = true,
            Order = 0,
        },
        ["Artifacts"] = {
            Display = true,
            Order = 0,
        },
        ["OrderHallResouces"] = {
            Display = true,
            Order = 0,
        },
        ["WakeningEssence"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_VioletSpellwing"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_ShackledUrzul"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_HellfireInfernal"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_FelblazeInfernal"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_AbyssWorm"] = {
            Display = true,
            Order = 0,
        },
        ["Mount_AntoranCharhound"] = {
            Display = true,
            Order = 0,
        },
        ["FieldMedic"] = {
            Display = true,
            Order = 0,
        },
        ["ChosenTransmogs_Cloth"] = {
            Display = true,
            Order = 0,
        },
        ["ChosenTransmogs_Leather"] = {
            Display = true,
            Order = 0,
        },
        ["ChosenTransmogs_Mail"] = {
            Display = true,
            Order = 0,
        },
        ["ChosenTransmogs_Plate"] = {
            Display = true,
            Order = 0,
        },
        ["FisherfriendOfTheIsles"] = {
            Display = true,
            Order = 0,
        },
        
    }

end

AAM_InitConfigDB()