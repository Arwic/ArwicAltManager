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

local function UpdateCharacterData()
    InitDB()
    local char = CharData(charName, charRealm)
    -- timestamp 
    char.LastUpdated = time() -- returns local time, should we use server time instead?
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

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

function AAM_BuildGeneralFrame()
    -- dont remake the frame if it already exists
    if AAM_mainFrame ~= nil then return end

    AAM_mainFrame = CreateFrame("Frame", "AAM_mainFrame", UIParent)
    AAM_mainFrame:SetFrameStrata("HIGH")
    AAM_mainFrame:SetWidth(850)
    AAM_mainFrame:SetHeight(600)
    AAM_mainFrame:SetPoint("CENTER",0,0)

    AAM_mainFrame.texture = AAM_mainFrame:CreateTexture(nil, "BACKGROUND")
    AAM_mainFrame.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9)
    AAM_mainFrame.texture:SetAllPoints(AAM_mainFrame)

    local charCount = 0
    local rowWidth = AAM_mainFrame:GetWidth()
    local rowHeight = 20
    local headerheight = 20
    
    -- create the header
    local headerCols = {
        "Name",
        "Class",
        "Realm",
        "Faction",
        "Race",
        "Gender",
        "Level",
        "Riding Speed",
    }
    local headerRowFrame = CreateFrame("FRAME", "AAM_headerRowFrame", AAM_mainFrame)
    headerRowFrame:SetWidth(rowWidth)
    headerRowFrame:SetHeight(rowHeight)
    headerRowFrame:SetPoint("TOPLEFT", 0, 0)
    headerRowFrame.texture = headerRowFrame:CreateTexture(nil, "BACKGROUND")
    headerRowFrame.texture:SetColorTexture(0.15, 0.15, 0.3, 1.0)
    headerRowFrame.texture:SetAllPoints(headerRowFrame)
    local widthSoFar = 0
    local headerSep = 5
    local colWidth = 90
    local headerFontHeight = 20
    for _, colName in pairs(headerCols) do
        local str = headerRowFrame:CreateFontString()
        str:SetParent(headerRowFrame)
        str:SetFont("fonts/ARIALN.ttf", headerFontHeight)
        str:SetText(colName)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
    end

    for k, v in pairs(ArwicAltManagerDB.Realms[charRealm]) do
        -- create the row frame
        local charRowFrame = CreateFrame("FRAME", "AAM_charRowFrame_" .. v.Realm .. "_" .. v.Name, AAM_mainFrame)
        charRowFrame:SetWidth(rowWidth)
        charRowFrame:SetHeight(rowHeight)
        charRowFrame:SetPoint("TOPLEFT", 0, -(rowHeight * charCount + headerheight))
        -- give the row a texture
        if charCount % 2 == 0 then
            charRowFrame.texture = charRowFrame:CreateTexture(nil, "BACKGROUND")
            charRowFrame.texture:SetColorTexture(0.15, 0.15, 0.15, 1.0)
            charRowFrame.texture:SetAllPoints(charRowFrame)
        end
        
        local char = CharData(v.Name, v.Realm)
        local classColorR, classColorG, classColorB = 
            RAID_CLASS_COLORS[char.Class].r, 
            RAID_CLASS_COLORS[char.Class].g, 
            RAID_CLASS_COLORS[char.Class].b
        local dataFontHeight = 15
        local widthSoFar = 0

        -- name
        local str = NewLabel(charRowFrame, dataFontHeight, char.Name)
        str:SetTextColor(classColorR, classColorG, classColorB)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- class 
        local className = char.Class:sub(1,1):upper() .. char.Class:sub(2):lower()
        if className == "Demonhunter" then className = "Demon Hunter" end
        if className == "Deathknight" then className = "Death Knight" end
        local str = NewLabel(charRowFrame, dataFontHeight, className)
        str:SetTextColor(classColorR, classColorG, classColorB)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- realm
        local str = NewLabel(charRowFrame, dataFontHeight, char.Realm)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- faction
        local str = NewLabel(charRowFrame, dataFontHeight, char.Faction)
        if char.Faction == "Alliance" then
            str:SetTextColor(0, 0.8, 1)
        elseif char.Faction == "Horde" then
            str:SetTextColor(0.85, 0, 0)
        end
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- race
        local str = NewLabel(charRowFrame, dataFontHeight, char.Race)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- gender 
        local str = NewLabel(charRowFrame, dataFontHeight, genderMap[char.Gender])
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- level
        local str = NewLabel(charRowFrame, dataFontHeight, char.Level)
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep
        -- mount Speed
        local str = NewLabel(charRowFrame, dataFontHeight, char.MountSpeed .. "%")
        str:SetPoint("LEFT", widthSoFar + headerSep, 0)
        widthSoFar = widthSoFar + colWidth + headerSep

        -- increment the counter
        charCount = charCount + 1
    end
end