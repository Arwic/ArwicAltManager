-- frame properties
local fontHeight = 13
local fontFile = "fonts/ARIALN.ttf"
local titleBarHeight = 20
local framePadding = 10

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

local function BuildAccountFieldDisplayOrder()
    local ITEM_WIDTH = 300
    local ITEM_HEIGHT = 24
    local EDITBOX_WIDTH = 30
    local CHECKBOX_WIDTH = ITEM_WIDTH - EDITBOX_WIDTH
    local BOX_HEIGHT = 500
    local CHAR_INDENT = 20
    local ITEM_SCROLL_JUMP = 4
    local NUM_LIST = floor(BOX_HEIGHT / ITEM_HEIGHT)
    local NUM_ITEMS = 0
    local LABEL_OFFSET_Y = 18
    local LABEL_OFFSET_X = 5
    for fk, fv in pairs(ArwicAltManagerDB.Config.Fields.Account) do
        if not fv.Internal then
            NUM_ITEMS = NUM_ITEMS + 1
        end
    end

    -- create the main frame
    local frame = CreateFrame("FRAME", "AAM_config_accountFieldFrame", ARWIC_AAM_configFrame)

    -- create label above the frame
    local frameLabel = NewLabel(frame, fontHeight * 1.25, "Account Data Fields"):SetPoint("TOPLEFT", frame, "TOPLEFT", LABEL_OFFSET_X, LABEL_OFFSET_Y)

    -- set up main frame
    frame:SetSize(ITEM_WIDTH, BOX_HEIGHT)
    frame:SetPoint("TOPLEFT", AAM_config_fieldFrame, "TOPRIGHT", framePadding, 0)
    frame.texture = frame:CreateTexture(nil, "BACKGROUND")
    frame.texture:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    frame.texture:SetAllPoints(frame)
    frame:SetPoint("CENTER")
    -- create list items
    frame.list = {}
    for i = 1, NUM_LIST do
        frame.list[i] = {}
        frame.list[i].Order = CreateFrame("EDITBOX", frame:GetName() .. "_list_order_" .. i, frame)
        frame.list[i].Order:SetNumeric(true)
        frame.list[i].Order:SetFont("fonts/ARIALN.ttf", fontHeight)
        frame.list[i].Order:SetSize(EDITBOX_WIDTH, ITEM_HEIGHT)
        frame.list[i].Order:SetMaxLetters(4)
        frame.list[i].Order:SetAutoFocus(false)
        frame.list[i].Order:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, (i - 1) * -ITEM_HEIGHT - 8)
        frame.list[i].Display = CreateFrame("CHECKBUTTON", frame:GetName() .. "_list_display_" .. i, frame, "ChatConfigCheckButtonTemplate")
        frame.list[i].Display:SetSize(CHECKBOX_WIDTH, ITEM_HEIGHT)
        frame.list[i].Display:SetPoint("TOPLEFT", frame.list[i].Order, "TOPRIGHT")
    end
    -- create scrollframe
    frame.scrollFrame = CreateFrame("ScrollFrame", frame:GetName() .. "ScrollFrame", frame, "FauxScrollFrameTemplate")
    frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -6)
    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 6)
    frame.scrollFrame:SetScript("OnShow", frame.ScrollFrameUpdate)
    frame.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ITEM_HEIGHT, frame.ScrollFrameUpdate)
    end)

    local function GetFieldListItem(index)
        local counter = 0
        for fk, fv in spairs(ArwicAltManagerDB.Config.Fields.Account, function(t, a, b)
            return t[a].Order < t[b].Order
        end) do
            if not fv.Internal then
                counter = counter + 1
                if counter == index then
                    return fk, fv.Display, fv.Order
                end
            end
        end
    end

    frame.ScrollFrameUpdate = function()
        local offset = FauxScrollFrame_GetOffset(frame.scrollFrame)
        FauxScrollFrame_Update(frame.scrollFrame, NUM_ITEMS, 12, ITEM_HEIGHT)
        for i = 1, NUM_LIST do
            local idx = offset + i
            if idx <= NUM_ITEMS then
                local name, checked, order = GetFieldListItem(idx)
                local ebOrder = frame.list[i].Order
                ebOrder:SetPoint("LEFT", frame, "LEFT")
                ebOrder:SetText(order)
                ebOrder:SetScript("OnTextChanged", function(sender)
                    local text = ebOrder:GetText()
                    if text == "" then text = "0" end
                    ArwicAltManagerDB.Config.Fields.Account[name].Order = tonumber(text)
                end)
                ebOrder:Show()
                local cbDisplay = frame.list[i].Display
                cbDisplay:SetChecked(checked)
                cbDisplay:SetPoint("LEFT", eb, "RIGHT")
                cbDisplay:SetSize(ITEM_HEIGHT, ITEM_HEIGHT)
                _G[cbDisplay:GetName() .. "Text"]:SetText(name)
                cbDisplay:SetScript("OnClick", function(sender)
                    ArwicAltManagerDB.Config.Fields.Account[name].Display = cbDisplay:GetChecked()
                end)
                cbDisplay:Show()
            else
                frame.list[i].Display:Hide()
                frame.list[i].Order:Hide()
            end
        end
    end

    frame.scrollFrame.ScrollBar:SetValue(0)
    frame.ScrollFrameUpdate()

    return frame
