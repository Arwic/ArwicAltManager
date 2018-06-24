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

local function ShowCodeFrame(codeText, titleBarText, onSave)
    -- create code frame
    if AAM_config_codeFrame == nil then
        local codeFrame = CreateFrame("FRAME", "AAM_config_codeFrame", UIParent)
        table.insert(UISpecialFrames, codeFrame:GetName()) -- make frame close with escape
        codeFrame:SetFrameStrata("DIALOG")
        codeFrame:SetPoint("CENTER", 0, 0)
        codeFrame.texture = codeFrame:CreateTexture(nil, "BACKGROUND")
        codeFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.95)
        codeFrame.texture:SetAllPoints(codeFrame)
        codeFrame:EnableMouse(true)
        codeFrame:SetMovable(true)
        codeFrame:RegisterForDrag("LeftButton")
        codeFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        codeFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        codeFrame:SetSize(1000, 800)
        -- title bar
        local codeFrameTitleBar = CreateFrame("FRAME", "AAM_config_codeFrameTitleBarFrame", codeFrame)
        codeFrameTitleBar:SetPoint("TOP", codeFrame)
        codeFrameTitleBar:SetPoint("LEFT", codeFrame)
        codeFrameTitleBar:SetPoint("RIGHT", codeFrame)
        codeFrameTitleBar:SetHeight(titleBarHeight)
        codeFrameTitleBar.texture = codeFrameTitleBar:CreateTexture(nil, "BACKGROUND")
        codeFrameTitleBar.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
        codeFrameTitleBar.texture:SetAllPoints(codeFrameTitleBar)
        local titleBarLabel = NewLabel(codeFrameTitleBar, 20, "Field Code"):SetAllPoints(codeFrameTitleBar)
        -- close button
        local codeFrameCloseButton = CreateFrame("BUTTON", "AAM_config_codeFrameCloseButton", codeFrameTitleBar, "UIPanelCloseButton")
        codeFrameCloseButton:SetPoint("TOPRIGHT", 0, 0)
        codeFrameCloseButton:SetWidth(titleBarHeight)
        codeFrameCloseButton:SetHeight(titleBarHeight)
        codeFrameCloseButton:SetScript("OnClick", function()
            codeFrame:Hide()
        end)
        -- save button
        local btnSave = CreateFrame("BUTTON", "AAM_config_codeFrameSaveButton", codeFrame, "UIGoldBorderButtonTemplate")
        btnSave:SetSize(100, 30)
        btnSave:SetText("Save")
        btnSave:SetPoint("BOTTOM", codeFrame, "BOTTOM")
        -- edit box
        local codeEditBoxScrollFrame = CreateFrame("EditBox", "AAM_config_codeFrameEditBoxScrollFrame", codeFrame)
        codeEditBoxScrollFrame:SetPoint("TOP", codeFrameTitleBar, "BOTTOM")
        codeEditBoxScrollFrame:SetPoint("BOTTOM", btnSave, "TOP")
        codeEditBoxScrollFrame:SetPoint("LEFT", codeFrame, "LEFT")
        codeEditBoxScrollFrame:SetPoint("RIGHT", codeFrame, "RIGHT")
        codeEditBoxScrollFrame:SetFont("Interface/AddOns/ArwicAltManager/fonts/FiraMono-Regular.ttf", fontHeight)
        codeEditBoxScrollFrame:SetMultiLine(true)
    end
    print("showing code text: " .. codeText)
    AAM_config_codeFrameEditBoxScrollFrame:SetText(codeText)
    AAM_config_codeFrameSaveButton:SetScript("OnClick", function()
        print("saving code: " .. AAM_config_codeFrameEditBoxScrollFrame:GetText())
        onSave(AAM_config_codeFrameEditBoxScrollFrame:GetText())
    end)
    AAM_config_codeFrame:Show()

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

        frame.list[i].EditUpdate = CreateFrame("BUTTON", frame:GetName() .. "_list_editUpdate_" .. i, frame, "UIGoldBorderButtonTemplate")
        frame.list[i].EditUpdate:SetSize(25, 25)
        frame.list[i].EditUpdate:SetText("U")
        frame.list[i].EditUpdate:SetPoint("TOP", frame.list[i].Order, "TOP")
        frame.list[i].EditUpdate:SetPoint("RIGHT", frame, "RIGHT", -25, 0)

        frame.list[i].EditTooltip = CreateFrame("BUTTON", frame:GetName() .. "_list_editTooltip_" .. i, frame, "UIGoldBorderButtonTemplate")
        frame.list[i].EditTooltip:SetSize(25, 25)
        frame.list[i].EditTooltip:SetText("T")
        frame.list[i].EditTooltip:SetPoint("TOP", frame.list[i].Order, "TOP")
        frame.list[i].EditTooltip:SetPoint("RIGHT", frame.list[i].EditUpdate, "LEFT")
        
        frame.list[i].EditValue = CreateFrame("BUTTON", frame:GetName() .. "_list_editValue_" .. i, frame, "UIGoldBorderButtonTemplate")
        frame.list[i].EditValue:SetSize(25, 25)
        frame.list[i].EditValue:SetText("V")
        frame.list[i].EditValue:SetPoint("TOP", frame.list[i].Order, "TOP")
        frame.list[i].EditValue:SetPoint("RIGHT", frame.list[i].EditTooltip, "LEFT")
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
        for fk, fv in spairs(ArwicAltManagerDB.Fields.Character, function(t, a, b)
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
                    ArwicAltManagerDB.Fields.Character[name].Order = ebOrder:GetNumber()
                end)
                ebOrder:Show()

                local cbDisplay = frame.list[i].Display
                cbDisplay:SetChecked(checked)
                cbDisplay:SetPoint("LEFT", eb, "RIGHT")
                cbDisplay:SetSize(ITEM_HEIGHT, ITEM_HEIGHT)
                _G[cbDisplay:GetName() .. "Text"]:SetText(name)
                cbDisplay:SetScript("OnClick", function(sender)
                    ArwicAltManagerDB.Fields.Character[name].Display = cbDisplay:GetChecked()
                end)
                cbDisplay:Show()

                local btnEditUpdate = frame.list[i].EditUpdate
                btnEditUpdate:SetScript("OnClick", function(...)
                    if ArwicAltManagerDB.Fields.Character[name].FuncStr.Update ~= nil then
                        ShowCodeFrame(ArwicAltManagerDB.Fields.Character[name].FuncStr.Update, format("AAM: %s Update Function", name), function(newCode)
                            ArwicAltManagerDB.Fields.Character[name].FuncStr.Update = newCode
                        end)
                    end
                end)
                btnEditUpdate:Show()

                local btnEditTooltip= frame.list[i].EditTooltip
                btnEditTooltip:SetScript("OnClick", function(...)
                    if ArwicAltManagerDB.Fields.Character[name].FuncStr.Tooltip ~= nil then
                        ShowCodeFrame(ArwicAltManagerDB.Fields.Character[name].FuncStr.Tooltip, format("AAM: %s Tooltip Function", name), function(newCode)
                            ArwicAltManagerDB.Fields.Character[name].FuncStr.Tooltip = newCode
                        end)
                    end
                end)
                btnEditTooltip:Show()

                local btnEditValue = frame.list[i].EditValue
                btnEditValue:SetScript("OnClick", function(...)
                    if ArwicAltManagerDB.Fields.Character[name].FuncStr.Value ~= nil then
                        ShowCodeFrame(ArwicAltManagerDB.Fields.Character[name].FuncStr.Value, format("AAM: %s Value Function", name), function(newCode)
                            ArwicAltManagerDB.Fields.Character[name].FuncStr.Value = newCode
                        end)
                    end
                end)
                btnEditValue:Show()
            else
                frame.list[i].Display:Hide()
                frame.list[i].Order:Hide()
                frame.list[i].EditUpdate:Hide()
                frame.list[i].EditTooltip:Hide()
                frame.list[i].EditValue:Hide()
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

