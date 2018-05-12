local dataLabels = {}

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

function ArwicAltManager.BuildAccountGrid()
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
    table.insert(UISpecialFrames, accountFrame:GetName()) -- make frame close with escape
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

    -- character button
    local characterButton = CreateFrame("BUTTON", "AAM_accountCharacterButton", titleBar, "OptionsBoxTemplate")
    characterButton:SetPoint("TOPRIGHT", configButton, "TOPLEFT")
    characterButton:SetWidth(titleBarHeight)
    characterButton:SetHeight(titleBarHeight)
    characterButton:SetScript("OnClick", function()
        accountFrame:Hide()
        ArwicAltManager.ShowCharacterGrid()
    end)
    characterButton:SetScript("OnEnter", function(sender)
        GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
        GameTooltip:SetText("View Character Data")
        GameTooltip:Show()
    end)
    characterButton:SetScript("OnLeave", function()
        GameTooltip_Hide()
    end)

    -- row headers
    local headerCol = CreateFrame("FRAME", "AAM_accountHeaderCol", accountFrame)
    headerCol:SetPoint("TOP", titleBar, "BOTTOM")
    headerCol:SetPoint("LEFT", accountFrame, "LEFT")
    local maxLabelWidth = 0
    local lastCellFrame = titleBar
    local i = 0
    for formatterKey, formatter in spairs(ArwicAltManager.Fields.Account, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if formatter.Internal == nil and formatter.Display then
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
    for formatterKey, formatter in spairs(ArwicAltManager.Fields.Account, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if formatter.Internal == nil and formatter.Display then
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
    local frameWidth = titleBarText:GetStringWidth() + 50
    if frameWidth < headerCol:GetWidth() + dataCol:GetWidth() then
        frameWidth = headerCol:GetWidth() + dataCol:GetWidth()
    end
    accountFrame:SetWidth(frameWidth)
    accountFrame:SetShown(false)
end

function ArwicAltManager.UpdateAccountGrid()
    -- make sure we have a grid
    ArwicAltManager.BuildAccountGrid()
    ArwicAltManager.UpdateAccountData()
    -- update the values in the grid
    for _, v in pairs(dataLabels) do
        v.lbl:SetText(v.formatter.Value())
        v.lbl:SetTextColor(v.formatter.Color())
    end
end

function ArwicAltManager.ShowAccountGrid()
    ArwicAltManager.HideConfig()
    ArwicAltManager.HideCharacterGrid()
    ArwicAltManager.UpdateAccountGrid()
    ARWIC_AAM_accountFrame:Show()
end

function ArwicAltManager.HideAccountGrid()
    if ARWIC_AAM_accountFrame ~= nil then
        ARWIC_AAM_accountFrame:Hide()
    end
end

function ArwicAltManager.ToggleAccountGrid()
    ArwicAltManager.BuildAccountGrid()
    if ARWIC_AAM_accountFrame:IsShown() then
        ArwicAltManager.HideAccountGrid()
    else
        ArwicAltManager.ShowAccountGrid()
    end
end