end

local function BuildCharacterFieldDisplayOrder()
    local ITEM_WIDTH = 300
    local ITEM_HEIGHT = 24
    local EDITBOX_WIDTH = 30
    local CHECKBOX_WIDTH = ITEM_WIDTH - EDITBOX_WIDTH
    local BOX_HEIGHT = 500
    local CHAR_INDENT = 20
    local ITEM_SCROLL_JUMP = 4
    local NUM_LIST = floor(BOX_HEIGHT / ITEM_HEIGHT)
    local NUM_ITEMS = 0
    local LABEL_OFFSET_Y = 18
    local LABEL_OFFSET_X = 5
    for fk, fv in pairs(ArwicAltManagerDB.Config.Fields.Character) do
        if not fv.Internal then
            NUM_ITEMS = NUM_ITEMS + 1
        end
    end

    -- create the main frame
    local frame = CreateFrame("FRAME", "AAM_config_fieldFrame", ARWIC_AAM_configFrame)

    -- create label above the frame
    local frameLabel = NewLabel(frame, fontHeight * 1.25, "Character Data Fields"):SetPoint("TOPLEFT", frame, "TOPLEFT", LABEL_OFFSET_X, LABEL_OFFSET_Y)

    -- set up main frame
    frame:SetSize(ITEM_WIDTH, BOX_HEIGHT)
    frame:SetPoint("TOPLEFT", AAM_config_realmDisplayFrame, "TOPRIGHT", framePadding, 0)
    frame.texture = frame:CreateTexture(nil, "BACKGROUND")
    frame.texture:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    frame.texture:SetAllPoints(frame)
    frame:SetPoint("CENTER")
    -- create list items
    frame.list = {}
    for i = 1, NUM_LIST do
        frame.list[i] = {}
        frame.list[i].Order = CreateFrame("EDITBOX", frame:GetName() .. "_list_order_" .. i, frame)
        frame.list[i].Order:SetNumeric(true)
        frame.list[i].Order:SetFont("fonts/ARIALN.ttf", fontHeight)
        frame.list[i].Order:SetSize(EDITBOX_WIDTH, ITEM_HEIGHT)
        frame.list[i].Order:SetMaxLetters(4)
        frame.list[i].Order:SetAutoFocus(false)
        frame.list[i].Order:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, (i - 1) * -ITEM_HEIGHT - 8)
        frame.list[i].Display = CreateFrame("CHECKBUTTON", frame:GetName() .. "_list_display_" .. i, frame, "ChatConfigCheckButtonTemplate")
        frame.list[i].Display:SetSize(CHECKBOX_WIDTH, ITEM_HEIGHT)
        frame.list[i].Display:SetPoint("TOPLEFT", frame.list[i].Order, "TOPRIGHT")
    end
    -- create scrollframe
    frame.scrollFrame = CreateFrame("ScrollFrame", frame:GetName() .. "ScrollFrame", frame, "FauxScrollFrameTemplate")
    frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -6)
    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 6)
    frame.scrollFrame:SetScript("OnShow", frame.ScrollFrameUpdate)
    frame.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ITEM_HEIGHT, frame.ScrollFrameUpdate)
    end)

    local function GetFieldListItem(index)
        local counter = 0
        for fk, fv in spairs(ArwicAltManagerDB.Config.Fields.Character, function(t, a, b)
            return t[a].Order < t[b].Order
        end) do
            if not fv.Internal then
                counter = counter + 1
                if counter == index then
                    return fk, fv.Display, fv.Order
                end
            end
        end
    end

    frame.ScrollFrameUpdate = function()
        local offset = FauxScrollFrame_GetOffset(frame.scrollFrame)
        FauxScrollFrame_Update(frame.scrollFrame, NUM_ITEMS, 12, ITEM_HEIGHT)
        for i = 1, NUM_LIST do
            local idx = offset + i
            if idx <= NUM_ITEMS then
                local name, checked, order = GetFieldListItem(idx)
                local ebOrder = frame.list[i].Order
                ebOrder:SetPoint("LEFT", frame, "LEFT")
                ebOrder:SetText(order)
                ebOrder:SetScript("OnTextChanged", function(sender)
                    local text = ebOrder:GetText()
                    if text == "" then text = "0" end
                    ArwicAltManagerDB.Config.Fields.Character[name].Order = tonumber(text)
                end)
                ebOrder:Show()
                local cbDisplay = frame.list[i].Display
                cbDisplay:SetChecked(checked)
                cbDisplay:SetPoint("LEFT", eb, "RIGHT")
                cbDisplay:SetSize(ITEM_HEIGHT, ITEM_HEIGHT)
                _G[cbDisplay:GetName() .. "Text"]:SetText(name)
                cbDisplay:SetScript("OnClick", function(sender)
                    ArwicAltManagerDB.Config.Fields.Character[name].Display = cbDisplay:GetChecked()
                end)
                cbDisplay:Show()
            else
                frame.list[i].Display:Hide()
                frame.list[i].Order:Hide()
            end
        end
    end

    frame.scrollFrame.ScrollBar:SetValue(0)
    frame.ScrollFrameUpdate()

    return frame
