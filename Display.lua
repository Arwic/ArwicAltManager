local dataLabels = {}
local realmFrames = {}
local charFrames = {}
local events = {}
local ElvUI_E, ElvUI_L, ElvUI_V, ElvUI_P, ElvUI_G, ElvUI_S
local allRealmGroups = {}
local allCharCols = {}

function table.len(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.containskey(t, k)
    for tk, _ in pairs(t) do
        if tk == k then
            return true
        end
    end
end

function table.containsval(t, v)
    for _, tv in pairs(t) do
        if tv == v then
            return true
        end
    end
end

function string.starts(s, v)
   return string.sub(s, 1, string.len(v)) == v
end

local function Config()
    return ArwicAltManagerDB.Config
end

local function ClassColor(className)
    return RAID_CLASS_COLORS[className].r, 
        RAID_CLASS_COLORS[className].g, 
        RAID_CLASS_COLORS[className].b
end

local function GetMageTowerPrereqIDs(class)
    if class == "DEATHKNIGHT" then
        return {
            ["Frost"] = 45865, -- Closing the Eye
            ["Unholy"] = 46065, -- An Impossible Foe
            ["Blood"] = 45863, -- The Highlord's Return
        }
    elseif class == "DEMONHUNTER" then
        return {
            ["Havoc"] = 45865, -- Closing the Eye
            ["Vengeance"] = 45863, -- The Highlord's Return
        }
    elseif class == "DRUID" then
        return {
            ["Balance"] = 45866, -- Thwarting the Twins
            ["Guardian"] = 45863, -- The Highlord's Return
            ["Feral"] = 46065, -- An Impossible Foe
            ["Restoration"] = 46035, -- End of the Risen Threat
        }
    elseif class == "HUNTER" then
        return {
            ["Marksmanship"] = 45866, -- Thwarting the Twins
            ["Beast Mastery"] = 45842, -- Feltotem's Fall
            ["Survival"] = 45865, -- Closing the Eye
        }
    elseif class == "MAGE" then
        return {
            ["Fire"] = 46065, -- An Impossible Foe
            ["Frost"] = 45866, -- Thwarting the Twins
            ["Arcane"] = 45862, -- The God-Queen's Fury
        }
    elseif class == "MONK" then
        return {
            ["Windwalker"] = 45842, -- Feltotem's Fall
            ["Mistweaver"] = 46035, -- End of the Risen Threat
            ["Brewmaster"] = 45863, -- The Highlord's Return
        }
    elseif class == "PALADIN" then
        return {
            ["Retribution"] = 45862, -- The God-Queen's Fury
            ["Holy"] = 46035, -- End of the Risen Threat
            ["Protection"] = 45863, -- The Highlord's Return
        }
    elseif class == "PRIEST" then
        return {
            ["Shadow"] = 45866, -- Thwarting the Twins
            ["Holy"] = 46035, -- End of the Risen Threat
            ["Discipline"] = 45842, -- Feltotem's Fall
        }
    elseif class == "ROGUE" then
        return {
            ["Assassination"] = 45862, -- The God-Queen's Fury
            ["Outlaw"] = 46065, -- An Impossible Foe
            ["Subtlety"] = 45865, -- Closing the Eye
        }
    elseif class == "SHAMAN" then
        return {
            ["Enhancement"] = 45862, -- The God-Queen's Fury
            ["Elemental"] = 46065, -- An Impossible Foe
            ["Restoration"] = 46035, -- End of the Risen Threat
        }
    elseif class == "WARLOCK" then
        return {
            ["Affliction"] = 45866, -- Thwarting the Twins
            ["Destruction"] = 45842, -- Feltotem's Fall
            ["Demonology"] = 45862, -- The God-Queen's Fury
        }
    elseif class == "WARRIOR" then
        return {
            ["Arms"] = 45865, -- Closing the Eye
            ["Fury"] = 46065, -- An Impossible Foe
            ["Protection"] = 45863, -- The Highlord's Return
        }
    end
end

local function GetMageTowerIDs(class)
    if class == "DEATHKNIGHT" then
        return {
            ["Frost"] = 44925, -- Closing the Eye
            ["Unholy"] = 46065, -- An Impossible Foe
            ["Blood"] = 45416, -- The Highlord's Return
        }
    elseif class == "DEMONHUNTER" then
        return {
            ["Havoc"] = 44925, -- Closing the Eye
            ["Vengeance"] = 45416, -- The Highlord's Return
        }
    elseif class == "DRUID" then
        return {
            ["Balance"] = 46127, -- Thwarting the Twins
            ["Guardian"] = 45416, -- The Highlord's Return
            ["Feral"] = 46065, -- An Impossible Foe
            ["Restoration"] = 46035, -- End of the Risen Threat
        }
    elseif class == "HUNTER" then
        return {
            ["Marksmanship"] = 46127, -- Thwarting the Twins
            ["Beast Mastery"] = 45627, -- Feltotem's Fall
            ["Survival"] = 44925, -- Closing the Eye
        }
    elseif class == "MAGE" then
        return {
            ["Fire"] = 46065, -- An Impossible Foe
            ["Frost"] = 46127, -- Thwarting the Twins
            ["Arcane"] = 45526, -- The God-Queen's Fury
        }
    elseif class == "MONK" then
        return {
            ["Windwalker"] = 45627, -- Feltotem's Fall
            ["Mistweaver"] = 46035, -- End of the Risen Threat
            ["Brewmaster"] = 45416, -- The Highlord's Return
        }
    elseif class == "PALADIN" then
        return {
            ["Retribution"] = 45526, -- The God-Queen's Fury
            ["Holy"] = 46035, -- End of the Risen Threat
            ["Protection"] = 45416, -- The Highlord's Return
        }
    elseif class == "PRIEST" then
        return {
            ["Shadow"] = 46127, -- Thwarting the Twins
            ["Holy"] = 46035, -- End of the Risen Threat
            ["Discipline"] = 45627, -- Feltotem's Fall
        }
    elseif class == "ROGUE" then
        return {
            ["Assassination"] = 45526, -- The God-Queen's Fury
            ["Outlaw"] = 46065, -- An Impossible Foe
            ["Subtlety"] = 44925, -- Closing the Eye
        }
    elseif class == "SHAMAN" then
        return {
            ["Enhancement"] = 45526, -- The God-Queen's Fury
            ["Elemental"] = 46065, -- An Impossible Foe
            ["Restoration"] = 46035, -- End of the Risen Threat
        }
    elseif class == "WARLOCK" then
        return {
            ["Affliction"] = 46127, -- Thwarting the Twins
            ["Destruction"] = 45627, -- Feltotem's Fall
            ["Demonology"] = 45526, -- The God-Queen's Fury
        }
    elseif class == "WARRIOR" then
        return {
            ["Arms"] = 44925, -- Closing the Eye
            ["Fury"] = 46065, -- An Impossible Foe
            ["Protection"] = 45416, -- The Highlord's Return
        }
    end
end

local function FactionColor(factionName)
    if factionName == "Alliance" then
        return 0, 0.8, 1
    elseif factionName == "Horde" then
        return 0.85, 0, 0
    end
end

local function ClassName(classID)
    if classID == "DEMONHUNTER" then
        return "Demon Hunter"
    elseif classID == "DEATHKNIGHT" then
        return "Death Knight"
    end
    return classID:sub(1,1):upper() .. classID:sub(2):lower()
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

local function CharData(name, realm)
    return ArwicAltManagerDB.Realms[realm].Characters[name]
end

local function AllRealmChars(realm)
    return ArwicAltManagerDB.Realms[realm]
end

local function Account()
    return ArwicAltManagerDB.Account
end

local fieldFormatters = {
    ["Name"] = {
        Label = "Name",
        Order = 10,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Character Name", TooltipHeaderColor())
            GameTooltip:AddLine(format("%s - %s", char.Name, char.Realm), ClassColor(char.Class))
            GameTooltip:AddLine(format("Level %d %s %s", char.Level, char.Race, ClassName(char.Class)), ClassColor(char.Class))
            GameTooltip:Show()
        end,
        Value = function(char)
            return char.Name
        end,
        Color = function(char)
            return ClassColor(char.Class)
        end,
    },
    ["Class"] = {
        Label = "Class",
        Order = 20,
        Display = false,
        Value = function(char)
            return ClassName(char.Class)
        end,
        Color = function(char)
            return ClassColor(char.Class)
        end,
    },
    ["Realm"] = {
        Label = "Realm",
        Order = 40,
        Display = true,
        Value = function(char)
            return char.Realm
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
            return char.Faction
        end,
        Color = function(char)
            return FactionColor(char.Faction)
        end,
    },
    ["Race"] = {
        Label = "Race",
        Order = 60,
        Display = false,
        Value = function(char)
            return char.Race
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
            return map[char.Gender]
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Timestamp"] = {
        Label = "Updated",
        Order = 1000,
        Display = true,
        Tooltip = function(char)
            local days, hours, minutes, seconds = FormatTime(time() - char.Timestamp)
            GameTooltip:AddLine("Time since character data updated", TooltipHeaderColor())
            GameTooltip:AddLine(format("%d days %d hrs %d mins %d secs", days, hours, minutes, seconds))
            GameTooltip:Show()
        end,
        Value = function(char)
            if not char.Timestamp then
                return "?"
            end
            local dt = time() - char.Timestamp
            local days, hours, minutes, seconds = FormatTime(dt)
            if days > 0 then
                return format("%d days ago", days)
            elseif hours > 0 then
                return format("%d hrs ago", hours)
            elseif minutes > 0 then
                return format("%d mins ago", minutes)
            else
                return format("%d secs ago", seconds)
            end
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Money"] = {
        Label = "|T133784:0|t Gold",
        Order = 80,
        Display = true,
        Tooltip = function(char)
            local g = floor(char.Money / 100 / 100)
            local s = (char.Money / 100) % 100
            local c = char.Money % 100
            GameTooltip:AddLine("Character Wealth", TooltipHeaderColor())
            GameTooltip:AddLine(format("%sg %ds %dc", FormatInt(g), s, c))
            GameTooltip:Show()
        end,
        Value = function(char)
            local g = floor(char.Money / 100 / 100)
            local str = format("%sg", FormatInt(g))
            return str
        end,
        Color = function(char)
            if (char.Money / 100 / 100) < Config().GoldThreshold then
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
            return FormatBool(char.ClassCampaign)
        end,
        Color = function(char)
            if not char.ClassCampaign then
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
            return FormatBool(char.ClassMount)
        end,
        Color = function(char)
            if not char.ClassMount then
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
            return char.Level
        end,
        Color = function(char)
            if char.Level < Config().LevelThreshold then
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
            return format("%s%%", char.MountSpeed)
        end,
        Color = function(char)
            if char.MountSpeed < Config().MountSpeedThreshold then
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
            return FormatBool(char.OrderHallUpgrades)
        end,
        Color = function(char)
            if not char.OrderHallUpgrades then
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
            return FormatBool(char.BalanceOfPower)
        end,
        Color = function(char)
            if not char.BalanceOfPower then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["KeystoneMaster"] = {
        Label = "Keystone Master",
        Order = 135,
        Display = true,
        Value = function(char)
            return FormatBool(char.KeystoneMaster)
        end,
        Color = function(char)
            if not char.KeystoneMaster then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["MageTowerPrereq"] = {
        Label = "Mage Tower Unlocked",
        Order = 139,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Mage Tower Unlocked", TooltipHeaderColor())
            for k, v in pairs(GetMageTowerPrereqIDs(char.Class)) do
                GameTooltip:AddDoubleLine(k, FormatBool(char.MageTowerPrereq[v]))
            end
            GameTooltip:Show()
        end,
        Value = function(char)
            if char.MageTowerPrereq then
                local count = 0
                for k, v in pairs(char.MageTowerPrereq) do
                    if v then
                        count = count + 1
                    end
                end
                local maxCount = 3
                if char.Class == "DEMONHUNTER" then maxCount = 2 end
                if char.Class == "DRUID" then maxCount = 4 end
                local str = format("%d/%d", count, maxCount)
                return str
            end
            return ""
        end,
        Color = function(char)
            if char.MageTowerPrereq then
                local count = 0
                for k, v in pairs(char.MageTowerPrereq) do
                    if v then
                        count = count + 1
                    end
                end
                local maxCount = 3
                if char.Class == "DEMONHUNTER" then maxCount = 2 end
                if char.Class == "DRUID" then maxCount = 4 end
                if count ~= maxCount then
                    return ErrorColor()
                end
                return DefaultColor()
            end
            return ErrorColor()
        end,
    },
    ["MageTower"] = {
        Label = "Mage Tower Completed",
        Order = 140,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Mage Tower Completed", TooltipHeaderColor())
            for k, v in pairs(GetMageTowerIDs(char.Class)) do
                GameTooltip:AddDoubleLine(k, FormatBool(char.MageTower[v]))
            end
            GameTooltip:Show()
        end,
        Value = function(char)
            local count = 0
            for k, v in pairs(char.MageTower) do
                if v then
                    count = count + 1
                end
            end
            local maxCount = 3
            if char.Class == "DEMONHUNTER" then maxCount = 2 end
            if char.Class == "DRUID" then maxCount = 4 end
            local str = format("%d/%d", count, maxCount)
            return str
        end,
        Color = function(char)
            local count = 0
            for k, v in pairs(char.MageTower) do
                if v then
                    count = count + 1
                end
            end
            local maxCount = 3
            if char.Class == "DEMONHUNTER" then maxCount = 2 end
            if char.Class == "DRUID" then maxCount = 4 end
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
        Tooltip = function(char)
            GameTooltip:AddLine("Time Played", TooltipHeaderColor())
            GameTooltip:AddLine(format("Total: %d days %d hrs %d mins %d secs", FormatTime(char.TimePlayed.Total)))
            GameTooltip:AddLine(format("This Level: %d days %d hrs %d mins %d secs", FormatTime(char.TimePlayed.Level)))
            GameTooltip:Show()
        end,
        Value = function(char)
            return format("%d:%02d:%02d:%02d", FormatTime(char.TimePlayed.Total))
        end,
        Color = function(char)
            return DefaultColor()
        end,
    },
    ["Artifacts"] = {
        Label = "Artifact Levels",
        Order = 100,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Artifact Levels", TooltipHeaderColor())
            for k, v in pairs(char.Artifacts) do
                if k ~= 133755 then -- dont show fishing artifact
                    if v.Name == nil then v.Name = "UNKNOWN" end
                    GameTooltip:AddDoubleLine(format("%s", v.Name), format("%d", v.Ranks))
                end
            end
            GameTooltip:Show()
        end,
        Value = function(char)
            local str = ""
            for k, v in pairs(char.Artifacts) do
                if k ~= 133755 then -- ignore fishing artifact
                    str = format("%s, %d", str, v.Ranks) 
                end
            end
            return str:sub(3) -- remove the first 2 characters ", "
        end,
        Color = function(char)
            for k, v in pairs(char.Artifacts) do
                if v.Ranks < Config().ArtifactRankThreshold and k ~= 133755 then -- ignore fishing artifact
                    return ErrorColor()
                end
            end
            return DefaultColor()
        end,
    },
    ["OrderHallResouces"] = {
        Label = "|T1397630:0|t Order Resouces",
        Order = 90,
        Display = true,
        Value = function(char)
            if not char.Currencies then
                return ""
            end
            return char.Currencies[1220].CurrentAmount
        end,
        Color = function(char)
            if not char.Currencies then
                return ErrorColor()
            end
            if char.Currencies[1220].CurrentAmount < Config().OrderHallResourcesThreshold then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },
    ["WakeningEssence"] = {
        Label = "|T236521:0|t Wakening Essence",
        Order = 91,
        Display = true,
        Value = function(char)
            if not char.Currencies or not char.Currencies[1533] then
                return ""
            end
            return char.Currencies[1533].CurrentAmount
        end,
        Color = function(char)
            if not char.Currencies or not char.Currencies[1533] then
                return ErrorColor()
            end
            local cur = char.Currencies[1533].CurrentAmount
            if cur > 1000 then
                return SuccessColor()
            end
            return DefaultColor()
        end,
    },
    ["Gear"] = {
        Label = "Gear",
        Order = 21,
        Display = true,
        Tooltip = function(char)
            if char.Gear.AvgItemLevelBags ~= nil then
                GameTooltip:AddLine("Equipped Gear", TooltipHeaderColor())
                for k, v in pairs(char.Gear.Items) do
                    GameTooltip:AddDoubleLine(_G[v.EquipLoc], format("%s (%d) |T%s:0|t", v.Name, v.ItemLevel, v.Texture), 
                                                nil, nil, nil, GetItemQualityColor(v.Rarity))
                end
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Gear.AvgItemLevelBags == nil then
                return "?"
            end
            return format("%.1f / %.1f", char.Gear.AvgItemLevelEquipped, char.Gear.AvgItemLevelBags)
        end,
        Color = function(char)
            if char.Gear.AvgItemLevelBags == nil then
                return ErrorColor()
            end
            return DefaultColor()
        end,
    },

    --------------------------------------------------------------------
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    --------------------- TEMP ACCOUNT WIDE DATA -----------------------
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    ["Mount_VioletSpellwing"] = {
        Label = "Violet Spellwing",
        Order = 500,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Violet Spellwing", TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Heroic difficulty or higher in Antorus, the Burning Throne.")
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
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Mythic difficulty in Antorus, the Burning Throne.")
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
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Mythic difficulty in the Nighthold.")
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
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Normal difficulty or higher in the Nighthold.")
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
            GameTooltip:AddLine("Obtained by defeating Mistress Sassz'ine on Raid Finder difficulty or higher in the Tomb of Sargeras.")
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
            GameTooltip:AddLine("Obtained by defeating Felhounds of Sargeras on Raid Finder difficulty or higher in Antorus, the Burning Throne.")
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
    },
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
    local closeButton = CreateFrame("BUTTON", "AAM_closeButton", AAM_titleBarFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetScript("OnClick", function()
        mainFrame:Hide()
    end)

    -- config button
    local configButton = CreateFrame("BUTTON", "AAM_closeButton", AAM_titleBarFrame, "OptionsBoxTemplate")
    configButton:SetPoint("TOPRIGHT", closeButton, "TOPLEFT")
    configButton:SetWidth(titleBarHeight)
    configButton:SetHeight(titleBarHeight)
    configButton:SetScript("OnClick", function()
        mainFrame:Hide()
        ARWIC_AAM_ShowConfig()
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
                    for formatterKey, formatter in spairs(fieldFormatters, function(t, a, b)
                        return t[a].Order < t[b].Order
                    end) do
                        if formatter.Display then
                            -- make the cell
                            local cellFrame = CreateFrame("FRAME", "AAM_charCell_" .. realmKey .. "_" .. charKey .. "_" .. formatterKey, charCol)
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
                            -- register the label's tooltip
                            cellFrame:SetScript("OnEnter", function(sender)
                                GameTooltip:SetOwner(sender, "ANCHOR_RIGHT")
                                if formatter.Tooltip ~= nil then
                                    formatter.Tooltip(char)
                                    --[[local ttLines = formatter.Tooltip(char)
                                    for k, v in pairs(ttLines) do
                                        if v.Text ~= nil then
                                            if v.Color == nil then
                                                v.Color = { nil, nil, nil, nil }
                                            end
                                            GameTooltip:AddLine(v.Text, v.Color[1], v.Color[2], v.Color[3], v.Color[4], true)
                                        elseif v.TextLeft ~= nil and v.TextRight ~= nil then
                                            if v.ColorLeft == nil then
                                                v.ColorLeft = { nil, nil, nil, nil }
                                            end
                                            if v.ColorRight == nil then
                                                v.ColorRight = { nil, nil, nil, nil }
                                            end
                                            GameTooltip:AddDoubleLine(v.TextLeft, v.TextRight, 
                                                v.ColorLeft[1], v.ColorLeft[2], v.ColorLeft[3], 
                                                v.ColorRight[1], v.ColorRight[2], v.ColorRight[3])
                                        end
                                    end
                                    GameTooltip:Show()]]--
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
end

local function UpdateGrid()
    -- make sure we have a grid
    BuildGrid()
    -- update the values in the grid
    for _, v in pairs(dataLabels) do
        v.lbl:SetText(v.formatter.Value(v.char))
        v.lbl:SetTextColor(v.formatter.Color(v.char))
    end
end

-- loads display and order of field formatters from file
local function InitFormatters()
    if ArwicAltManagerDB.Config.FieldFormatters then
        local configFF = ArwicAltManagerDB.Config.FieldFormatters
        for k, v in pairs(configFF) do
            fieldFormatters[k].Display = v.Display
            fieldFormatters[k].Order = tonumber(v.Order)
        end
    else
        ArwicAltManagerDB.Config.FieldFormatters = {}
        local configFF = ArwicAltManagerDB.Config.FieldFormatters
        for k, v in pairs(fieldFormatters) do
            configFF[k] = {}
            configFF[k].Display = v.Display
            configFF[k].Order = tonumber(v.Order)
        end
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

function events:PLAYER_ENTERING_WORLD(...)
    -- init formatters
    InitFormatters()
    -- get elvui
    if ElvIU then
        ElvUI_E, ElvUI_L, ElvUI_V, ElvUI_P, ElvUI_G = unpack(ElvUI)
        ElvUI_S = ElvUI_E:GetModule("Skins")
    end
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

SLASH_AAM1 = "/aam"
SLASH_AAM2 = "/arwicaltmanager"
SlashCmdList["AAM"] = function(msg)
    local args = {}
    for a in string.gmatch(msg, "%S+") do
        table.insert(args, a)
    end
    if args[1] == "update" then
        ARWIC_AAM_UpdateData()
        print("AAM: Updated data for " .. UnitName("player") .. "-" .. GetRealmName())
        if ARWIC_AAM_mainFrame then
            ARWIC_AAM_Show()
        end
    elseif args[1] == "config" then
        ARWIC_AAM_ToggleConfig()
    elseif args[1] == "char" and args[2] == "hide" then
        local charName = args[3]:gsub("^%l", string.upper)
        local realmName = args[4]:gsub("^%l", string.upper)
        if ArwicAltManagerDB.Realms[realmName] then
            if ArwicAltManagerDB.Realms[realmName].Characters[charName] then
                CharData(charName, realmName).Display = false
                print(format("AAM: Character '%s-%s' will now be hidden.", charName, realmName))
                print("AAM: You will need to '/reload' for changes to take effect")
            else
                print("AAM: Unable to find character name: " .. charName)
            end
        else
            print("AAM: Unable to find realm: %s" .. realmName)
        end
    elseif args[1] == "char" and args[2] == "show" then
        local charName = args[3]:gsub("^%l", string.upper)
        local realmName = args[4]:gsub("^%l", string.upper)
        if ArwicAltManagerDB.Realms[realmName] then
            if ArwicAltManagerDB.Realms[realmName].Characters[charName] then
                CharData(charName, realmName).Display = true
                print(format("AAM: Character '%s-%s' will now be displayed.", charName, realmName))
                print("AAM: You will need to '/reload' for changes to take effect")
            else
                print("AAM: Unable to find character name: " .. charName)
            end
        else
            print("AAM: Unable to find realm: %s" .. realmName)
        end
    elseif args[1] == "realm" and args[2] == "hide" then
        local realmName = args[3]:gsub("^%l", string.upper)
        if ArwicAltManagerDB.Realms[realmName] then
            ArwicAltManagerDB.Realms[realmName].Display = false
            print(format("AAM: Realm '%s' will now be hidden.", realmName))
            print("AAM: You will need to '/reload' for changes to take effect")
        else
            print("AAM: Unable to find realm: " .. realmName)
        end
    elseif args[1] == "realm" and args[2] == "show" then
        local realmName = args[3]:gsub("^%l", string.upper)
        if ArwicAltManagerDB.Realms[realmName] then
            ArwicAltManagerDB.Realms[realmName].Display = true
            print(format("AAM: Realm '%s' will now be displayed.", realmName))
            print("AAM: You will need to '/reload' for changes to take effect")
        else
            print("AAM: Unable to find realm: " .. realmName)
        end
    else
        if ARWIC_AAM_mainFrame then
            ARWIC_AAM_Toggle()
        else
            BuildGrid()
        end
    end
end
