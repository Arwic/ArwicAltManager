local dataLabels = {}

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

function ArwicAltManager.BuildCharacterGrid()
    --ArwicAltManager.RestoreDefaultFields()
    ArwicAltManager.InitCustomFields()

    -- dont remake the frame if it already exists
    if ARWIC_AAM_mainFrame ~= nil then return end
    dataLabels = {}

    -- frame properties
    local fontHeight = 13
    local rowHeight = 20
    local titleBarHeight = 20
    local textOffset = 15

    -- main frame
    local mainFrame = CreateFrame("Frame", "ARWIC_AAM_mainFrame", UIParent)
    table.insert(UISpecialFrames, mainFrame:GetName()) -- make frame close with escape
    mainFrame:SetFrameStrata("HIGH")
    mainFrame:SetPoint("CENTER",0,0)
    mainFrame.texture = mainFrame:CreateTexture(nil, "BACKGROUND")
    mainFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    mainFrame.texture:SetAllPoints(mainFrame)
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    mainFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    local oldHide = mainFrame.Hide
    mainFrame.Hide = function()
        ArwicAltManager.ManuallyOpen = false
        oldHide(mainFrame)
    end

    -- title bar
    local titleBar = CreateFrame("FRAME", "AAM_titleBarFrame", mainFrame)
    titleBar:SetPoint("TOP", mainFrame)
    titleBar:SetPoint("LEFT", mainFrame)
    titleBar:SetPoint("RIGHT", mainFrame)
    titleBar:SetHeight(titleBarHeight)
    titleBar.texture = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
    titleBar.texture:SetAllPoints(titleBar)
    NewLabel(titleBar, 20, "Arwic Alt Manager"):SetAllPoints(titleBar)
    
    -- close button
    local closeButton = CreateFrame("BUTTON", "AAM_closeButton", titleBar, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetScript("OnClick", function()
        mainFrame:Hide()
    end)

    -- config button
    local configButton = CreateFrame("BUTTON", "AAM_configButton", titleBar, "OptionsBoxTemplate")
    configButton:SetPoint("TOPRIGHT", closeButton, "TOPLEFT")
    configButton:SetWidth(titleBarHeight)
    configButton:SetHeight(titleBarHeight)
    configButton:SetScript("OnClick", function()
        mainFrame:Hide()
        ArwicAltManager.ShowConfig()
    end)
    configButton:SetScript("OnEnter", function(sender)
        GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
        GameTooltip:SetText("Open Config")
        GameTooltip:Show()
    end)
    configButton:SetScript("OnLeave", function()
        GameTooltip_Hide()
    end)

    -- account button
    local accountButton = CreateFrame("BUTTON", "AAM_accountButton", titleBar, "OptionsBoxTemplate")
    accountButton:SetPoint("TOPRIGHT", configButton, "TOPLEFT")
    accountButton:SetWidth(titleBarHeight)
    accountButton:SetHeight(titleBarHeight)
    accountButton:SetScript("OnClick", function()
        mainFrame:Hide()
        ArwicAltManager.ShowAccountGrid()
    end)
    accountButton:SetScript("OnEnter", function(sender)
        GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
        GameTooltip:SetText("View Account Wide Data")
        GameTooltip:Show()
    end)
    accountButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- row headers
    local headerCol = CreateFrame("FRAME", "AAM_headerCol", mainFrame)
    headerCol:SetPoint("TOP", titleBar, "BOTTOM")
    headerCol:SetPoint("LEFT", mainFrame, "LEFT")
    local maxLabelWidth = 0
    local lastCellFrame = titleBar
    local i = 0
    for formatterKey, formatter in spairs(ArwicAltManagerDB.Fields.Character, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if not formatter.Internal and formatter.Display then
            -- make a cell
            local cellFrame = CreateFrame("FRAME", "AAM_charCell_" .. formatterKey, headerCol)
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
            local rowFrame = CreateFrame("FRAME", "AAM_rowFrame_" .. formatterKey, mainFrame)
            rowFrame:SetHeight(rowHeight)
            rowFrame:SetPoint("TOP", cellFrame, "TOP")
            rowFrame:SetPoint("LEFT", mainFrame, "LEFT")
            rowFrame:SetPoint("RIGHT", mainFrame, "RIGHT")
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
    mainFrame:SetHeight(titleBarHeight + i * rowHeight)
    headerCol:SetWidth(maxLabelWidth + textOffset * 2)

    -- populate the grid with character data
    local totalWidthSoFar = 0
    local lastRealmGroup = headerCol
    for realmKey, realmData in pairs(ArwicAltManagerDB.Realms) do
        -- only build the realm and its chars if Display is true
        local charDisplayCount = 0
        for k, v in pairs(realmData.Characters) do
            if v.Display then
                charDisplayCount = charDisplayCount + 1
            end
        end
        if realmData.Display and charDisplayCount > 0 then
            local realmChars = realmData.Characters
            -- make the realm group
            local realmGroup = CreateFrame("FRAME", "AAM_realmGroup_" .. realmKey, mainFrame)
            realmGroup:SetPoint("LEFT", lastRealmGroup, "RIGHT")
            realmGroup:SetPoint("BOTTOM", mainFrame, "BOTTOM")
            realmGroup:SetPoint("TOP", titleBar, "BOTTOM")
            local lastCharCol
            local realmGroupWidthSoFar = 0
            for charKey, char in spairs(realmChars, function(t, a, b)
                    return t[a].Name < t[b].Name
                end) do
                if char.Display then
                    -- make the character coloumn
                    local charCol = CreateFrame("FRAME", "AAM_charCol_" .. realmKey .. "_" .. charKey, realmGroup)
                    if lastCharCol == nil then
                        charCol:SetPoint("LEFT", realmGroup, "LEFT")
                    else
                        charCol:SetPoint("LEFT", lastCharCol, "RIGHT")
                    end
                    charCol:SetPoint("BOTTOM", realmGroup, "BOTTOM")
                    charCol:SetPoint("TOP", titleBar, "BOTTOM")
                    -- make the cells for each field in the character column
                    local maxLabelWidth = 0
                    local lastCellFrame = titleBar
                    for formatterKey, formatter in spairs(ArwicAltManagerDB.Fields.Character, function(t, a, b)
                        return t[a].Order < t[b].Order
                    end) do
                        if not formatter.Internal and formatter.Display and formatter.FuncStr ~= nil then
                            -- make the cell
                            local cellFrame = CreateFrame("FRAME", "AAM_charCell_" .. realmKey .. "_" .. charKey .. "_" .. formatterKey, charCol)
                            cellFrame:SetHeight(rowHeight)
                            cellFrame:SetPoint("LEFT", charCol, "LEFT")
                            cellFrame:SetPoint("RIGHT", charCol, "RIGHT")
                            cellFrame:SetPoint("TOP", lastCellFrame, "BOTTOM")
                            -- make the label and put it in the cell
                            local lbl = NewLabel(cellFrame, fontHeight, formatter.Value()(char))
                            table.insert(dataLabels, {
                                ["lbl"] = lbl,
                                ["formatter"] = formatter,
                                ["char"] = char
                            })
                            local lblWidth = lbl:GetStringWidth()
                            if lblWidth > maxLabelWidth then
                                maxLabelWidth = lblWidth
                            end
                            lbl:SetAllPoints(cellFrame)
                            --lbl:SetTextColor(formatter.Color(char))
                            -- register the label's tooltip
                            cellFrame:SetScript("OnEnter", function(sender)
                                GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
                                if formatter.Tooltip ~= nil then
                                    formatter.Tooltip()(char)
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
                    charCol:SetWidth(maxLabelWidth + textOffset * 2)
                    lastCharCol = charCol
                    realmGroupWidthSoFar = realmGroupWidthSoFar + charCol:GetWidth()
                end
            end
            realmGroup:SetWidth(realmGroupWidthSoFar)
            totalWidthSoFar = totalWidthSoFar + realmGroup:GetWidth()
            lastRealmGroup = realmGroup
        end
    end
    mainFrame:SetWidth(headerCol:GetWidth() + totalWidthSoFar)
    mainFrame:SetShown(false)
end

function ArwicAltManager.UpdateCharacterGrid()
    -- make sure we have a grid
    ArwicAltManager.BuildCharacterGrid()
    ArwicAltManager.UpdateCharacterData()
    -- update the values in the grid
    for _, v in pairs(dataLabels) do
        v.lbl:SetText(v.formatter.Value()(v.char))
        --v.lbl:SetTextColor(v.formatter.Color()(v.char))
    end
end

function ArwicAltManager.ShowCharacterGrid()
    ArwicAltManager.HideConfig()
    ArwicAltManager.HideAccountGrid()
    ArwicAltManager.UpdateCharacterGrid()
    ARWIC_AAM_mainFrame:Show()
end

function ArwicAltManager.HideCharacterGrid()
    if ARWIC_AAM_mainFrame ~= nil then
        ARWIC_AAM_mainFrame:Hide()
    end
end

function ArwicAltManager.ToggleCharacterGrid()
    ArwicAltManager.BuildCharacterGrid()
    if ARWIC_AAM_mainFrame:IsShown() then
        ArwicAltManager.HideCharacterGrid()
    else
        ArwicAltManager.ShowCharacterGrid()
    end
end

function ArwicAltManager.InitCustomFields()
    -- load user defined functions
    for k, v in pairs(ArwicAltManagerDB.Fields.Character) do
        if v.FuncStr ~= nil then
            if v.FuncStr.Update then
                v.Update = loadstring("return " .. v.FuncStr.Update, format("Field.%s.Update", k))
            end
            if v.FuncStr.Value then
                v.Value = loadstring("return " .. v.FuncStr.Value, format("Field.%s.Value", k))
            end
            if v.FuncStr.Tooltip then
                v.Tooltip = loadstring("return " .. v.FuncStr.Tooltip, format("Field.%s.Tooltip", k))
            end
        end
    end
end
