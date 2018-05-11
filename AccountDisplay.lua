local dataLabels = {}
local events = {}

local function Config()
    return ArwicAltManagerDB.Config
end

local function ErrorColor()
    return 0.85, 0.33, 0.25
end

local function DefaultColor()
    return 1.0, 1.0, 1.0
end

local function TooltipHeaderColor()
    return 1, 1, 1
end

local function SuccessColor()
    return 0.0, 1.0, 0.0
end

local function FormatBool(b)
    if b then 
        return "Yes" 
    else
        return "No" 
    end
end

local function FormatInt(i)
    return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function FormatTime(timeSeconds)
    local days = floor(timeSeconds / 86400)
    local hours = floor((timeSeconds % 86400) / 3600)
    local minutes = floor((timeSeconds % 3600) / 60)
    local seconds = floor(timeSeconds % 60)
    return days, hours, minutes, seconds
end

local function Account()
    return ArwicAltManagerDB.Account
end

local fieldFormatters = {
    ["Mount_VioletSpellwing"] = {
        Label = "Violet Spellwing",
        Order = 500,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Violet Spellwing", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Heroic difficulty or higher in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[253639].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[253639].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Mount_ShackledUrzul"] = {
        Label = "Shackled Urzul",
        Order = 510,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Shackled Urzul", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Mythic difficulty in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[243651].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[243651].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Mount_HellfireInfernal"] = {
        Label = "Hellfire Infernal",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Hellfire Infernal", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Mythic difficulty in the Nighthold.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[171827].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[171827].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Mount_FelblazeInfernal"] = {
        Label = "Felblaze Infernal",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Felblaze Infernal", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Normal difficulty or higher in the Nighthold.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[213134].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[213134].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Mount_AbyssWorm"] = {
        Label = "Abyss Worm",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Abyss Worm", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Mistress Sassz'ine on Raid Finder difficulty or higher in the Tomb of Sargeras.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[232519].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[232519].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Mount_AntoranCharhound"] = {
        Label = "Antoran Charhound",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Antoran Charhound", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Felhounds of Sargeras on Raid Finder difficulty or higher in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return FormatBool(Account().Mounts[253088].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[253088].IsCollected then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["FieldMedic"] = {
        Label = "Field Medic",
        Order = 600,
        Display = true,
        Value = function()
            return FormatBool(Account().FieldMedic)
        end,
        Color = function()
            if not Account().FieldMedic then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function()
            GameTooltip:SetHyperlink(GetAchievementLink(11139))
            GameTooltip:Show()
        end,
    },
    ["ChosenTransmogs_Cloth"] = {
        Label = "Chosen Cloth",
        Order = 701,
        Display = true,
        Value = function()
            return FormatBool(Account().ChosenTransmogs[1])
        end,
        Color = function()
            if not Account().ChosenTransmogs[1] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Cloth", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a cloth wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
    },
    ["ChosenTransmogs_Leather"] = {
        Label = "Chosen Leather",
        Order = 702,
        Display = true,
        Value = function()
            return FormatBool(Account().ChosenTransmogs[2])
        end,
        Color = function()
            if not Account().ChosenTransmogs[2] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Cloth", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a leather wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
    },
    ["ChosenTransmogs_Mail"] = {
        Label = "Chosen Mail",
        Order = 703,
        Display = true,
        Value = function()
            return FormatBool(Account().ChosenTransmogs[3])
        end,
        Color = function()
            if not Account().ChosenTransmogs[3] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Cloth", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a mail wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
    },
    ["ChosenTransmogs_Plate"] = {
        Label = "Chosen Plate",
        Order = 704,
        Display = true,
        Value = function()
            return FormatBool(Account().ChosenTransmogs[4])
        end,
        Color = function()
            if not Account().ChosenTransmogs[4] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Cloth", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a plate wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
    },
    ["FisherfriendOfTheIsles"] = {
        Label = "Fisherfriend of the Isles",
        Order = 710,
        Display = true,
        Value = function()
            return FormatBool(Account().FisherfriendOfTheIsles)
        end,
        Color = function()
            if not Account().FisherfriendOfTheIsles then
                return ErrorColor()
            end
            return DefaultColor()
        end,
        Tooltip = function()
            GameTooltip:SetHyperlink(GetAchievementLink(11725))
            GameTooltip:Show()
        end,
    },
}

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