end

local function BuildRealmDisplay()
    local ITEM_WIDTH = 250
    local ITEM_HEIGHT = 24
    local BOX_HEIGHT = 500
    local CHAR_INDENT = 20
    local ITEM_SCROLL_JUMP = 4
    local NUM_LIST = floor(BOX_HEIGHT / ITEM_HEIGHT)
    local NUM_ITEMS = 0
    local LABEL_OFFSET_Y = 18
    local LABEL_OFFSET_X = 5
    for realmKey, realmValue in pairs(ArwicAltManagerDB.Realms) do
        NUM_ITEMS = NUM_ITEMS + 1
        for charKey, charValue in pairs(realmValue.Characters) do
            NUM_ITEMS = NUM_ITEMS + 1
        end
    end

    -- create the main frame
    local frame = CreateFrame("FRAME", "AAM_config_realmDisplayFrame", ARWIC_AAM_configFrame)

    -- create label above the frame
    local frameLabel = NewLabel(frame, fontHeight * 1.25, "Realms and Characters"):SetPoint("TOPLEFT", frame, "TOPLEFT", LABEL_OFFSET_X, LABEL_OFFSET_Y)

    -- set up main frame
    frame:SetSize(ITEM_WIDTH, BOX_HEIGHT)
    frame:SetPoint("TOPLEFT", framePadding, -(titleBarHeight + LABEL_OFFSET_Y))
    frame.texture = frame:CreateTexture(nil, "BACKGROUND")
    frame.texture:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    frame.texture:SetAllPoints(frame)
    frame:SetPoint("CENTER")
    -- create list items
    frame.list = {}
    for i = 1, NUM_LIST do
        frame.list[i] = CreateFrame("CHECKBUTTON", frame:GetName() .. "_list_" .. i, frame, "ChatConfigCheckButtonTemplate")
        frame.list[i]:SetSize(ITEM_WIDTH, ITEM_HEIGHT)
        frame.list[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, (i - 1) * -ITEM_HEIGHT - 8)
    end
    -- create scrollframe
    frame.scrollFrame = CreateFrame("ScrollFrame", frame:GetName() .. "ScrollFrame", frame, "FauxScrollFrameTemplate")
    frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -6)
    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 6)
    frame.scrollFrame:SetScript("OnShow", frame.ScrollFrameUpdate)
    frame.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ITEM_HEIGHT, frame.ScrollFrameUpdate)
    end)

    local function GetDisplayListItem(index)
        local counter = 0
        for rk, rv in pairs(ArwicAltManagerDB.Realms) do
            counter = counter + 1
            if counter == index then
                return nil, rk, rv.Display, "Realm"
            end
            for ck, cv in pairs(rv.Characters) do
                counter = counter + 1
                if counter == index then
                    return ck, rk, cv.Display, format("Level %d %s %s", cv.Level, cv.Race, cv.Class)
                end
            end
        end
    end

    frame.ScrollFrameUpdate = function()
        local offset = FauxScrollFrame_GetOffset(frame.scrollFrame)
        FauxScrollFrame_Update(frame.scrollFrame, NUM_ITEMS, 12, ITEM_HEIGHT)
        for i = 1, NUM_LIST do
            local idx = offset + i
            if idx <= NUM_ITEMS then
                local charName, realmName, checked, tooltip = GetDisplayListItem(idx)
                local cb = frame.list[i]
                cb:SetChecked(checked)
                cb.tooltip = tooltip
                if charName == nil then
                    cb:SetPoint("LEFT", frame, "LEFT")
                    cb:SetSize(ITEM_HEIGHT, ITEM_HEIGHT)
                    _G[cb:GetName() .. "Text"]:SetText(realmName)
                    cb:SetScript("OnClick", function(sender)
                        ArwicAltManagerDB.Realms[realmName].Display = cb:GetChecked()
                    end)
                else
                    cb:SetPoint("LEFT", frame, "LEFT", 200, 0)
                    cb:SetSize(ITEM_HEIGHT, ITEM_HEIGHT)
                    _G[cb:GetName() .. "Text"]:SetText("      " .. charName)
                    cb:SetScript("OnClick", function(sender)
                        ArwicAltManagerDB.Realms[realmName].Characters[charName].Display = cb:GetChecked()
                    end)
                end
                cb:Show()
            else
                frame.list[i]:Hide()
            end
        end
    end

    frame.scrollFrame.ScrollBar:SetValue(0)
    frame.ScrollFrameUpdate()

    return frame
