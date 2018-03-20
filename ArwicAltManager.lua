local events = {}

local charName = UnitName("player")
local charRealm = GetRealmName()
local _, className = UnitClass("player")
local BreachingTheTombAchievementID = 11546
local LegendaryResearchAchievementID = 11223
local ImprovingOnHistoryAchievementID = 10459
local currenciesToQuery = { 
    1220, -- Order Resources
    1508, -- Veiled Argunite
    1273, -- Seal of Broken Fate
}
local classCampaignFinals = {
    ["DEATHKNIGHT"] = 43407,
    ["DEMONHUNTER"] = 43412,
    ["DRUID"] = 43409,
    ["HUNTER"] = 43423,
    ["MAGE"] = 43415,
    ["MONK"] = 43359,
    ["PALADIN"] = 43424,
    ["PRIEST"] = 43420,
    ["ROGUE"] = 43422,
    ["SHAMAN"] = 43418,
    ["WARLOCK"] = 43414,
    ["WARRIOR"] = 43425,
}
local classMountFinals = {
    ["DEATHKNIGHT"] = 46813,
    ["DEMONHUNTER"] = 46334,
    ["DRUID"] = 46319,
    ["HUNTER"] = 46337,
    ["MAGE"] = 45354,
    ["MONK"] = 46350,
    ["PALADIN"] = 45770,
    ["PRIEST"] = 45789,
    ["ROGUE"] = 46089,
    ["SHAMAN"] = 46792,
    ["WARLOCK"] = 46243,
    ["WARRIOR"] = 46207,
}
local classMountBonuses = {}
local ridingSpellIDs = { 
    [60] = 33388, 
    [100] = 33391, 
    [150] = 34090, 
    [280] = 34091, 
    [310] = 90265 
}
local ridingPathfinderIDs = {
    ["legion"] = 233368,
    ["warlords"] = 191645,
}
local inventorySlotIDs = {
    1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
}
local genderMap = {
    [1] = "Unknown",
    [2] = "Male",
    [3] = "Female",
}

function InitDB()
    if ArwicAltManagerDB == nil then 
        ArwicAltManagerDB = {} 
    end
    if ArwicAltManagerDB.Realms == nil then 
        ArwicAltManagerDB.Realms = {} 
    end
    if ArwicAltManagerDB.Realms[charRealm] == nil then 
        ArwicAltManagerDB.Realms[charRealm] = {} 
    end
    if ArwicAltManagerDB.Realms[charRealm][charName] == nil then 
        ArwicAltManagerDB.Realms[charRealm][charName] = {} 
    end
    if ArwicAltManagerDB.Realms[charRealm][charName].Currencies == nil then 
        ArwicAltManagerDB.Realms[charRealm][charName].Currencies = {} 
    end
end

function CharData(charName, charRealm)
    return ArwicAltManagerDB.Realms[charRealm][charName]
end

local function UpdateArtifactData()
    InitDB()
    local char = CharData(charName, charRealm)
    -- artifact
    if char.Artifacts == nil then 
        char.Artifacts = {} 
    end
    local artifactItemID, _, _, _, artifactPowerAvailable, artifactRanksPurchased, _, _, _, _, _, _ = C_ArtifactUI.GetArtifactInfo()
    char.Artifacts[artifactItemID] = {}
    char.Artifacts[artifactItemID].ArtifactPowerAvailable = artifactPowerAvailable
    char.Artifacts[artifactItemID].ArtifactRanksPurchased = artifactRanksPurchased
end

local function UpdateTimePlayed(total, thisLevel)
    InitDB()
    local char = CharData(charName, charRealm)
    -- time played
    char.PlayedTotal = total
    char.PlayedLevel = thisLevel 
end 