local function BuildMiscSettings()
    -- create the main frame
    local frame = CreateFrame("FRAME", "AAM_config_miscFrame", ARWIC_AAM_configFrame)
    -- create label above the frame
    local frameLabel = NewLabel(frame, fontHeight * 1.25, "Other Settings"):SetPoint("BOTTOMLEFT", frame, "TOPLEFT", LABEL_OFFSET_X, LABEL_OFFSET_Y)
    -- set up main frame
    frame:SetPoint("TOPLEFT", AAM_config_realmDisplayFrame, "BOTTOMLEFT", 0, -framePadding * 2)
    frame:SetPoint("TOPRIGHT", AAM_config_accountFieldFrame, "BOTTOMRIGHT", 0, -framePadding * 2)
    frame:SetHeight(100)
    frame.texture = frame:CreateTexture(nil, "BACKGROUND")
    frame.texture:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    frame.texture:SetAllPoints(frame)
    frame:SetPoint("CENTER")

    -- mini map icon toggle
    local cb = CreateFrame("CHECKBUTTON", "AAM_config_mapButtonToggle", frame, "ChatConfigCheckButtonTemplate")
    cb:SetSize(24, 24)
    cb:SetPoint("TOPLEFT", frame, "TOPLEFT")
    _G[cb:GetName() .. "Text"]:SetText("Show Minimap Button")
    cb:SetChecked(not ArwicAltManagerDB.Config.MinimapIcon.hide)
    cb:SetScript("OnClick", function(sender)
        ArwicAltManagerDB.Config.MinimapIcon.hide = not cb:GetChecked()
        if ArwicAltManagerDB.Config.MinimapIcon.hide then
            LibStub:GetLibrary("LibDBIcon-1.0"):Hide("ArwicAltManager")
        else
            LibStub:GetLibrary("LibDBIcon-1.0"):Show("ArwicAltManager")
        end
    end)
    local lastSettingFrame = cb

    -- enable peeking
    local cb = CreateFrame("CHECKBUTTON", "AAM_config_peekingToggle", frame, "ChatConfigCheckButtonTemplate")
    cb:SetSize(24, 24)
    cb:SetPoint("TOPLEFT", lastSettingFrame, "BOTTOMLEFT")
    _G[cb:GetName() .. "Text"]:SetText("Show character grid when mousing over icon")
    cb:SetChecked(ArwicAltManagerDB.Config.MinimapIcon.EnablePeeking)
    cb:SetScript("OnClick", function(sender)
        ArwicAltManagerDB.Config.MinimapIcon.EnablePeeking = cb:GetChecked()
    end)
    lastSettingFrame = cb

    -- require shift to peek
    local cb = CreateFrame("CHECKBUTTON", "AAM_config_shiftPeekingToggle", frame, "ChatConfigCheckButtonTemplate")
    cb:SetSize(24, 24)
    cb:SetPoint("TOPLEFT", lastSettingFrame, "BOTTOMLEFT")
    _G[cb:GetName() .. "Text"]:SetText("Require shift be held to see character grid when mosuing over icon")
    cb:SetChecked(ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift)
    cb:SetScript("OnClick", function(sender)
        ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift = cb:GetChecked()
    end)
    lastSettingFrame = cb

    return frame