end

function ArwicAltManager.BuildConfig()
    -- dont remake the frame if it already exists
    if ARWIC_AAM_configFrame ~= nil then return end
    local warningHeight = 50

    -- main frame
    local configFrame = CreateFrame("Frame", "ARWIC_AAM_configFrame", UIParent)
    configFrame:SetFrameStrata("HIGH")
    configFrame:SetPoint("CENTER", 0, 0)
    configFrame.texture = configFrame:CreateTexture(nil, "BACKGROUND")
    configFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    configFrame.texture:SetAllPoints(configFrame)
    configFrame:EnableMouse(true)
    configFrame:SetMovable(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    configFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    configFrame:SetWidth(800)
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
    local closeButton = CreateFrame("BUTTON", "AAM_configCloseButton", titleBar, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetScript("OnClick", function()
        configFrame:Hide()
    end)

    -- realm display
    local realmDisplayFrame = BuildRealmDisplay()
    -- field display order
    local fieldDisplayOrderFrame = BuildCharacterFieldDisplayOrder()
    -- account field display order
    local accountFieldDisplayOrderFrame = BuildAccountFieldDisplayOrder()
    
    local reloadButton = CreateFrame("BUTTON", "AAM_config_reloadButton", configFrame)
    reloadButton:SetText("RELOAD")
    reloadButton:SetPoint("BOTTOM")
    reloadButton:SetWidth(150)
    reloadButton:SetHeight(30)

    local reloadButton = CreateFrame("BUTTON", "AAM_config_reloadButton", configFrame, "UIGoldBorderButtonTemplate")
    reloadButton:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, framePadding)
    reloadButton:SetWidth(150)
    reloadButton:SetHeight(30)
    reloadButton:SetText("Reload")
    reloadButton:SetScript("OnClick", function()
        ReloadUI()
    end)

    -- warning message
    local warningMessage = NewLabel(configFrame, 1.8 * fontHeight, "Changes will only take effect after reloading the UI")
    warningMessage:SetPoint("BOTTOM", reloadButton, "TOP", 0, framePadding)
    warningMessage:SetTextColor(1, 0, 0, 1)

    configFrame:SetWidth(framePadding * 3 + realmDisplayFrame:GetWidth() + fieldDisplayOrderFrame:GetWidth() + accountFieldDisplayOrderFrame:GetWidth())
    configFrame:SetHeight(framePadding * 3 + titleBarHeight + warningHeight + reloadButton:GetHeight() + realmDisplayFrame:GetHeight())
    configFrame:SetShown(false)
end

function ArwicAltManager.ToggleConfig()
    ArwicAltManager.BuildConfig()
    ARWIC_AAM_configFrame:SetShown(not ARWIC_AAM_configFrame:IsVisible())
end

function ArwicAltManager.ShowConfig()
    ArwicAltManager.BuildConfig()
    ARWIC_AAM_configFrame:Show()
end

function ArwicAltManager.HideConfig()
    ARWIC_AAM_configFrame:Hide()
end

