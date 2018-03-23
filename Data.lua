local events = {}

local function InitDB()
    if not ArwicAltManagerDB then 
        ArwicAltManagerDB = {} 
    end
    if not ArwicAltManagerDB.Realms then 
        ArwicAltManagerDB.Realms = {} 
    end
    if not ArwicAltManagerDB.Realms[GetRealmName()] then 
        ArwicAltManagerDB.Realms[GetRealmName()] = {} 
    end
    if not ArwicAltManagerDB.Realms[GetRealmName()][UnitName("player")] then 
        ArwicAltManagerDB.Realms[GetRealmName()][UnitName("player")] = {} 
    end
end

local function CurrentChar()
    InitDB()
    return ArwicAltManagerDB.Realms[GetRealmName()][UnitName("player")]
end

local fields = {
    ["Name"] = {
        Update = function()
            CurrentChar()["Name"] = UnitName("player")
        end
    },
    ["Class"] = {
        Update = function()
            _, CurrentChar()["Class"] = UnitClass("player")
        end
    },
    ["Realm"] = {
        Update = function()
            CurrentChar()["Realm"] = GetRealmName()
        end
    },
    ["Faction"] = {
        Update = function()
            CurrentChar()["Faction"] = UnitFactionGroup("player")
        end
    },
    ["Race"] = {
        Update = function()
            _, CurrentChar()["Race"] = UnitRace("player")
        end
    },
    ["Gender"] = {
        Update = function()
            CurrentChar()["Gender"] = UnitSex("player")
        end
    },
    ["Timestamp"] = {
        Update = function()
            CurrentChar()["Timestamp"] = time()
        end
    },
    ["Money"] = {
        Update = function()
            CurrentChar()["Money"] = GetMoney()
        end
    },
    ["ClassCampaign"] = {
        Update = function()
            local _, class = UnitClass("player")
            local quests = {
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
            CurrentChar()["ClassCampaign"] = IsQuestFlaggedCompleted(quests[class])
        end
    },
    ["BreachingTheTomb"] = {
        Update = function()
            _, _, _, _, _, _, _, _, _, _, _, _, 
            CurrentChar()["BreachingTheTomb"], _ = GetAchievementInfo(11546)
        end
    },
    ["ClassMount"] = {
        Update = function()
            local _, class = UnitClass("player")
            quests = {
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
            CurrentChar()["ClassMount"] = IsQuestFlaggedCompleted(quests[class])
        end
    },
    ["Level"] = {
        Update = function()
            CurrentChar()["Level"] = UnitLevel("player")
        end
    },
    ["Currencies"] = {
        Update = function()
            curIDs = { 
                1220, -- Order Resources
                1508, -- Veiled Argunite
                1273, -- Seal of Broken Fate
            }
            local char = CurrentChar()
            char["Currencies"] = {}
            for _, cid in pairs(curIDs) do
                if not char["Currencies"][cid] then 
                    char["Currencies"][cid] = {} 
                end
                char["Currencies"][cid]["Name"], 
                char["Currencies"][cid]["CurrentAmount"], 
                _, 
                char["Currencies"][cid]["EarnedThisWeek"], 
                char["Currencies"][cid]["WeeklyMax"],
                char["Currencies"][cid]["TotalMax"],
                char["Currencies"][cid]["IsDiscovered"] = GetCurrencyInfo(cid)
            end
        end
    },
    ["MountSpeed"] = {
        Update = function()
            local spellIDs = { 
                [60] = 33388, 
                [100] = 33391, 
                [150] = 34090, 
                [280] = 34091, 
                [310] = 90265 
            }
            local char = CurrentChar()
            char["MountSpeed"] = 0
            for speed, id in pairs(spellIDs) do
                if IsSpellKnown(id) then
                    if char["MountSpeed"] < speed then
                        char["MountSpeed"] = speed
                    end
                end
            end
        end
    },
    ["OrderHallUpgrades"] = {
        Update = function()
            _, _, _, _, _, _, _, _, _, _, _, _, 
            CurrentChar()["OrderHallUpgrades"], _ = GetAchievementInfo(11223)
        end
    },
    ["BalanceOfPower"] = {
        Update = function()
            _, _, _, _, _, _, _, _, _, _, _, _, 
            CurrentChar()["BalanceOfPower"], _ = GetAchievementInfo(10459)
        end
    },
    ["Gear"] = {
        Update = function()
            local slotIDs = {
                1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
            }
            local char = CurrentChar()
            char["Gear"] = {}
            for _, sid in pairs(slotIDs) do 
                -- GetItemInfo(link) this value to get ilvl, etc. later
                char["Gear"][sid] = GetInventoryItemLink("player", sid)
            end
        end
    },
    ["Professions"] = {
        Update = function()
            local char = CurrentChar()
            char["Professions"] = {}
            char["Professions"]["Prof1"] = {}
            char["Professions"]["Prof2"] = {}
            char["Professions"]["Archaeology"] = {}
            char["Professions"]["Fishing"] = {}
            char["Professions"]["Cooking"] = {}
            char["Professions"]["FirstAid"] = {}
            char["Professions"]["Prof1"]["Index"], 
            char["Professions"]["Prof2"]["Index"], 
            char["Professions"]["Archaeology"]["Index"], 
            char["Professions"]["Fishing"]["Index"],
            char["Professions"]["Cooking"]["Index"], 
            char["Professions"]["FirstAid"]["Index"] = GetProfessions()
            for k, v in pairs(char["Professions"]) do
                v["Name"], _, v["SkillLevel"], v["MaxSkillLevel"], _, _, v["SkillLine"], 
                v["SkillModifier"], v["SpecializationIndex"], _ = GetProfessionInfo(v["Index"])
            end
        end
    },
    ["MageTower"] = {
        Update = function()
            local quests = {
                46065, -- An Impossible Foe
                44925, -- Closing the Eye
                46035, -- End of the Risen Threat
                45627, -- Feltotem's Fall
                45526, -- The God-Queen's Fury
                45416, -- The Highlord's Return
                46127, -- Thwarting the Twins
            }
            local char = CurrentChar()
            char["MageTower"] = {}
            for k, v in pairs(quests) do
                char["MageTower"][v] = IsQuestFlaggedCompleted(v)
            end
        end
    },
    ["Followers"] = {
        Update = function()
            CurrentChar()["Followers"] = C_Garrison.GetFollowers()
        end
    },
    ["TimePlayed"] = {
        Update = function()
            local char = CurrentChar()
            if not char["TimePlayed"] then
                char["TimePlayed"] = {}
            end
        end,
        SpecialUpdate = function(total, thisLevel)
            local char = CurrentChar()
            char["TimePlayed"] = {}
            char["TimePlayed"]["Total"] = total
            char["TimePlayed"]["Level"] = thisLevel
        end
    },
    ["Artifacts"] = {
        Update = function()
            local char = CurrentChar()
            if not char["Artifacts"] then 
                char["Artifacts"] = {} 
            end
        end,
        SpecialUpdate = function()
            local char = CurrentChar()
            if not char["Artifacts"] then 
                char["Artifacts"] = {} 
            end
            local id, _, _, _, power, ranks, _, _, _, _, _, _ = C_ArtifactUI.GetArtifactInfo()
            char["Artifacts"][id] = {}
            char["Artifacts"][id]["Power"] = power
            char["Artifacts"][id]["Ranks"] = ranks
        end
    }
}

local function UpdateData()
    for k, v in pairs(fields) do
        v.Update()
    end
end

function events:PLAYER_ENTERING_WORLD(...)
    UpdateData()
end

function events:ARTIFACT_UPDATE(...)
    fields["Artifacts"].SpecialUpdate()
end

function events:TIME_PLAYED_MSG(...)
    local total, thisLevel = ...
    fields["TimePlayed"].SpecialUpdate(total, thisLevel)
end

local function RegisterEvents()
    local eventFrame = CreateFrame("FRAME", "AAM_eventFrame")
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...)
    end)
    for k, v in pairs(events) do
        eventFrame:RegisterEvent(k)
    end
end

RegisterEvents()