end

function ArwicAltManager.BuildConfig()
    -- dont remake the frame if it already exists
    if ARWIC_AAM_configFrame ~= nil then return end
    local warningHeight = 50

    -- main frame
    local configFrame = CreateFrame("Frame", "ARWIC_AAM_configFrame", UIParent)
    table.insert(UISpecialFrames, configFrame:GetName()) -- make frame close with escape
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

    -- account button
    local accountButton = CreateFrame("BUTTON", "AAM_configAccountButton", titleBar, "OptionsBoxTemplate")
    accountButton:SetPoint("TOPRIGHT", closeButton, "TOPLEFT")
    accountButton:SetWidth(titleBarHeight)
    accountButton:SetHeight(titleBarHeight)
    accountButton:SetScript("OnClick", function()
        configFrame:Hide()
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

    -- character button
    local characterButton = CreateFrame("BUTTON", "AAM_configCharacterButton", titleBar, "OptionsBoxTemplate")
    characterButton:SetPoint("TOPRIGHT", accountButton, "TOPLEFT")
    characterButton:SetWidth(titleBarHeight)
    characterButton:SetHeight(titleBarHeight)
    characterButton:SetScript("OnClick", function()
        configFrame:Hide()
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

    -- realm display
    local realmDisplayFrame = BuildRealmDisplay()
    -- field display order
    local fieldDisplayOrderFrame = BuildCharacterFieldDisplayOrder()
    -- account field display order
    local accountFieldDisplayOrderFrame = BuildAccountFieldDisplayOrder()
    -- misc settings
    local miscFrame = BuildMiscSettings()
    
    -- reload button and warning message
    local reloadButton = CreateFrame("BUTTON", "AAM_config_reloadButton", configFrame, "UIGoldBorderButtonTemplate")
    reloadButton:SetPoint("BOTTOM", configFrame, "BOTTOM", 0, framePadding)
    reloadButton:SetWidth(150)
    reloadButton:SetHeight(30)
    reloadButton:SetText("Reload")
    reloadButton:SetScript("OnClick", function()
        ReloadUI()
    end)
    local warningMessage = NewLabel(configFrame, 1.8 * fontHeight, "Changes will only take effect after reloading the UI")
    warningMessage:SetPoint("BOTTOM", reloadButton, "TOP", 0, framePadding)
    warningMessage:SetTextColor(1, 0, 0, 1)

    -- size the main frame
    configFrame:SetWidth(framePadding * 4 + realmDisplayFrame:GetWidth() + fieldDisplayOrderFrame:GetWidth() + accountFieldDisplayOrderFrame:GetWidth())
    configFrame:SetHeight(framePadding * 4 + titleBarHeight + warningHeight + reloadButton:GetHeight() + realmDisplayFrame:GetHeight() + miscFrame:GetHeight())
    configFrame:SetShown(false)
end

function ArwicAltManager.ShowConfig()
    ArwicAltManager.HideCharacterGrid()
    ArwicAltManager.HideAccountGrid()
    ArwicAltManager.BuildConfig()
    ARWIC_AAM_configFrame:Show()
end

function ArwicAltManager.HideConfig()
    if ARWIC_AAM_configFrame ~= nil then
        ARWIC_AAM_configFrame:Hide()
    end
end

function ArwicAltManager.ToggleConfig()
    ArwicAltManager.BuildConfig()
    if ARWIC_AAM_configFrame:IsShown() then
        ArwicAltManager.HideConfig()
    else
        ArwicAltManager.ShowConfig()
    end
end