local function UpdateCharacterData()
    InitDB()
    local char = CharData(charName, charRealm)
    -- timestamp 
    char.LastUpdated = time() -- returns local time, should we use server time instead?
    -- request time played
    RequestTimePlayed()
    -- gold
    char.Money = GetMoney()
    -- currency
    for _, curID in pairs(currenciesToQuery) do
        if char.Currencies[curID] == nil then 
            char.Currencies[curID] = {} 
        end
        char.Currencies[curID].Name, 
        char.Currencies[curID].CurrentAmount, 
        _, 
        char.Currencies[curID].EarnedThisWeek, 
        char.Currencies[curID].WeeklyMax,
        char.Currencies[curID].TotalMax,
        char.Currencies[curID].IsDiscovered = GetCurrencyInfo(curID)
    end
    -- class campaign
    char.ClassCampaignDone = IsQuestFlaggedCompleted(classCampaignFinals[className])
    -- breaching the tomb
    _, _, _, _, _, _, _, _, _, _, _, _, char.BreachingTheTombDone, _ = GetAchievementInfo(BreachingTheTombAchievementID)
    -- class mount
    char.ClassMountDone = IsQuestFlaggedCompleted(classMountFinals[className])
    -- TODO: class mount bonuses
    -- level
    char.Level = UnitLevel("player")
    -- class
    char.Name = charName
    char.Class = className
    char.Realm = charRealm
    char.Faction = UnitFactionGroup("player")
    _, char.Race = UnitRace("player")
    char.Gender = UnitSex("player") -- 1 = unknown, 2 = male, 3 = female
    -- riding
    for ridingSpeed, ridingSpellID in pairs(ridingSpellIDs) do
        if IsSpellKnown(ridingSpellID) then
            char.MountSpeed = ridingSpeed
            break
        end
    end
    char.RidingPathfinderWarlords = IsSpellKnown(ridingPathfinderIDs["warlords"])
    char.RidingPathfinderLegion = IsSpellKnown(ridingPathfinderIDs["legion"])
    -- order hall upgrades
    _, _, _, _, _, _, _, _, _, _, _, _, char.OrderHallUpgradesDone, _ = GetAchievementInfo(LegendaryResearchAchievementID)
    -- balance of power
    _, _, _, _, _, _, _, _, _, _, _, _, char.BalanceOfPowerDone, _ = GetAchievementInfo(ImprovingOnHistoryAchievementID)
    -- gear
    char.Gear = {}
    for _, slotID in pairs(inventorySlotIDs) do 
        -- GetItemInfo(link) this value to get ilvl, etc. later
        char.Gear[slotID] = GetInventoryItemLink("player", slotID)
    end
    -- professions
    char.Professions = {}
    char.Professions.Prof1 = {}
    char.Professions.Prof2 = {}
    char.Professions.Archaeology = {}
    char.Professions.Fishing = {}
    char.Professions.Cooking = {}
    char.Professions.FirstAid = {}
    char.Professions.Prof1.Index, char.Professions.Prof2.Index, 
    char.Professions.Archaeology.Index, char.Professions.Fishing.Index,
    char.Professions.Cooking.Index, char.Professions.FirstAid.Index = GetProfessions()
    for k, v in pairs(char.Professions) do
        v.Name, _, v.SkillLevel, v.MaxSkillLevel, _, _, v.SkillLine, 
        v.SkillModifier, v.SpecializationIndex, _ = GetProfessionInfo(v.Index)
    end
    -- mage tower

    -- followers
    char.Followers = {}
    for _, f in pairs(C_Garrison.GetFollowers()) do
        char.Followers[f.name] = f
    end
end

function events:PLAYER_LOGIN(...)
    UpdateCharacterData()
end

function events:PLAYER_ENTERING_WORLD(...)
    UpdateCharacterData()
end

function events:PLAYER_LOGOUT(...)
    UpdateCharacterData()
end

function events:ARTIFACT_UPDATE(...)
    UpdateArtifactData()
end

function events:TIME_PLAYED_MSG(...)
    local total, thisLevel = ...
    UpdateTimePlayed(total, thisLevel)
end

function AAM_Init()
    -- register events
    local eventFrame = CreateFrame("FRAME", "AAM_eventFrame")
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...)
    end)
    for k, v in pairs(events) do
        eventFrame:RegisterEvent(k)
    end
end

AAM_Init()

-----------------------------------------------

local function ErrorColor()
    return 0.85, 0.33, 0.25
end

local function ClassColor(className)
    return RAID_CLASS_COLORS[className].r, RAID_CLASS_COLORS[className].g, RAID_CLASS_COLORS[className].b
end

local function FactionColor(factionName)
    if factionName == "Alliance" then
        return 0, 0.8, 1
    elseif factionName == "Horde" then
        return 0.85, 0, 0
    end
end

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

local function CharacterCol(char)
    local n = char.Name:gsub("%s+", "")
    local r = char.Realm:gsub("%s+", "")
    return _G["AAM_colFrame_" .. n .. "_" .. r]
end

local function FormatPlayed(time)
    local days = floor(time / 86400)
    local hours = floor((time % 86400) / 3600)
    local minutes = floor((time % 3600) / 60)
    local seconds = floor(time % 60)
    return format("%d:%02d:%02d:%02d", days, hours, minutes, seconds)