function ARWIC_AAM_BuildAccountGrid()
    -- dont remake the frame if it already exists
    if ARWIC_AAM_accountFrame ~= nil then return end
    dataLabels = {}

    -- frame properties
    local fontHeight = 13
    local rowHeight = 20
    local titleBarHeight = 20
    local textOffset = 15

    -- main frame
    local accountFrame = CreateFrame("Frame", "ARWIC_AAM_accountFrame", UIParent)
    accountFrame:SetFrameStrata("HIGH")
    accountFrame:SetPoint("CENTER",0,0)
    accountFrame.texture = accountFrame:CreateTexture(nil, "BACKGROUND")
    accountFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    accountFrame.texture:SetAllPoints(accountFrame)
    accountFrame:EnableMouse(true)
    accountFrame:SetMovable(true)
    accountFrame:RegisterForDrag("LeftButton")
    accountFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    accountFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- title bar
    local titleBar = CreateFrame("FRAME", "AAM_accountTitleBarFrame", accountFrame)
    titleBar:SetPoint("TOP", accountFrame)
    titleBar:SetPoint("LEFT", accountFrame)
    titleBar:SetPoint("RIGHT", accountFrame)
    titleBar:SetHeight(titleBarHeight)
    titleBar.texture = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
    titleBar.texture:SetAllPoints(titleBar)
    local titleBarText = NewLabel(titleBar, 20, "Arwic Alt Manager: Account")
    titleBarText:SetAllPoints(titleBar)
    
    -- close button
    local closeButton = CreateFrame("BUTTON", "AAM_accountCloseButton", titleBar, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetScript("OnClick", function()
        accountFrame:Hide()
    end)

    -- config button
    local configButton = CreateFrame("BUTTON", "AAM_accountConfigButton", titleBar, "OptionsBoxTemplate")
    configButton:SetPoint("TOPRIGHT", closeButton, "TOPLEFT")
    configButton:SetWidth(titleBarHeight)
    configButton:SetHeight(titleBarHeight)
    configButton:SetScript("OnClick", function()
        accountFrame:Hide()
        ARWIC_AAM_ShowConfig()
    end)

    -- row headers
    local headerCol = CreateFrame("FRAME", "AAM_accountHeaderCol", accountFrame)
    headerCol:SetPoint("TOP", titleBar, "BOTTOM")
    headerCol:SetPoint("LEFT", accountFrame, "LEFT")
    local maxLabelWidth = 0
    local lastCellFrame = titleBar
    local i = 0
    for formatterKey, formatter in spairs(fieldFormatters, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if formatter.Display then
            -- make a cell
            local cellFrame = CreateFrame("FRAME", "AAM_accountCell_" .. formatterKey, headerCol)
            cellFrame:SetHeight(rowHeight)
            cellFrame:SetPoint("LEFT", headerCol, "LEFT")
            cellFrame:SetPoint("RIGHT", headerCol, "RIGHT")
            cellFrame:SetPoint("TOP", lastCellFrame, "BOTTOM")
            -- make the label and put it in the cell
            local lbl = NewLabel(cellFrame, fontHeight, formatter.Label)
            local lblWidth = lbl:GetStringWidth()
            if lblWidth > maxLabelWidth then
                maxLabelWidth = lblWidth
            end
            --lbl:SetAllPoints(cellFrame)
            lbl:SetPoint("LEFT", cellFrame, "LEFT", 5, 0)
            -- create the row frame
            local rowFrame = CreateFrame("FRAME", "AAM_accountRowFrame_" .. formatterKey, accountFrame)
            rowFrame:SetHeight(rowHeight)
            rowFrame:SetPoint("TOP", cellFrame, "TOP")
            rowFrame:SetPoint("LEFT", accountFrame, "LEFT")
            rowFrame:SetPoint("RIGHT", accountFrame, "RIGHT")
            -- give the row a texture if required
            if i % 2 == 0 then
                rowFrame.texture = rowFrame:CreateTexture(nil, "BACKGROUND")
                rowFrame.texture:SetColorTexture(0.15, 0.15, 0.15, 1.0)
                rowFrame.texture:SetAllPoints(rowFrame)
            end
            -- keep track of the last itteration
            lastCellFrame = cellFrame
            i = i + 1
        end
    end
    accountFrame:SetHeight(titleBarHeight + i * rowHeight)
    headerCol:SetWidth(maxLabelWidth + textOffset * 2)

    -- populate the grid with data
    local dataCol = CreateFrame("FRAME", "AAM_accountDataCol", accountFrame)
    dataCol:SetPoint("TOP", titleBar, "BOTTOM")
    dataCol:SetPoint("LEFT", headerCol, "RIGHT")

    local totalWidthSoFar = 0

    local maxLabelWidth = 0
    local lastCellFrame = titleBar
    for formatterKey, formatter in spairs(fieldFormatters, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if formatter.Display then
            -- make the cell
            local cellFrame = CreateFrame("FRAME", "AAM_accountDataCell_" .. formatterKey, dataCol)
            cellFrame:SetHeight(rowHeight)
            cellFrame:SetPoint("LEFT", dataCol, "LEFT")
            cellFrame:SetPoint("RIGHT", dataCol, "RIGHT")
            cellFrame:SetPoint("TOP", lastCellFrame, "BOTTOM")
            -- make the label and put it in the cell
            local lbl = NewLabel(cellFrame, fontHeight, formatter.Value())
            table.insert(dataLabels, {
                ["lbl"] = lbl,
                ["formatter"] = formatter,
            })
            local lblWidth = lbl:GetStringWidth()
            if lblWidth > maxLabelWidth then
                maxLabelWidth = lblWidth
            end
            lbl:SetAllPoints(cellFrame)
            lbl:SetTextColor(formatter.Color())
            -- register the label's tooltip
            cellFrame:SetScript("OnEnter", function(sender)
                GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
                if formatter.Tooltip ~= nil then
                    formatter.Tooltip()
                end
            end)
            cellFrame:SetScript("OnLeave", function(sender)
                GameTooltip_Hide()
            end)
            -- keep track of the last itteration
            lastCellFrame = cellFrame
        end
    end
    -- set the column width to the widest labels width
    dataCol:SetWidth(maxLabelWidth + textOffset * 2)
    local frameWidth = titleBarText:GetStringWidth() + 200
    if frameWidth < headerCol:GetWidth() + dataCol:GetWidth() then
        frameWidth = headerCol:GetWidth() + dataCol:GetWidth()
    end
    accountFrame:SetWidth(frameWidth)
end

function ARWIC_AAM_UpdateAccountGrid()
    -- make sure we have a grid
    ARWIC_AAM_BuildAccountGrid()
    -- update the values in the grid
    for _, v in pairs(dataLabels) do
        v.lbl:SetText(v.formatter.Value())
        v.lbl:SetTextColor(v.formatter.Color())
    end
end

-- loads display and order of field formatters from file
local function InitFormatters()
    -- create the config table if needed
    if ArwicAltManagerDB.Config.AccountFieldFormatters == nil then
        ArwicAltManagerDB.Config.AccountFieldFormatters = {}
    end
    -- load the config table or set it to defaults
    for k, v in pairs(fieldFormatters) do
        -- check if the field exists
        if ArwicAltManagerDB.Config.AccountFieldFormatters[k] == nil then
            -- it doesnt so copy defaults to the config
            ArwicAltManagerDB.Config.AccountFieldFormatters[k] = {}
            ArwicAltManagerDB.Config.AccountFieldFormatters[k].Display = v.Display
            ArwicAltManagerDB.Config.AccountFieldFormatters[k].Order = tonumber(v.Order)
        else
            -- it does so copy config to the formatter
            v.Display = ArwicAltManagerDB.Config.AccountFieldFormatters[k].Display
            v.Order = tonumber(ArwicAltManagerDB.Config.AccountFieldFormatters[k].Order)
        end
    end
end

function ARWIC_AAM_ToggleAccount()
    ARWIC_AAM_UpdateAccountGrid()
    ARWIC_AAM_accountFrame:SetShown(not ARWIC_AAM_accountFrame:IsVisible())
end

function ARWIC_AAM_ShowAccount()
    ARWIC_AAM_UpdateAccountGrid()
    ARWIC_AAM_accountFrame:Show()
end

function ARWIC_AAM_HideAccount()
    ARWIC_AAM_accountFrame:Hide()
end

function events:PLAYER_ENTERING_WORLD(...)
    -- init formatters
    InitFormatters()
end

local function RegisterEvents()
    local eventFrame = CreateFrame("FRAME", "AAM_accountEventFrame")
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...)
    end)
    for k, v in pairs(events) do
        eventFrame:RegisterEvent(k)
    end
end

RegisterEvents()
