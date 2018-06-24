local AAM = ArwicAltManager

function AAM_AddTooltipHeader(char, label)
    local lr, lg, lb = AAM_ClassColor(char.Class)
    GameTooltip:AddDoubleLine(label, format("%s - %s", char.Name, char.Realm), nil, nil, nil, lr, lg, lb)--, rr, rg, rb)
end

function AAM_AddCurrencyLine(char, cID, icon)
    GameTooltip:AddLine(format("%s %s", icon, AAM_FormatInt(char.Currencies[cID].CurrentAmount)), AAM_DefaultColor())
end

function ArwicAltManager.RestoreDefaultFields()
    if ArwicAltManagerDB.Fields == nil then ArwicAltManagerDB.Fields = {} end
    if ArwicAltManagerDB.Fields.Character == nil then ArwicAltManagerDB.Fields.Character = {} end
    local c = ArwicAltManagerDB.Fields.Character
    c["INTERNAL_Currencies"] = {
        Internal = true,
        Display = false,
        Order = 0,
        FuncStr = {
            Update = [[function(char)
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
                char.Currencies = {}
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
            end]],
        }
    }
    c["INTERNAL_Professions"] = {
        Internal = true,
        Display = false,
        Order = 0,
        FuncStr = {
            Update = [[function(char)
                char.Professions = {}
                local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
                if prof1 ~= nil then
                    char.Professions.Primary1 = {}
                    char.Professions.Primary1.Name, 
                    char.Professions.Primary1.Icon, 
                    char.Professions.Primary1.SkillLevel, 
                    char.Professions.Primary1.MaxSkillLevel = GetProfessionInfo(prof1)
                end
                if prof2 ~= nil then
                    char.Professions.Primary2 = {}
                    char.Professions.Primary2.Name, 
                    char.Professions.Primary2.Icon, 
                    char.Professions.Primary2.SkillLevel, 
                    char.Professions.Primary2.MaxSkillLevel = GetProfessionInfo(prof2)
                end
                if archaeology ~= nil then
                    char.Professions.Archaeology = {}
                    char.Professions.Archaeology.Name, 
                    char.Professions.Archaeology.Icon, 
                    char.Professions.Archaeology.SkillLevel, 
                    char.Professions.Archaeology.MaxSkillLevel = GetProfessionInfo(archaeology)
                end
                if fishing ~= nil then
                    char.Professions.Fishing = {}
                    char.Professions.Fishing.Name, 
                    char.Professions.Fishing.Icon, 
                    char.Professions.Fishing.SkillLevel, 
                    char.Professions.Fishing.MaxSkillLevel = GetProfessionInfo(fishing)
                end
                if cooking ~= nil then
                    char.Professions.Cooking = {}
                    char.Professions.Cooking.Name, 
                    char.Professions.Cooking.Icon, 
                    char.Professions.Cooking.SkillLevel, 
                    char.Professions.Cooking.MaxSkillLevel = GetProfessionInfo(cooking)
                end
                if firstAid ~= nil then
                    char.Professions.FirstAid = {}
                    char.Professions.FirstAid.Name, 
                    char.Professions.FirstAid.Icon, 
                    char.Professions.FirstAid.SkillLevel, 
                    char.Professions.FirstAid.MaxSkillLevel = GetProfessionInfo(firstAid)
                end
            end]],
        }
    }
    c["Name"] = {
        Label = "Name",
        Order = 10,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Name")
                GameTooltip:AddLine(format("Level %d %s %s", char.Level, char.Race, AAM_ClassName(char.Class)))
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("|c%s%s", RAID_CLASS_COLORS[char.Class].colorStr, char.Name)
            end]],
            Update = [[function(char)
                char.Name = UnitName("player")
            end]],
        }
    }
    c["Class"] = {
        Label = "Class",
        Order = 20,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Class")
                GameTooltip:AddLine(AAM_ClassName(char.Class), AAM_ClassColor(char.Class))
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("|c%s%s", RAID_CLASS_COLORS[char.Class].colorStr, AAM_ClassName(char.Class))
            end]],
            Update = [[function(char)
                char.Class = select(2, UnitClass("player"))
            end]],
        }
    }
    c["Realm"] = {
        Label = "Realm",
        Order = 40,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Realm")
                GameTooltip:AddLine(char.Realm, AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), char.Realm)
            end]],
            Update = [[function(char)
                char.Realm = GetRealmName()
            end]],
        }
    }
    c["Faction"] = {
        Label = "Faction",
        Order = 30,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Faction")
                GameTooltip:AddLine(char.Faction, AAM_FactionColor(char.Faction))
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s %s", AAM_ColorEscape(AAM_FactionColor(char.Faction)), char.Faction)
            end]],
            Update = [[function(char)
                char.Faction = UnitFactionGroup("player")
            end]],
        }
    }
    c["Race"] = {
        Label = "Race",
        Order = 60,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Race")
                GameTooltip:AddLine(char.Race, AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), char.Race)
            end]],
            Update = [[function(char)
                char.Race = select(2, UnitRace("player"))
            end]],
        }
    }
    c["Gender"] = {
        Label = "Gender",
        Order = 70,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Gender")
                local map = {
                    [1] = "Unknown",
                    [2] = "Male",
                    [3] = "Female",
                }
                GameTooltip:AddLine(map[char.Gender], AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                local map = {
                    [1] = "Unknown",
                    [2] = "Male",
                    [3] = "Female",
                }
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), map[char.Gender])
            end]],
            Update = [[function(char)
                char.Gender = UnitSex("player")
            end]],
        }
    }
    c["Timestamp"] = {
        Label = "Updated",
        Order = 1000,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                local days, hours, minutes, seconds = AAM_FormatTime(time() - char.Timestamp)
                AAM_AddTooltipHeader(char, "Updated")
                GameTooltip:AddLine(format("%d days %d hrs %d mins %d secs", days, hours, minutes, seconds), AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.Timestamp then
                    return "?"
                end
                local dt = time() - char.Timestamp
                local days, hours, minutes, seconds = AAM_FormatTime(dt)
                local color = AAM_ColorEscape(AAM_DefaultColor())
                if days > 0 then
                    return format("%s%d days ago", color, days)
                elseif hours > 0 then
                    return format("%s%d hrs ago", color, hours)
                elseif minutes > 0 then
                    return format("%s%d mins ago", color, minutes)
                else
                    return format("%s%d secs ago", color, seconds)
                end
            end]],
            Update = [[function(char)
                char.Timestamp = time()
            end]],
        }
    }
    c["Money"] = {
        Label = "|T133784:0|t Gold",
        Order = 80,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                -- character
                local charGold = floor(char.Money / 100 / 100)
                local charSilver = (char.Money / 100) % 100
                local charCopper = char.Money % 100
                -- realm
                local realmChars = ArwicAltManagerDB.Realms[char.Realm].Characters
                local realmMoney = 0
                for _, c in pairs(realmChars) do
                    realmMoney = realmMoney + c.Money
                end
                local realmGold = floor(realmMoney / 100 / 100)
                local realmSilver = (realmMoney / 100) % 100
                local realmCopper = realmMoney % 100
                -- alliance realm total
                local realmAlliMoney = 0
                for _, c in pairs(realmChars) do
                    if c.Faction == "Alliance" then
                        realmAlliMoney = realmAlliMoney + c.Money
                    end
                end
                local realmAlliGold = floor(realmAlliMoney / 100 / 100)
                local realmAlliSilver = (realmAlliMoney / 100) % 100
                local realmAlliCopper = realmAlliMoney % 100
                -- horde realm total
                local realmHordeMoney = 0
                for _, c in pairs(realmChars) do
                    if c.Faction == "Horde" then
                        realmHordeMoney = realmHordeMoney + c.Money
                    end
                end
                local realmHordeGold = floor(realmHordeMoney / 100 / 100)
                local realmHordeSilver = (realmHordeMoney / 100) % 100
                local realmHordeCopper = realmHordeMoney % 100
                -- total
                local totalMoney = 0
                for _, realm in pairs(ArwicAltManagerDB.Realms) do
                    for _, c in pairs(realm.Characters) do
                        totalMoney = totalMoney + c.Money
                    end
                end
                local totalGold = floor(totalMoney / 100 / 100)
                local totalSilver = (totalMoney / 100) % 100
                local totalCopper = totalMoney % 100
                -- alliance total
                local totalAlliMoney = 0
                for _, realm in pairs(ArwicAltManagerDB.Realms) do
                    for _, c in pairs(realm.Characters) do
                        if c.Faction == "Alliance" then
                            totalAlliMoney = totalAlliMoney + c.Money
                        end
                    end
                end
                local totalAlliGold = floor(totalAlliMoney / 100 / 100)
                local totalAlliSilver = (totalAlliMoney / 100) % 100
                local totalAlliCopper = totalAlliMoney % 100
                -- horde total
                local totalHordeMoney = 0
                for _, realm in pairs(ArwicAltManagerDB.Realms) do
                    for _, c in pairs(realm.Characters) do
                        if c.Faction == "Horde" then
                            totalHordeMoney = totalHordeMoney + c.Money
                        end
                    end
                end
                local totalHordeGold = floor(totalHordeMoney / 100 / 100)
                local totalHordeSilver = (totalHordeMoney / 100) % 100
                local totalHordeCopper = totalHordeMoney % 100
                AAM_AddTooltipHeader(char, "Gold")
                local r, g, b = AAM_DefaultColor()
                GameTooltip:AddDoubleLine("Character:", 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(charGold), charSilver, charCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddLine(" ")
                GameTooltip:AddDoubleLine(format("%s |cFF0099FFAlliance|r Total:", char.Realm), 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(realmAlliGold), realmAlliSilver, realmAlliCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddDoubleLine(format("%s |cFFD80000Horde|r Total:", char.Realm), 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(realmHordeGold), realmHordeSilver, realmHordeCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddDoubleLine(format("%s Total:", char.Realm), 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(realmGold), realmSilver, realmCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddLine(" ")
                    GameTooltip:AddDoubleLine("Account |cFF0099FFAlliance|r Total:", 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(totalAlliGold), totalAlliSilver, totalAlliCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddDoubleLine("Account |cFFD80000Horde|r Total:", 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(totalHordeGold), totalHordeSilver, totalHordeCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:AddDoubleLine("Account Total:", 
                    format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM_FormatInt(totalGold), totalSilver, totalCopper), 
                    r, g, b, AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                local g = floor(char.Money / 100 / 100)
                local str = format("%s%s|cFFefca00g|r", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatInt(g))
                return str
            end]],
            Update = [[function(char)
                char.Money = GetMoney()
            end]],
        }
    }
    c["ClassCampaign"] = {
        Label = "Class Campaign",
        Order = 110,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Class Campaign")
                if not char.ClassCampaign then
                    GameTooltip:AddLine(AAM_FormatBool(char.ClassCampaign), AAM_ErrorColor())
                else
                    GameTooltip:AddLine(AAM_FormatBool(char.ClassCampaign), AAM_DefaultColor())
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.ClassCampaign then
                    return format("%s%s", AAM_ColorEscape(AAM_ErrorColor()), AAM_FormatBool(char.ClassCampaign))
                else
                    return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatBool(char.ClassCampaign))
                end
            end]],
            Update = [[function(char)
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
                char.ClassCampaign = IsQuestFlaggedCompleted(quests[class])
            end]],
        }
    }
    c["ClassMount"] = {
        Label = "Class Mount",
        Order = 120,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Class Mount")
                if not char.ClassMount then
                    GameTooltip:AddLine(AAM_FormatBool(char.ClassMount), AAM_ErrorColor())
                else
                    GameTooltip:AddLine(AAM_FormatBool(char.ClassMount), AAM_DefaultColor())
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.ClassMount then
                    return format("%s%s", AAM_ColorEscape(AAM_ErrorColor()), AAM_FormatBool(char.ClassMount))
                else
                    return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatBool(char.ClassMount))
                end
            end]],
            Update = [[function(char)
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
                char.ClassMount = IsQuestFlaggedCompleted(quests[class])
            end]],
        }
    }
    c["BreachingTheTomb"] = {
        Label = "Breaching The Tomb",
        Order = 121,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.BreachingTheTomb and type(char.BreachingTheTomb) ~= "boolean" then
                    GameTooltip:SetHyperlink(char.BreachingTheTomb.Link)
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                local color = AAM_ErrorColor()
                local val = "?"
                if type(char.BreachingTheTomb) == "boolean" then
                    val = AAM_FormatBool(char.BreachingTheTomb)
                    if char.BreachingTheTomb == true then
                        color = AAM_DefaultColor()
                    end
                else
                    val = AAM_FormatBool(char.BreachingTheTomb.Completed)
                    if char.BreachingTheTomb.Completed == true then 
                        color = AAM_DefaultColor() 
                    end
                end
                return format("%s%s", AAM_ColorEscape(color), val)
            end]],
            Update = [[function(char)
                char.BreachingTheTomb = {}
                char.BreachingTheTomb.Completed = select(13, GetAchievementInfo(11546))
                char.BreachingTheTomb.Link = GetAchievementLink(11546)
            end]],
        }
    }
    c["Level"] = {
        Label = "Level",
        Order = 50,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Level")
                GameTooltip:AddLine(format("Level %d", char.Level), AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), char.Level)
            end]],
            Update = [[function(char)
                char.Level = UnitLevel("player")
            end]],
        }
    }
    c["MountSpeed"] = {
        Label = "Riding",
        Order = 160,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Riding")
                GameTooltip:AddLine(format("%s%%", char.MountSpeed), AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s%s%%", AAM_ColorEscape(AAM_DefaultColor()), char.MountSpeed)
            end]],
            Update = [[function(char)
                local spellIDs = { 
                    [60] = 33388, 
                    [100] = 33391, 
                    [150] = 34090, 
                    [280] = 34091, 
                    [310] = 90265 
                }
                char.MountSpeed = 0
                for speed, id in pairs(spellIDs) do
                    if IsSpellKnown(id) then
                        if char.MountSpeed < speed then
                            char.MountSpeed = speed
                        end
                    end
                end
            end]],
        }
    }
    c["OrderHallUpgrades"] = {
        Label = "All Order Hall Upgrades",
        Order = 130,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "All Order Hall Upgrades")
                if not char.OrderHallUpgrades then
                    GameTooltip:AddLine(AAM_FormatBool(char.OrderHallUpgrades), AAM_ErrorColor())
                else
                    GameTooltip:AddLine(AAM_FormatBool(char.OrderHallUpgrades), AAM_DefaultColor())
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.OrderHallUpgrades then
                    return format("%s%s", AAM_ColorEscape(AAM_ErrorColor()), AAM_FormatBool(char.OrderHallUpgrades))
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatBool(char.OrderHallUpgrades))
            end]],
            Update = [[function(char)
                char.OrderHallUpgrades = select(13, GetAchievementInfo(11223))
            end]],
        }
    }
    c["BalanceOfPower"] = {
        Label = "Balance of Power",
        Order = 150,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Balance of Power")
                if not char.BalanceOfPower then
                    GameTooltip:AddLine(AAM_FormatBool(char.BalanceOfPower), AAM_ErrorColor())
                else
                    GameTooltip:AddLine(AAM_FormatBool(char.BalanceOfPower), AAM_DefaultColor())
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.BalanceOfPower then
                    return format("%s%s", AAM_ColorEscape(AAM_ErrorColor()), AAM_FormatBool(char.BalanceOfPower))
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatBool(char.BalanceOfPower))
            end]],
            Update = [[function(char)
                char.BalanceOfPower = select(13, GetAchievementInfo(10459))
            end]],
        }
    }
    c["KeystoneMaster"] = {
        Label = "Keystone Master",
        Order = 135,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Keystone Master")
                if not char.KeystoneMaster then
                    GameTooltip:AddLine(AAM_FormatBool(char.KeystoneMaster), AAM_ErrorColor())
                else
                    GameTooltip:AddLine(AAM_FormatBool(char.KeystoneMaster), AAM_DefaultColor())
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                if not char.KeystoneMaster then
                    return format("%s%s", AAM_ColorEscape(AAM_ErrorColor()), AAM_FormatBool(char.KeystoneMaster))
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatBool(char.KeystoneMaster))
            end]],
            Update = [[function(char)
                char.KeystoneMaster = select(13, GetAchievementInfo(11162))
            end]],
        }
    }
    c["MageTowerPrereq"] = {
        Label = "Mage Tower Unlocked",
        Order = 139,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
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
                AAM_AddTooltipHeader(char, "Mage Tower Unlocked")
                for k, v in pairs(ids[char.Class]) do
                    local r, g, b = AAM_DefaultColor()
                    local unlocked = char.MageTowerPrereq[v]
                    if not unlocked then
                        GameTooltip:AddDoubleLine(k, AAM_FormatBool(unlocked), r, g, b, AAM_ErrorColor())
                    else
                        GameTooltip:AddDoubleLine(k, AAM_FormatBool(unlocked), r, g, b, AAM_DefaultColor())
                    end
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
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
                    if count ~= maxCount then
                        return format("%s%d/%d", AAM_ColorEscape(AAM_ErrorColor()), count, maxCount)
                    else
                        return format("%s%d/%d", AAM_ColorEscape(AAM_DefaultColor()), count, maxCount)
                    end
                end
                return ""
            end]],
            Update = [[function(char)
                local quests = {
                    45864,
                    45842,
                    45861,
                    45862,
                    45865,
                    45866,
                    45863,
                }
                char.MageTowerPrereq = {}
                for k, v in pairs(quests) do
                    char.MageTowerPrereq[v] = IsQuestFlaggedCompleted(v)
                end
            end]],
        }
    }
    c["MageTower"] = {
        Label = "Mage Tower Completed",
        Order = 140,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
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
                AAM_AddTooltipHeader(char, "Mage Tower Completed")
                for k, v in pairs(ids[char.Class]) do
                    local r, g, b = AAM_DefaultColor()
                    local completed = char.MageTower[v]
                    if not completed then
                        GameTooltip:AddDoubleLine(k, AAM_FormatBool(completed), r, g, b, AAM_ErrorColor())
                    else
                        GameTooltip:AddDoubleLine(k, AAM_FormatBool(completed), r, g, b, AAM_DefaultColor())
                    end
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
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
                    return format("%s%d/%d", AAM_ColorEscape(AAM_ErrorColor()), count, maxCount)
                else
                    return format("%s%d/%d", AAM_ColorEscape(AAM_DefaultColor()), count, maxCount)
                end
            end]],
            Update = [[function(char)
                local quests = {
                    46065, -- An Impossible Foe
                    44925, -- Closing the Eye
                    46035, -- End of the Risen Threat
                    45627, -- Feltotem's Fall
                    45526, -- The God-Queen's Fury
                    45416, -- The Highlord's Return
                    46127, -- Thwarting the Twins
                }
                char.MageTower = {}
                for k, v in pairs(quests) do
                    char.MageTower[v] = IsQuestFlaggedCompleted(v)
                end
            end]],
        }
    }
    c["TimePlayed"] = {
        Label = "Time Played",
        Order = 170,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.TimePlayed ~= nil then
                    AAM_AddTooltipHeader(char, "Time Played")
                    local r, g, b = AAM_DefaultColor()
                    GameTooltip:AddDoubleLine("Total:", format("%d days %d hrs %d mins %d secs", AAM_FormatTime(char.TimePlayed.Total)), r, g, b, AAM_DefaultColor())
                    GameTooltip:AddDoubleLine(format("Level %d:", char.Level), format("%d days %d hrs %d mins %d secs", AAM_FormatTime(char.TimePlayed.Level)), r, g, b, AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.TimePlayed ~= nil then
                    return format("%s%d:%02d:%02d:%02d", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatTime(char.TimePlayed.Total))
                end
                return ""
            end]],
        },
        -- TODO support user defined event updates
        EventUpdates = {
            ["TIME_PLAYED_MSG"] = function(sender, ...)
                local total, thisLevel = ...
                char.TimePlayed = {}
                char.TimePlayed.Total = total
                char.TimePlayed.Level = thisLevel
            end
        },
    }
    c["Artifacts"] = {
        Label = "Artifact Levels",
        Order = 100,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Artifact Levels")
                for k, v in pairs(char.Artifacts) do
                    --if k ~= 133755 then -- dont show fishing artifact
                        if v.Name == nil then v.Name = "UNKNOWN" end
                        local r, g, b = AAM_DefaultColor()
                        GameTooltip:AddDoubleLine(format("%s", v.Name), format("%d", v.Ranks), r, g, b, AAM_DefaultColor())
                    --end
                end
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                local str = ""
                for k, v in pairs(char.Artifacts) do
                    if k ~= 133755 then -- ignore fishing artifact
                        str = format("%s, %d", str, v.Ranks) 
                    end
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), str:sub(3)) -- remove the first 2 characters ", "
            end]],
            Update = [[function(char)
                if not char.Artifacts then 
                    char.Artifacts = {} 
                end
            end]],
        },
        -- TODO support user defined event updates
        EventUpdates = {
            ["ARTIFACT_UPDATE"] = function()
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
    }
    c["OrderHallResouces"] = {
        Label = "|T1397630:0|t Order Resouces",
        Order = 90,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Currencies ~= nil then
                    AAM_AddTooltipHeader(char, "Order Resouces")
                    AAM_AddCurrencyLine(char, 1220, "|T1397630:0|t")
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if not char.Currencies then
                    return ""
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatInt(char.Currencies[1220].CurrentAmount))
            end]],
        }
    }
    c["WakeningEssence"] = {
        Label = "|T236521:0|t Wakening Essence",
        Order = 91,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Currencies ~= nil then
                    AAM_AddTooltipHeader(char, "Wakening Essence")
                    AAM_AddCurrencyLine(char, 1533, "|T236521:0|t")
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if not char.Currencies or not char.Currencies[1533] then
                    return ""
                end
                local ammount = char.Currencies[1533].CurrentAmount
                if ammount > 1000 then
                    return format("%s%s", AAM_ColorEscape(AAM_SuccessColor()), AAM_FormatInt(ammount))
                else
                    return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), AAM_FormatInt(ammount))
                end
            end]],
        }
    }
    c["Gear"] = {
        Label = "Gear",
        Order = 21,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Gear ~= nil and char.Gear.Items ~= nil and char.Gear.AvgItemLevelBags ~= nil then
                    AAM_AddTooltipHeader(char, format("Item Level %d (Equipped %d)", char.Gear.AvgItemLevelBags, char.Gear.AvgItemLevelEquipped))
                    for k, v in pairs(char.Gear.Items) do
                        if v.Texture ~= nil and v.ItemLevel ~= nil and v.Name ~= nil then
                            local r, g, b = GetItemQualityColor(v.Rarity)
                            GameTooltip:AddDoubleLine(format("|T%s:24|t (%d) %s", v.Texture, v.ItemLevel, v.Name), _G[v.EquipLoc], r, g, b, AAM_DefaultColor())
                        else
                            GameTooltip:AddLine("Unknown", AAM_ErrorColor())
                        end
                    end
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Gear.AvgItemLevelBags == nil then
                    return "?"
                end
                return format("%s%.0f / %.0f", AAM_ColorEscape(AAM_DefaultColor()), char.Gear.AvgItemLevelEquipped, char.Gear.AvgItemLevelBags)
            end]],
            Update = [[function(char)
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
            end]],
        }
    }
    c["GuildName"] = {
        Label = "Guild",
        Order = 23,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                AAM_AddTooltipHeader(char, "Guild")
                GameTooltip:AddLine(char.GuildName, AAM_DefaultColor())
                GameTooltip:Show()
            end]],
            Value = [[function(char)
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), char.GuildName)
            end]],
        },
        -- TODO
        EventUpdates = {
            ["PLAYER_GUILD_UPDATE"] = function()
                char.GuildName = GetGuildInfo("player")
            end,
            ["GUILD_ROSTER_UPDATE"] = function()
                char.GuildName = GetGuildInfo("player")
            end,
        },
    }
    c["Champions"] = {
        Label = "Orderhall Champions",
        Order = 22,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Followers ~= nil then
                    AAM_AddTooltipHeader(char, "Orderhall Champions")
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
            end]],
            Value = [[function(char)
                return format("%sView Champions", AAM_ColorEscape(AAM_DefaultColor()))
            end]],
            Update = [[function(char)
                local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
                if followers ~= nil then
                    char.Followers = {}
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
                            table.insert(char.Followers, follower)
                        end
                    end
                end
            end]],
        }
    }
    c["Title"] = {
        Label = "Title",
        Order = 15,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Title ~= nil then
                    AAM_AddTooltipHeader(char, "Title")
                    GameTooltip:AddLine(GetTitleName(char.Title), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Title == nil then
                    return "?"
                end
                return format("%s%s", AAM_ColorEscape(AAM_DefaultColor()), GetTitleName(char.Title))
            end]],
            Update = [[function(char)
                char.Title = GetCurrentTitle()
            end]],
        }
    }
    c["Prof_Primary1"] = {
        Label = "Profession 1",
        Order = 101,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Professions ~= nil and char.Professions.Primary1 ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.Primary1.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Primary1.Icon, char.Professions.Primary1.SkillLevel, char.Professions.Primary1.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.Primary1 ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.Primary1.Icon, char.Professions.Primary1.SkillLevel, char.Professions.Primary1.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }   
    c["Prof_Primary2"] = {
        Label = "Profession 2",
        Order = 102,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Professions ~= nil and char.Professions.Primary2 ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.Primary2.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Primary2.Icon, char.Professions.Primary2.SkillLevel, char.Professions.Primary2.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.Primary2 ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.Primary2.Icon, char.Professions.Primary2.SkillLevel, char.Professions.Primary2.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }
    c["Prof_Archaeology"] = {
        Label = "Archaeology",
        Order = 103,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Professions ~= nil and char.Professions.Archaeology ~= nil and char.Professions.Archaeology.Icon ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.Archaeology.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Archaeology.Icon, char.Professions.Archaeology.SkillLevel, char.Professions.Archaeology.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.Archaeology ~= nil and char.Professions.Archaeology.Icon ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.Archaeology.Icon, char.Professions.Archaeology.SkillLevel, char.Professions.Archaeology.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }
    c["Prof_Fishing"] = {
        Label = "Fishing",
        Order = 103,
        Display = true,
        FuncStr = {
            [[Tooltip = function(char)
                if char.Professions ~= nil and char.Professions.Fishing ~= nil and char.Professions.Fishing.Icon ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.Fishing.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Fishing.Icon, char.Professions.Fishing.SkillLevel, char.Professions.Fishing.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.Fishing ~= nil and char.Professions.Fishing.Icon ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.Fishing.Icon, char.Professions.Fishing.SkillLevel, char.Professions.Fishing.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }
    c["Prof_Cooking"] = {
        Label = "Cooking",
        Order = 103,
        Display = true,
        FuncStr = {
            [[Tooltip = function(char)
                if char.Professions ~= nil and char.Professions.Cooking ~= nil and char.Professions.Cooking.Icon ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.Cooking.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Cooking.Icon, char.Professions.Cooking.SkillLevel, char.Professions.Cooking.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.Cooking ~= nil and char.Professions.Cooking.Icon ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.Cooking.Icon, char.Professions.Cooking.SkillLevel, char.Professions.Cooking.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }
    c["Prof_FirstAid"] = {
        Label = "First Aid",
        Order = 103,
        Display = true,
        FuncStr = {
            [[Tooltip = function(char)
                if char.Professions ~= nil and char.Professions.FirstAid ~= nil and char.Professions.FirstAid.Icon ~= nil then
                    AAM_AddTooltipHeader(char, char.Professions.FirstAid.Name)
                    GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.FirstAid.Icon, char.Professions.FirstAid.SkillLevel, char.Professions.FirstAid.MaxSkillLevel), AAM_DefaultColor())
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Professions ~= nil and char.Professions.FirstAid ~= nil and char.Professions.FirstAid.Icon ~= nil then
                    return format("%s|T%s:0|t %d/%d", AAM_ColorEscape(AAM_DefaultColor()), char.Professions.FirstAid.Icon, char.Professions.FirstAid.SkillLevel, char.Professions.FirstAid.MaxSkillLevel)
                end
                return "?"
            end]],
        }
    }
    c["Honor"] = {
        Label = "Honor",
        Order = 95,
        Display = true,
        FuncStr = {
            Tooltip = [[function(char)
                if char.Honor ~= nil then
                    local r, g, b = AAM_DefaultColor()
                    AAM_AddTooltipHeader(char, "Honor")
                    GameTooltip:AddDoubleLine("Points", format("%d/%d", char.Honor.Points, char.Honor.PointsMax), r, g, b, r, g, b)
                    GameTooltip:AddDoubleLine("Level", format("%d/50", char.Honor.Level), r, g, b, r, g, b)
                    GameTooltip:AddDoubleLine("Prestige", format("%d/25", char.Honor.Prestige), r, g, b, r, g, b)
                    GameTooltip:Show()
                end
            end]],
            Value = [[function(char)
                if char.Honor ~= nil then
                    return format("%s%d (%d)", AAM_ColorEscape(AAM_DefaultColor()), char.Honor.Level, char.Honor.Prestige)
                end
                return "?"
            end]],
            Update = [[function(char)
                local prestigeAchLevel = {
                    [10991] = 1,
                    [10992] = 2,
                    [10993] = 3,
                    [10995] = 4,
                    [11468] = 5,
                    [11469] = 6,
                    [11470] = 7,
                    [11471] = 8,
                    [11472] = 9,
                    [11685] = 10,
                    [11686] = 11,
                    [11687] = 12,
                    [11688] = 13,
                    [11689] = 14,
                    [11690] = 15,
                    [11691] = 16,
                    [11692] = 17,
                    [11693] = 18,
                    [11694] = 19,
                    [12108] = 20,
                    [12109] = 21,
                    [12180] = 22,
                    [12181] = 23,
                    [12182] = 24,
                    [12183] = 25,
                    [12183] = 26,
                    [12217] = 27,
                    [12218] = 28,
                    [12219] = 29,
                }
                char.Honor = {}
                char.Honor.Level = UnitHonorLevel("player")
                char.Honor.Points = UnitHonor("player")
                char.Honor.PointsMax = UnitHonorMax("player")
                char.Honor.Prestige = 0
                for achID, pLvl in pairs(prestigeAchLevel) do
                    if char.Honor.Prestige < pLvl and select(13, GetAchievementInfo(achID)) then
                        char.Honor.Prestige = pLvl
                    end
                end
            end]],
        }
    }
end

function ArwicAltManager.UpdateCharacterData()
    for k, v in pairs(ArwicAltManagerDB.Fields.Character) do
        if v.Update ~= nil and v.FuncStr ~= nil then
            v.Update()(ArwicAltManagerDB.Realms[GetRealmName()].Characters[UnitName("player")])
        end
    end
end

local function RegisterEventUpdates()
    for k, v in pairs(ArwicAltManagerDB.Fields.Character) do
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

local function RegisterEvents()
    local f = CreateFrame("FRAME")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            --InitFields()
            RegisterEventUpdates()
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
