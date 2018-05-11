local AAM = ArwicAltManager

local function CurrentChar()
    return ArwicAltManagerDB.Realms[GetRealmName()].Characters[UnitName("player")]
end

if ArwicAltManager.Fields == nil then ArwicAltManager.Fields = {} end
ArwicAltManager.Fields.Character = {
    ["INTERNAL_Currencies"] = {
        Internal = true,
        Display = false,
        Order = 0,
        Update = function()
            curIDs = {
                61, -- Dalaran Jewelcrafter's Token
                81, -- Epicurean's Award
                241, -- Champion's Seal
                361, -- Illustrious Jewelcrafter's Token
                384, -- Dwarf Archaeology Fragment
                385, -- Troll Archaeology Fragment
                390, -- Conquest Points
                391, -- Tol Barad Commendation
                392, -- Honor Points
                393, -- Fossil Archaeology Fragment
                394, -- Night Elf Archaeology Fragment
                395, -- Justice Points
                396, -- Valor Points
                397, -- Orc Archaeology Fragment
                398, -- Draenei Archaeology Fragment
                399, -- Vrykul Archaeology Fragment
                400, -- Nerubian Archaeology Fragment
                401, -- Tol'vir Archaeology Fragment
                402, -- Chef's Award
                416, -- Mark of the World Tree
                515, -- Darkmoon Prize Ticket
                614, -- Mote of Darkness
                615, -- Essence of Corrupted Deathwing
                676, -- Pandaren Archaeology Fragment
                677, -- Mogu Archaeology Fragment
                697, -- Elder Charm of Good Fortune
                738, -- Lesser Charm of Good Fortune
                752, -- Mogu Rune of Fate
                754, -- Mantid Archaeology Fragment
                776, -- Warforged Seal
                777, -- Timeless Coin
                789, -- Bloody Coin
                821, -- Draenor Clans Archaeology Fragment
                823, -- Apexis Crystal
                824, -- Garrison Resources
                828, -- Ogre Archaeology Fragment
                829, -- Arakkoa Archaeology Fragment
                910, -- Seal of Draenor Alchemy
                944, -- Artifact Fragment
                980, -- Dingy Iron Coins
                994, -- Seal of Tempered Fate
                999, -- Secret of Draenor Tailoring
                1008, -- Secret of Draenor Jewelcrafting
                1017, -- Secret of Draenor Leatherworking
                1020, -- Secret of Draenor Blacksmithing
                1101, -- Oil
                1129, -- Seal of Inevitable Fate
                1149, -- Sightless Eye
                1154, -- Shadowy Coins
                1155, -- Ancient Mana
                1166, -- Timewarped Badge
                1171, -- Artifact Knowledge
                1172, -- Highborne Archaeology Fragment
                1173, -- Highmountain Tauren Archaeology Fragment
                1174, -- Demonic Archaeology Fragment
                1191, -- Valor
                1220, -- Order Resources
                1226, -- Nethershard
                1268, -- Timeworn Artifact
                1273, -- Seal of Broken Fate
                1275, -- Curious Coin
                1299, -- Brawler's Gold
                1314, -- Lingering Soul Fragment
                1324, -- Horde Qiraji Commendation
                1325, -- Alliance Qiraji Commendation
                1342, -- Legionfall War Supplies
                1347, -- Legionfall Building - Personal Tracker - Mage Tower (Hidden)
                1349, -- Legionfall Building - Personal Tracker - Command Tower (Hidden)
                1350, -- Legionfall Building - Personal Tracker - Nether Tower (Hidden)
                1355, -- Felessence
                1356, -- Echoes of Battle
                1357, -- Echoes of Domination
                1379, -- Trial of Style Token
                1416, -- Coins of Air
                1506, -- Argus Waystone
                1508, -- Veiled Argunite
                1533, -- Wakening Essence
            }
            local char = CurrentChar()
            char["Currencies"] = {}
            for _, cid in pairs(curIDs) do
                if not char.Currencies[cid] then 
                    char.Currencies[cid] = {} 
                end
                char.Currencies[cid].Name, 
                char.Currencies[cid].CurrentAmount, 
                _, 
                char.Currencies[cid].EarnedThisWeek, 
                char.Currencies[cid].WeeklyMax,
                char.Currencies[cid].TotalMax,
                char.Currencies[cid].IsDiscovered = GetCurrencyInfo(cid)
            end
        end,
    },
    ["Name"] = {
        Label = "Name",
        Order = 10,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Character Name", AAM.TooltipHeaderColor())
            GameTooltip:AddLine(format("%s - %s", char.Name, char.Realm), AAM.ClassColor(char.Class))
            GameTooltip:AddLine(format("Level %d %s %s", char.Level, char.Race, AAM.ClassName(char.Class)), AAM.ClassColor(char.Class))
            GameTooltip:Show()
        end,
        Value = function(char)
            return char.Name
        end,
        Color = function(char)
            return AAM.ClassColor(char.Class)
        end,
        Update = function()
            CurrentChar().Name = UnitName("player")
        end,
    },
    ["Class"] = {
        Label = "Class",
        Order = 20,
        Display = false,
        Tooltip = function(char)
            GameTooltip:AddLine(format("%s - %s", char.Name, char.Realm), AAM.ClassColor(char.Class))
            GameTooltip:AddLine("Class")
            GameTooltip:AddLine(AAM.ClassName(char.Class), AAM.ClassColor(char.Class))
        end,
        Value = function(char)
            return AAM.ClassName(char.Class)
        end,
        Color = function(char)
            return AAM.ClassColor(char.Class)
        end,
        Update = function()
            CurrentChar().Class = select(2, UnitClass("player"))
        end,
    },
    ["Realm"] = {
        Label = "Realm",
        Order = 40,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine(format("%s - %s", char.Name, char.Realm), AAM.ClassColor(char.Class))
            GameTooltip:AddLine("Realm")
            GameTooltip:AddLine(char.Realm, AAM.DefaultColor())
        end,
        Value = function(char)
            return char.Realm
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Realm = GetRealmName()
        end,
    },
    ["Faction"] = {
        Label = "Faction",
        Order = 30,
        Display = false,
        Tooltip = function(char)
            GameTooltip:AddLine(format("%s - %s", char.Name, char.Realm), AAM.ClassColor(char.Class))
            GameTooltip:AddLine("Faction")
            GameTooltip:AddLine(char.Realm, AAM.DefaultColor())
        end,
        Value = function(char)
            return char.Faction
        end,
        Color = function(char)
            return AAM.FactionColor(char.Faction)
        end,
        Update = function()
            CurrentChar().Faction = UnitFactionGroup("player")
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
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Race = select(2, UnitRace("player"))
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
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Gender = UnitSex("player")
        end,
    },
    ["Timestamp"] = {
        Label = "Updated",
        Order = 1000,
        Display = true,
        Tooltip = function(char)
            local days, hours, minutes, seconds = AAM.FormatTime(time() - char.Timestamp)
            GameTooltip:AddLine("Time since character data updated", AAM.TooltipHeaderColor())
            GameTooltip:AddLine(format("%d days %d hrs %d mins %d secs", days, hours, minutes, seconds))
            GameTooltip:Show()
        end,
        Value = function(char)
            if not char.Timestamp then
                return "?"
            end
            local dt = time() - char.Timestamp
            local days, hours, minutes, seconds = AAM.FormatTime(dt)
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
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Timestamp = time()
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
            GameTooltip:AddLine("Character Wealth", AAM.TooltipHeaderColor())
            GameTooltip:AddLine(format("%sg %ds %dc", AAM.FormatInt(g), s, c))
            GameTooltip:Show()
        end,
        Value = function(char)
            local g = floor(char.Money / 100 / 100)
            local str = format("%sg", AAM.FormatInt(g))
            return str
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Money = GetMoney()
        end,
    },
    ["ClassCampaign"] = {
        Label = "Class Campaign",
        Order = 110,
        Display = true,
        Value = function(char)
            return AAM.FormatBool(char.ClassCampaign)
        end,
        Color = function(char)
            if not char.ClassCampaign then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
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
            CurrentChar().ClassCampaign = IsQuestFlaggedCompleted(quests[class])
        end,
    },
    ["ClassMount"] = {
        Label = "Class Mount",
        Order = 120,
        Display = true,
        Value = function(char)
            return AAM.FormatBool(char.ClassMount)
        end,
        Color = function(char)
            if not char.ClassMount then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
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
            CurrentChar().ClassMount = IsQuestFlaggedCompleted(quests[class])
        end,
    },
    ["BreachingTheTomb"] = {
        Label = "Breaching The Tomb",
        Order = 121,
        Display = true,
        Tooltip = function(char)
            GameTooltip:SetHyperlink(char.BreachingTheTomb.Link)
            GameTooltip:Show()
        end,
        Value = function(char)
            return AAM.FormatBool(char.BreachingTheTomb.Completed)
        end,
        Color = function(char)
            if not char.BreachingTheTomb.Completed then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().BreachingTheTomb = {}
            CurrentChar().BreachingTheTomb.Completed = select(13, GetAchievementInfo(11546))
            CurrentChar().BreachingTheTomb.Link = GetAchievementLink(11546)
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
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Level = UnitLevel("player")
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
            return AAM.DefaultColor()
        end,
        Update = function()
            local spellIDs = { 
                [60] = 33388, 
                [100] = 33391, 
                [150] = 34090, 
                [280] = 34091, 
                [310] = 90265 
            }
            local char = CurrentChar()
            char.MountSpeed = 0
            for speed, id in pairs(spellIDs) do
                if IsSpellKnown(id) then
                    if char.MountSpeed < speed then
                        char.MountSpeed = speed
                    end
                end
            end
        end,
    },
    ["OrderHallUpgrades"] = {
        Label = "All Order Hall Upgrades",
        Order = 130,
        Display = true,
        Value = function(char)
            return AAM.FormatBool(char.OrderHallUpgrades)
        end,
        Color = function(char)
            if not char.OrderHallUpgrades then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().OrderHallUpgrades = select(13, GetAchievementInfo(11223))
        end,
    },
    ["BalanceOfPower"] = {
        Label = "Balance of Power",
        Order = 150,
        Display = true,
        Value = function(char)
            return AAM.FormatBool(char.BalanceOfPower)
        end,
        Color = function(char)
            if not char.BalanceOfPower then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().BalanceOfPower = select(13, GetAchievementInfo(10459))
        end,
    },
    ["KeystoneMaster"] = {
        Label = "Keystone Master",
        Order = 135,
        Display = true,
        Value = function(char)
            return AAM.FormatBool(char.KeystoneMaster)
        end,
        Color = function(char)
            if not char.KeystoneMaster then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().KeystoneMaster = select(13, GetAchievementInfo(11162))
        end,
    },
    ["MageTowerPrereq"] = {
        Label = "Mage Tower Unlocked",
        Order = 139,
        Display = true,
        Tooltip = function(char)
            local ids = {
                ["DEATHKNIGHT"] = {
                    ["Frost"] = 45865, -- Closing the Eye
                    ["Unholy"] = 45861, -- An Impossible Foe
                    ["Blood"] = 45863, -- The Highlord's Return
                },
                ["DEMONHUNTER"] = {
                    ["Havoc"] = 45865, -- Closing the Eye
                    ["Vengeance"] = 45863, -- The Highlord's Return
                },
                ["DRUID"] = {
                    ["Balance"] = 45866, -- Thwarting the Twins
                    ["Guardian"] = 45863, -- The Highlord's Return
                    ["Feral"] = 45861, -- An Impossible Foe
                    ["Restoration"] = 45864, -- End of the Risen Threat
                },
                ["HUNTER"] = {
                    ["Marksmanship"] = 45866, -- Thwarting the Twins
                    ["Beast Mastery"] = 45842, -- Feltotem's Fall
                    ["Survival"] = 45865, -- Closing the Eye
                },
                ["MAGE"] = {
                    ["Fire"] = 45861, -- An Impossible Foe
                    ["Frost"] = 45866, -- Thwarting the Twins
                    ["Arcane"] = 45862, -- The God-Queen's Fury
                },
                ["MONK"] = {
                    ["Windwalker"] = 45842, -- Feltotem's Fall
                    ["Mistweaver"] = 45864, -- End of the Risen Threat
                    ["Brewmaster"] = 45863, -- The Highlord's Return
                },
                ["PALADIN"] = {
                    ["Retribution"] = 45862, -- The God-Queen's Fury
                    ["Holy"] = 45864, -- End of the Risen Threat
                    ["Protection"] = 45863, -- The Highlord's Return
                },
                ["PRIEST"] = {
                    ["Shadow"] = 45866, -- Thwarting the Twins
                    ["Holy"] = 45864, -- End of the Risen Threat
                    ["Discipline"] = 45842, -- Feltotem's Fall
                },
                ["ROGUE"] = {
                    ["Assassination"] = 45862, -- The God-Queen's Fury
                    ["Outlaw"] = 45861, -- An Impossible Foe
                    ["Subtlety"] = 45865, -- Closing the Eye
                },
                ["SHAMAN"] = {
                    ["Enhancement"] = 45862, -- The God-Queen's Fury
                    ["Elemental"] = 45861, -- An Impossible Foe
                    ["Restoration"] = 45864, -- End of the Risen Threat
                },
                ["WARLOCK"] = {
                    ["Affliction"] = 45866, -- Thwarting the Twins
                    ["Destruction"] = 45842, -- Feltotem's Fall
                    ["Demonology"] = 45862, -- The God-Queen's Fury
                },
                ["WARRIOR"] = {
                    ["Arms"] = 45865, -- Closing the Eye
                    ["Fury"] = 45861, -- An Impossible Foe
                    ["Protection"] = 45863, -- The Highlord's Return
                },
            }
            GameTooltip:AddLine("Mage Tower Unlocked", AAM.TooltipHeaderColor())
            for k, v in pairs(ids[char.Class]) do
                GameTooltip:AddDoubleLine(k, AAM.FormatBool(char.MageTowerPrereq[v]))
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
                    return AAM.ErrorColor()
                end
                return AAM.DefaultColor()
            end
            return AAM.ErrorColor()
        end,
        Update = function()
            local quests = {
                45864,
                45842,
                45861,
                45862,
                45865,
                45866,
                45863,
            }
            local char = CurrentChar()
            char.MageTowerPrereq = {}
            for k, v in pairs(quests) do
                char.MageTowerPrereq[v] = IsQuestFlaggedCompleted(v)
            end
        end,
    },
    ["MageTower"] = {
        Label = "Mage Tower Completed",
        Order = 140,
        Display = true,
        Tooltip = function(char)
            local ids = {
                ["DEATHKNIGHT"] = {
                    ["Frost"] = 44925, -- Closing the Eye
                    ["Unholy"] = 46065, -- An Impossible Foe
                    ["Blood"] = 45416, -- The Highlord's Return
                },
                ["DEMONHUNTER"] = {
                    ["Havoc"] = 44925, -- Closing the Eye
                    ["Vengeance"] = 45416, -- The Highlord's Return
                },
                ["DRUID"] = {
                    ["Balance"] = 46127, -- Thwarting the Twins
                    ["Guardian"] = 45416, -- The Highlord's Return
                    ["Feral"] = 46065, -- An Impossible Foe
                    ["Restoration"] = 46035, -- End of the Risen Threat
                },
                ["HUNTER"] = {
                    ["Marksmanship"] = 46127, -- Thwarting the Twins
                    ["Beast Mastery"] = 45627, -- Feltotem's Fall
                    ["Survival"] = 44925, -- Closing the Eye
                },
                ["MAGE"] = {
                    ["Fire"] = 46065, -- An Impossible Foe
                    ["Frost"] = 46127, -- Thwarting the Twins
                    ["Arcane"] = 45526, -- The God-Queen's Fury
                },
                ["MONK"] = {
                    ["Windwalker"] = 45627, -- Feltotem's Fall
                    ["Mistweaver"] = 46035, -- End of the Risen Threat
                    ["Brewmaster"] = 45416, -- The Highlord's Return
                },
                ["PALADIN"] = {
                    ["Retribution"] = 45526, -- The God-Queen's Fury
                    ["Holy"] = 46035, -- End of the Risen Threat
                    ["Protection"] = 45416, -- The Highlord's Return
                },
                ["PRIEST"] = {
                    ["Shadow"] = 46127, -- Thwarting the Twins
                    ["Holy"] = 46035, -- End of the Risen Threat
                    ["Discipline"] = 45627, -- Feltotem's Fall
                },
                ["ROGUE"] = {
                    ["Assassination"] = 45526, -- The God-Queen's Fury
                    ["Outlaw"] = 46065, -- An Impossible Foe
                    ["Subtlety"] = 44925, -- Closing the Eye
                },
                ["SHAMAN"] = {
                    ["Enhancement"] = 45526, -- The God-Queen's Fury
                    ["Elemental"] = 46065, -- An Impossible Foe
                    ["Restoration"] = 46035, -- End of the Risen Threat
                },
                ["WARLOCK"] = {
                    ["Affliction"] = 46127, -- Thwarting the Twins
                    ["Destruction"] = 45627, -- Feltotem's Fall
                    ["Demonology"] = 45526, -- The God-Queen's Fury
                },
                ["WARRIOR"] = {
                    ["Arms"] = 44925, -- Closing the Eye
                    ["Fury"] = 46065, -- An Impossible Foe
                    ["Protection"] = 45416, -- The Highlord's Return
                },
            }
            GameTooltip:AddLine("Mage Tower Completed", AAM.TooltipHeaderColor())
            for k, v in pairs(ids[char.Class]) do
                GameTooltip:AddDoubleLine(k, AAM.FormatBool(char.MageTower[v]))
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
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
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
            char.MageTower = {}
            for k, v in pairs(quests) do
                char.MageTower[v] = IsQuestFlaggedCompleted(v)
            end
        end,
    },
    ["TimePlayed"] = {
        Label = "Time Played",
        Order = 170,
        Display = true,
        Tooltip = function(char)
            if char.TimePlayed ~= nil then
                GameTooltip:AddLine("Time Played", AAM.TooltipHeaderColor())
                GameTooltip:AddLine(format("Total: %d days %d hrs %d mins %d secs", AAM.FormatTime(char.TimePlayed.Total)))
                GameTooltip:AddLine(format("This Level: %d days %d hrs %d mins %d secs", AAM.FormatTime(char.TimePlayed.Level)))
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.TimePlayed ~= nil then
                return format("%d:%02d:%02d:%02d", AAM.FormatTime(char.TimePlayed.Total))
            end
            return ""
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        EventUpdates = {
            ["TIME_PLAYED_MSG"] = function(sender, ...)
                local total, thisLevel = ...
                local char = CurrentChar()
                char.TimePlayed = {}
                char.TimePlayed.Total = total
                char.TimePlayed.Level = thisLevel
            end
        },
    },
    ["Artifacts"] = {
        Label = "Artifact Levels",
        Order = 100,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Artifact Levels", AAM.TooltipHeaderColor())
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
            return AAM.DefaultColor()
        end,
        Update = function()
            local char = CurrentChar()
            if not char.Artifacts then 
                char.Artifacts = {} 
            end
        end,
        EventUpdates = {
            ["ARTIFACT_UPDATE"] = function()
                local char = CurrentChar()
                if not char.Artifacts then 
                    char.Artifacts = {} 
                end
                local id, _, name, _, power, ranks = C_ArtifactUI.GetArtifactInfo()
                char.Artifacts[id] = {}
                char.Artifacts[id].Name = name
                char.Artifacts[id].Power = power
                char.Artifacts[id].Ranks = ranks
            end
        },
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
            return AAM.DefaultColor()
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
                return AAM.ErrorColor()
            end
            local cur = char.Currencies[1533].CurrentAmount
            if cur > 1000 then
                return AAM.SuccessColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Gear"] = {
        Label = "Gear",
        Order = 21,
        Display = true,
        Tooltip = function(char)
            if char.Gear == nil or char.Gear.Items == nil or char.Gear.AvgItemLevelBags == nil then
                GameTooltip:AddLine("No Gear Data")
                GameTooltip:Show()
            else
                GameTooltip:AddLine(format("Item Level %d (Equipped %d)", char.Gear.AvgItemLevelBags, char.Gear.AvgItemLevelEquipped), AAM.TooltipHeaderColor())
                for k, v in pairs(char.Gear.Items) do
                    GameTooltip:AddDoubleLine(format("|T%s:24|t (%d) %s", v.Texture, v.ItemLevel, v.Name), _G[v.EquipLoc], GetItemQualityColor(v.Rarity))
                end
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Gear.AvgItemLevelBags == nil then
                return "?"
            end
            return format("%.0f / %.0f", char.Gear.AvgItemLevelEquipped, char.Gear.AvgItemLevelBags)
        end,
        Color = function(char)
            if char.Gear.AvgItemLevelBags == nil then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Update = function()
            local slotIDs = {
                1, -- head
                2, -- neck
                3, -- shoulders
                15, -- back
                5, -- chest
                4, -- shirt
                19, -- tabard
                9, -- wrist

                10, -- hands
                6, -- waist
                7, -- legs
                8, -- feet
                11, -- finger 1
                12, -- finger 2
                13, -- trinket 1
                14, -- trinket 2
                16, -- main hand
                17, -- off hand
            }
            local char = CurrentChar()
            char.Gear = {}
            char.Gear.Items = {}
            for _, sid in pairs(slotIDs) do
                local itemLink = GetInventoryItemLink("player", sid)
                if itemLink ~= nil then
                    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
                        itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice  = GetItemInfo(itemLink)
                    local item = {}
                    item.Name = itemName
                    item.Link = itemLink
                    item.Rarity = itemRarity
                    item.ItemLevel = itemLevel
                    item.MinLevel = itemMinLevel
                    item.Type = itemType
                    item.SubType = itemSubType
                    item.StackCount = itemStackCount
                    item.EquipLoc = itemEquipLoc
                    item.Texture = itemTexture
                    item.SellPrice  = itemSellPrice
                    table.insert(char.Gear.Items, item)
                end
            end
            char.Gear.AvgItemLevelBags, char.Gear.AvgItemLevelEquipped = GetAverageItemLevel()
        end,
    },
    ["GuildName"] = {
        Label = "Guild",
        Order = 23,
        Display = true,
        Tooltip = function(char)
            
        end,
        Value = function(char)
            return char.GuildName
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        EventUpdates = {
            ["PLAYER_GUILD_UPDATE"] = function()
                CurrentChar().GuildName = GetGuildInfo("player")
            end,
            ["GUILD_ROSTER_UPDATE"] = function()
                CurrentChar().GuildName = GetGuildInfo("player")
            end,
        },
    },
    ["Champions"] = {
        Label = "Orderhall Champions",
        Order = 22,
        Display = true,
        Tooltip = function(char)
            if char.Followers == nil then
                GameTooltip:AddLine("No Champion Data", AAM.ErrorColor())
                GameTooltip:Show()
            else
                GameTooltip:AddLine("Orderhall Champions", AAM.TooltipHeaderColor())
                for k, v in pairs(char.Followers) do
                    -- get equipment links
                    local n1 = C_Garrison.GetFollowerAbilityLink(v.Equipment[1].ID)
                    local n2 = C_Garrison.GetFollowerAbilityLink(v.Equipment[2].ID)
                    local n3 = C_Garrison.GetFollowerAbilityLink(v.Equipment[3].ID)
                    -- lock slots if the champ quality is too low
                    if v.Quality < 5 then n3 = "|cff9d9d9d[Locked]|r" end
                    if v.Quality < 4 then n2 = "|cff9d9d9d[Locked]|r" end
                    if v.Quality < 3 then n1 = "|cff9d9d9d[Locked]|r" end
                    -- shorten empty slot links
                    if v.Equipment[1].ID == 415 or v.Equipment[1].ID == 855 or v.Equipment[1].ID == 414 then
                        n1 = "|cffff0000[Empty]|r"
                    end
                    if v.Equipment[2].ID == 415 or v.Equipment[2].ID == 855 or v.Equipment[2].ID == 414 then
                        n2 = "|cffff0000[Empty]|r"
                    end
                    if v.Equipment[3].ID == 415 or v.Equipment[3].ID == 855 or v.Equipment[3].ID == 414 then
                        n3 = "|cffff0000[Empty]|r"
                    end
                    -- add lines to the tooltip
                    local qualityColors = {
                        [1] = "ffffffff",
                        [2] = "ffffffff",
                        [3] = "ff1eff00",
                        [4] = "ff0070dd",
                        [5] = "ffa335ee",
                        [6] = "ffe6cc80",
                    }
                    GameTooltip:AddLine(format("|T%s:24|t |c%s%s|r", v.PortraitIconID, qualityColors[v.Quality], v.Name))
                    GameTooltip:AddLine(format("       iLvl %d %s", v.ItemLevel, v.ClassName))
                    GameTooltip:AddLine(format("       %s", n1))
                    GameTooltip:AddLine(format("       %s", n2))
                    GameTooltip:AddLine(format("       %s", n3))
                end
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            return "View Champions"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
            local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
            if followers ~= nil then
                CurrentChar().Followers = {}
                for _, v in pairs(followers) do
                    if not v.isTroop and v.isCollected then
                        local follower = {}
                        follower.ItemLevel = v.iLevel
                        follower.Level = v.Level
                        follower.Quality = v.quality
                        follower.PortraitIconID = v.portraitIconID
                        follower.SoundKitID = v.slotSoundKitID
                        follower.XP = v.xp
                        follower.ClassName = v.className
                        follower.ClassSpec = v.classSpec
                        follower.IsMaxLevel = v.IsMaxLevel
                        follower.Name = v.name
                        follower.GUID = v.followerID
                        follower.GarrisonFollowerID = v.garrFollowerID
                        follower.Equipment = {}
                        follower.Equipment[1] = {}
                        follower.Equipment[1].ID = C_Garrison.GetFollowerTraitAtIndex(follower.GUID, 1)
                        follower.Equipment[2] = {}
                        follower.Equipment[2].ID = C_Garrison.GetFollowerTraitAtIndex(follower.GUID, 2)
                        follower.Equipment[3] = {}
                        follower.Equipment[3].ID = C_Garrison.GetFollowerTraitAtIndex(follower.GUID, 3)
                        table.insert(CurrentChar().Followers, follower)
                    end
                end
            end
        end,
    },
    ["Title"] = {
        Label = "Title",
        Order = 15,
        Display = true,
        Tooltip = function(char)
        end,
        Value = function(char)
            return GetTitleName(char.Title)
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Title = GetCurrentTitle()
        end,
    },
}

