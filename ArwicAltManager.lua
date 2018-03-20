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