end

local function FormatBool(b)
    if b then return "Yes" 
    else return "No" end
end

function AAM_BuildGeneralFrame()
    -- dont remake the frame if it already exists
    if AAM_mainFrame ~= nil then return end

    -- crate the main frame
    AAM_mainFrame = CreateFrame("Frame", "AAM_mainFrame", UIParent)
    AAM_mainFrame:SetFrameStrata("HIGH")
    AAM_mainFrame:SetWidth(850)
    AAM_mainFrame:SetHeight(600)
    AAM_mainFrame:SetPoint("CENTER",0,0)
    AAM_mainFrame.texture = AAM_mainFrame:CreateTexture(nil, "BACKGROUND")
    AAM_mainFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    AAM_mainFrame.texture:SetAllPoints(AAM_mainFrame)
    AAM_mainFrame:EnableMouse(true)
    AAM_mainFrame:SetMovable(true)
    AAM_mainFrame:RegisterForDrag("LeftButton")
    AAM_mainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    AAM_mainFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local fontHeight = 15
    local colWidth = 130
    local rowHeight = 20
    local titleBarHeight = 20
    local colHeight = AAM_mainFrame:GetHeight() - titleBarHeight
    local textOffset = 2
    
    -- title bar
    local titleBar = CreateFrame("FRAME", "AAM_titleBarFrame", AAM_mainFrame)
    titleBar:SetWidth(AAM_mainFrame:GetWidth())
    titleBar:SetHeight(titleBarHeight)
    titleBar:SetPoint("TOPLEFT", 0, 0)
    titleBar.texture = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
    titleBar.texture:SetAllPoints(titleBar)
    
    local closeButton = CreateFrame("BUTTON", "AAM_closeButton", AAM_titleBarFrame)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton.Click = function()
        AAM_mainFrame:Hide()
    end

    -- row headers
    local rowHeaders = {
        "Name",
        "Realm",
        "Faction",
        "Played",
        "Race",
        "Gender",
        "Level",
        "Riding",
        "Resources",
        "Class Campaign",
        "Class Mount",
        "Concordance",
        "Mage Towers",
        "Profession 1",
        "Profession 2",
        "Archaeology",
        "Fishing",
        "Cooking",
        "First Aid",
    }
    local rowHeaderFrame = CreateFrame("FRAME", "AAM_rowHeaderFrame", AAM_mainFrame)
    rowHeaderFrame:SetWidth(colWidth)
    rowHeaderFrame:SetHeight(colHeight)
    rowHeaderFrame:SetPoint("TOPLEFT", 0, -titleBarHeight)
    local i = 0
    for _, headerName in pairs(rowHeaders) do
        local lbl = NewLabel(rowHeaderFrame, fontHeight, headerName)
        lbl:SetPoint("TOPLEFT", textOffset, -rowHeight * i - textOffset)
        -- create the row frame
        local rowFrame = CreateFrame("FRAME", "AAM_rowFrame_" .. headerName:gsub("%s+", ""), AAM_mainFrame)
        rowFrame:SetWidth(AAM_mainFrame:GetWidth())
        rowFrame:SetHeight(rowHeight)
        rowFrame:SetPoint("TOPLEFT", 0, -(rowHeight * i + titleBarHeight))
        -- give the row a texture if required
        if i % 2 == 0 then
            rowFrame.texture = rowFrame:CreateTexture(nil, "BACKGROUND")
            rowFrame.texture:SetColorTexture(0.15, 0.15, 0.15, 1.0)
            rowFrame.texture:SetAllPoints(rowFrame)
        end
        i = i + 1
    end

    -- create character cols
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local n = char.Name:gsub("%s+", "")
        local r = char.Realm:gsub("%s+", "")
        local col = CreateFrame("FRAME", "AAM_colFrame_" .. n .. "_" .. r, AAM_mainFrame)
        col:SetWidth(colWidth)
        col:SetHeight(AAM_mainFrame:GetHeight() - titleBarHeight)
        col:SetPoint("TOPLEFT", rowHeaderFrame:GetWidth() + colWidth * i, -titleBarHeight)
        i = i + 1
    end

    -- populate character columns
    local rowCounter = 0
    -- name
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Name == nil then break end
        if char.Class == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Name)
        str:SetTextColor(ClassColor(char.Class))
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- realm
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Realm == nil then break end
        if char.Class == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Realm)
        str:SetTextColor(ClassColor(char.Class))
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- faction
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Faction == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Faction)
        str:SetTextColor(FactionColor(char.Faction))
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- played
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.PlayedTotal == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, FormatPlayed(char.PlayedTotal))
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- race
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Race == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Race)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- gender
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Gender == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, genderMap[char.Gender])
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- level
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Level == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Level)
        if char.Level ~= 110 then
            str:SetTextColor(ErrorColor())
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- riding
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.MountSpeed == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.MountSpeed .. "%")
        if char.MountSpeed ~= 310 then
            str:SetTextColor(ErrorColor())
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- order resources
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Currencies == nil then break end
        if char.Currencies[1220] == nil then break end
        if char.Currencies[1220].CurrentAmount == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, char.Currencies[1220].CurrentAmount)
        if char.Currencies[1220].CurrentAmount < 4000 then
            str:SetTextColor(0.85, 0.33, 0.25)
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- class campaign
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.ClassCampaignDone == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, FormatBool(char.ClassCampaignDone))
        if not char.ClassCampaignDone then
            str:SetTextColor(ErrorColor())
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- class mount
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.ClassMountDone == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, FormatBool(char.ClassMountDone))
        if not char.ClassMountDone then
            str:SetTextColor(ErrorColor())
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- concordance count
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Class == nil then break end
        if char.Artifacts == nil then break end
        local concCount = 0
        for k, v in pairs(char.Artifacts) do
            if v.ArtifactRanksPurchased == nil then break end
            if v.ArtifactRanksPurchased >= 52 then
                concCount = concCount + 1
            end
        end
        local maxConcCount = 3
        if char.Class == "DEMONHUNTER" then maxConcCount = 2
        elseif char.Class == "DRUID" then maxConcCount = 4 end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, concCount .. "/" .. maxConcCount)
        if concCount ~= maxConcCount then
            str:SetTextColor(ErrorColor())
        end
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- mage towers
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        local charCol = CharacterCol(char)
        local str = NewLabel(charCol, fontHeight, "NYI")
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- profession 1
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.Prof1 == nil then break end
        if char.Professions.Prof1.SkillLevel == nil then break end
        if char.Professions.Prof1.MaxSkillLevel == nil then break end
        if char.Professions.Prof1.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.Prof1.SkillLevel .. "/" .. char.Professions.Prof1.MaxSkillLevel .. " (" .. char.Professions.Prof1.Name .. ")"
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- profession 2
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.Prof2 == nil then break end
        if char.Professions.Prof2.SkillLevel == nil then break end
        if char.Professions.Prof2.MaxSkillLevel == nil then break end
        if char.Professions.Prof2.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.Prof2.SkillLevel .. "/" .. char.Professions.Prof2.MaxSkillLevel .. " (" .. char.Professions.Prof2.Name .. ")"
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- archeology
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.Archaeology == nil then break end
        if char.Professions.Archaeology.SkillLevel == nil then break end
        if char.Professions.Archaeology.MaxSkillLevel == nil then break end
        if char.Professions.Archaeology.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.Archaeology.SkillLevel .. "/" .. char.Professions.Archaeology.MaxSkillLevel
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- fishing
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.Fishing == nil then break end
        if char.Professions.Fishing.SkillLevel == nil then break end
        if char.Professions.Fishing.MaxSkillLevel == nil then break end
        if char.Professions.Fishing.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.Fishing.SkillLevel .. "/" .. char.Professions.Fishing.MaxSkillLevel
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- cooking
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.Cooking == nil then break end
        if char.Professions.Cooking.SkillLevel == nil then break end
        if char.Professions.Cooking.MaxSkillLevel == nil then break end
        if char.Professions.Cooking.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.Cooking.SkillLevel .. "/" .. char.Professions.Cooking.MaxSkillLevel
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    -- first aid
    local i = 0
    for _, char in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        local char = CharData(char.Name, char.Realm)
        if char == nil then break end
        if char.Professions == nil then break end
        if char.Professions.FirstAid == nil then break end
        if char.Professions.FirstAid.SkillLevel == nil then break end
        if char.Professions.FirstAid.MaxSkillLevel == nil then break end
        if char.Professions.FirstAid.Name == nil then break end
        local charCol = CharacterCol(char)
        local s = char.Professions.FirstAid.SkillLevel .. "/" .. char.Professions.FirstAid.MaxSkillLevel
        local str = NewLabel(charCol, fontHeight, s)
        str:SetPoint("TOPLEFT", textOffset, -(rowCounter * rowHeight + textOffset))
        i = i + 1
    end
    rowCounter = rowCounter + 1
    
end