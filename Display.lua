local dataLabels = {}

function table.len(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

local function Config()
    return ArwicAltManagerDB.Config
end

local function ClassColor(className)
    return RAID_CLASS_COLORS[className].r, 
        RAID_CLASS_COLORS[className].g, 
        RAID_CLASS_COLORS[className].b
end

local function FactionColor(factionName)
    if factionName == "Alliance" then
        return 0, 0.8, 1
    elseif factionName == "Horde" then
        return 0.85, 0, 0
    end
end

local function ErrorColor()
    return 0.85, 0.33, 0.25
end

local function DefaultColor()
    return 1.0, 1.0, 1.0
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

local function CharData(name, realm)
    return ArwicAltManagerDB.Realms[realm][name]
end

local function AllRealmChars(realm)
    return ArwicAltManagerDB.Realms[realm]
end

local fieldFormatters = {
    ["Name"] = {
        Label = "Name",
        Order = 10,
        Display = true,
        Value = function(char)
            return char["Name"]
        end,
        Color = function(char)
            return ClassColor(char["Class"])
        end,
    },
    ["Class"] = {
        Label = "Class",
        Order = 20,
        Display = false,
        Value = function(char)
            if char["Class"] == "DEMONHUNTER" then
                return "Demon Hunter"
            elseif char["Class"] == "DEATHKNIGHT" then
                return "Death Knight"
            else
                return char["Class"]:sub(1,1):upper() .. char["Class"]:sub(2):lower()
            end
        end,
        Color = function(char)
            return ClassColor(char["Class"])
        end,
    },
    ["Realm"] = {
        Label = "Realm",
        Order = 40,
        Display = false,
        Value = function(char)
            return char["Realm"]
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Faction"] = {
        Label = "Faction",
        Order = 30,
        Display = false,
        Value = function(char)
            return char["Faction"]
        end,
        Color = function(char)
            return FactionColor(char["Faction"])
        end,
    },
    ["Race"] = {
        Label = "Race",
        Order = 60,
        Display = false,
        Value = function(char)
            return char["Race"]
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Gender"] = {
        Label = "Gender",
        Order = 70,
        Display = false,
        Value = function(char)
            local map = {
                [1] = "Unknown",
                [2] = "Male",
                [3] = "Female",
            }
            return map[char["Gender"]]
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Timestamp"] = {
        Label = "Updated",
        Order = 1000,
        Display = true,
        Value = function(char)
            if not char["Timestamp"] then
                return "?"
            end
            local dt = time() - char["Timestamp"]
            local days, hours, minutes, seconds = FormatTime(dt)
            if days > 0 then
                return format("%d days a go", days)
            elseif hours > 0 then
                return format("%d hrs a go", hours)
            elseif minutes > 0 then
                return format("%d mins a go", minutes)
            else
                return format("%d secs a go", seconds)
            end
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Money"] = {
        Label = "Gold",
        Order = 80,
        Display = true,
        Value = function(char)
            local g = floor(char["Money"] / 100 / 100)
            --local s = (char["Money"] / 100) % 100
            --local c = char["Money"] % 100
            --local str = format("%sg %ds %dc", FormatInt(g), s, c)
            local str = format("%sg", FormatInt(g))
            return str
        end,
        Color = function(char)
            if (char["Money"] / 100 / 100) < Config().GoldThreshold then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["ClassCampaign"] = {
        Label = "Class Campaign",
        Order = 110,
        Display = true,
        Value = function(char)
            return FormatBool(char["ClassCampaign"])
        end,
        Color = function(char)
            if not char["ClassCampaign"] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["ClassMount"] = {
        Label = "Class Mount",
        Order = 120,
        Display = true,
        Value = function(char)
            return FormatBool(char["ClassMount"])
        end,
        Color = function(char)
            if not char["ClassMount"] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["Level"] = {
        Label = "Level",
        Order = 50,
        Display = true,
        Value = function(char)
            return char["Level"]
        end,
        Color = function(char)
            if char["Level"] < Config().LevelThreshold then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["MountSpeed"] = {
        Label = "Riding",
        Order = 160,
        Display = true,
        Value = function(char)
            return format("%s%%", char["MountSpeed"])
        end,
        Color = function(char)
            if char["MountSpeed"] < Config().MountSpeedThreshold then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["OrderHallUpgrades"] = {
        Label = "All Order Hall Upgrades",
        Order = 130,
        Display = true,
        Value = function(char)
            return FormatBool(char["OrderHallUpgrades"])
        end,
        Color = function(char)
            if not char["OrderHallUpgrades"] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["BalanceOfPower"] = {
        Label = "Balance of Power",
        Order = 150,
        Display = true,
        Value = function(char)
            return FormatBool(char["BalanceOfPower"])
        end,
        Color = function(char)
            if not char["BalanceOfPower"] then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["MageTower"] = {
        Label = "Mage Tower",
        Order = 140,
        Display = true,
        Value = function(char)
            local count = 0
            for k, v in pairs(char["MageTower"]) do
                if v then
                    count = count + 1
                end
            end
            local maxCount = 3
            if char["Class"] == "DEMONHUNTER" then maxCount = 2 end
            if char["Class"] == "DRUID" then maxCount = 4 end
            local str = format("%d/%d", count, maxCount)
            return str
        end,
        Color = function(char)
            local count = 0
            for k, v in pairs(char["MageTower"]) do
                if v then
                    count = count + 1
                end
            end
            local maxCount = 3
            if char["Class"] == "DEMONHUNTER" then maxCount = 2 end
            if char["Class"] == "DRUID" then maxCount = 4 end
            if count ~= maxCount then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["TimePlayed"] = {
        Label = "Time Played",
        Order = 170,
        Display = true,
        Value = function(char)
            local days, hours, mintues, seconds = FormatTime(char["TimePlayed"]["Total"])
            return format("%d:%02d:%02d:%02d", days, hours, minutes, seconds)
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Artifacts"] = {
        Label = "Artifact Levels",
        Order = 100,
        Display = true,
        Value = function(char)
            local str = ""
            for k, v in pairs(char["Artifacts"]) do
                if k ~= 133755 then -- ignore fishing artifact
                    str = format("%s, %d", str, v["Ranks"]) 
                end
            end
            return str:sub(3) -- remove the first 2 characters ", "
        end,
        Color = function(char)
            for k, v in pairs(char["Artifacts"]) do
                -- ignore fishing artifact
                if v["Ranks"] < Config().ArtifactRankThreshold and k ~= 133755 then
                    return ErrorColor()
                end
            end
            return DefaultColor()
        end,
    },
    ["OrderHallResouces"] = {
        Label = "Order Hall Resouces",
        Order = 90,
        Display = true,
        Value = function(char)
            if not char["Currencies"] then
                return "?"
            end
            return char["Currencies"][1220]["CurrentAmount"]
        end,
        Color = function(char)
            if not char["Currencies"] then
                return "?"
            end
            local cur = char["Currencies"][1220]["CurrentAmount"]
            if cur < Config().OrderHallResourcesThreshold then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    }
}

function spairs(t, order) -- https://stackoverflow.com/a/15706820/3105105
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

local function BuildGrid()
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
    local closeButton = CreateFrame("BUTTON", "AAM_closeButton", AAM_titleBarFrame)
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton.texture = closeButton:CreateTexture(nil, "BACKGROUND")
    closeButton.texture:SetColorTexture(0.7, 0.0, 0.0, 1.0)
    closeButton.texture:SetAllPoints(closeButton)
    closeButton:SetScript("OnClick", function()
        mainFrame:Hide()
    end)

    -- row headers
    local headerCol = CreateFrame("FRAME", "AAM_headerCol", mainFrame)
    headerCol:SetPoint("TOP", titleBar, "BOTTOM")
    headerCol:SetPoint("LEFT", mainFrame, "LEFT")
    local maxLabelWidth = 0
    local lastCellFrame = titleBar
    local i = 0
    for formatterKey, formatter in spairs(fieldFormatters, function(t, a, b)
        return t[a].Order < t[b].Order
    end) do
        if formatter.Display then
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
    local lastCharCol = headerCol
    local widthSoFar = 0
    for charKey, char in spairs(AllRealmChars(GetRealmName()), function(t, a, b)
        return t[a].Name < t[b].Name
    end) do
        -- make the character coloumn
        local charCol = CreateFrame("FRAME", "AAM_charCol_" .. charKey, mainFrame)
        charCol:SetPoint("LEFT", lastCharCol, "RIGHT")
        charCol:SetPoint("BOTTOM", mainFrame, "BOTTOM")
        charCol:SetPoint("TOP", titleBar, "BOTTOM")
        -- make the cells for each field in the character column
        local maxLabelWidth = 0
        local lastCellFrame = titleBar
        for formatterKey, formatter in spairs(fieldFormatters, function(t, a, b)
            return t[a].Order < t[b].Order
        end) do
            if formatter.Display then
                -- make the cell
                local cellFrame = CreateFrame("FRAME", "AAM_charCell_" .. charKey .. "_" .. formatterKey, charCol)
                cellFrame:SetHeight(rowHeight)
                cellFrame:SetPoint("LEFT", charCol, "LEFT")
                cellFrame:SetPoint("RIGHT", charCol, "RIGHT")
                cellFrame:SetPoint("TOP", lastCellFrame, "BOTTOM")
                -- make the label and put it in the cell
                local lbl = NewLabel(cellFrame, fontHeight, formatter.Value(char))
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
                lbl:SetTextColor(formatter.Color(char))
                -- keep track of the last itteration
                lastCellFrame = cellFrame
            end
        end
        -- set the column width to the widest labels width
        charCol:SetWidth(maxLabelWidth + textOffset * 2)
        lastCharCol = charCol
        widthSoFar = widthSoFar + charCol:GetWidth()
    end
    mainFrame:SetWidth(headerCol:GetWidth() + widthSoFar)
end

local function UpdateGrid()
    if ARWIC_AAM_mainFrame then
        for _, v in pairs(dataLabels) do
            v.lbl:SetText(v.formatter.Value(v.char))
            v.lbl:SetTextColor(v.formatter.Color(v.char))
        end
    else
        BuildGrid()
    end
end

function ARWIC_AAM_Toggle()
    UpdateGrid()
    ARWIC_AAM_mainFrame:SetShown(not ARWIC_AAM_mainFrame:IsVisible())
end

function ARWIC_AAM_Show()
    UpdateGrid()
    ARWIC_AAM_mainFrame:Show()
end

function ARWIC_AAM_Hide()
    ARWIC_AAM_mainFrame:Hide()
end

SLASH_AAM1 = "/aam"
SLASH_AAM2 = "/arwicaltmanager"
SlashCmdList["AAM"] = function(msg)
    if msg == "update" then
        ARWIC_AAM_UpdateData()
        print("AAM: Updated data for " .. UnitName("player") .. "-" .. GetRealmName())
        if ARWIC_AAM_mainFrame then
            ARWIC_AAM_Show()
        end
    else
        if ARWIC_AAM_mainFrame then
            ARWIC_AAM_Toggle()
        else
            BuildGrid()
        end
    end
end