function ArwicAltManager.UpdateCharacterData()
    for k, v in pairs(ArwicAltManager.Fields.Character) do
        if v.Update ~= nil then
            v.Update()
        end
    end
end

local function InitFields()
    -- load the config table or set it to defaults
    for k, v in pairs(ArwicAltManager.Fields.Character) do
        -- check if the field exists
        if ArwicAltManagerDB.Config.Fields.Character[k] == nil then
            -- it doesnt so copy defaults to the config
            ArwicAltManagerDB.Config.Fields.Character[k] = {}
            ArwicAltManagerDB.Config.Fields.Character[k].Internal = v.Internal
            ArwicAltManagerDB.Config.Fields.Character[k].Display = v.Display
            ArwicAltManagerDB.Config.Fields.Character[k].Order = tonumber(v.Order)
        else
            -- it does so copy config to the formatter
            v.Internal = ArwicAltManagerDB.Config.Fields.Character[k].Internal
            v.Display = ArwicAltManagerDB.Config.Fields.Character[k].Display
            v.Order = tonumber(ArwicAltManagerDB.Config.Fields.Character[k].Order)
        end
    end
end
local function RegisterEvents()
    local f = CreateFrame("FRAME")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            InitFields()
            ArwicAltManager.UpdateCharacterData()
            RequestTimePlayed()
        end
    end)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    hooksecurefunc("ToggleGameMenu", ArwicAltManager.UpdateCharacterData)
    hooksecurefunc("Logout", ArwicAltManager.UpdateCharacterData)
    hooksecurefunc("Quit", ArwicAltManager.UpdateCharacterData)
end
RegisterEvents()

local function RegisterEventUpdates()
    for k, v in pairs(ArwicAltManager.Fields.Character) do
        if v.EventUpdates ~= nil then
            local ef = CreateFrame("FRAME", "AAM_eventFrame_characterFields_" .. k)
            ef:SetScript("OnEvent", function(self, event, ...)
                v.EventUpdates[event](self, ...)
            end)
            for k, v in pairs(v.EventUpdates) do
                ef:RegisterEvent(k)
            end
        end
    end
end
RegisterEventUpdates()
