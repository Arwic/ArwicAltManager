local AAM = ArwicAltManager

local function CurrentChar()
    return ArwicAltManagerDB.Realms[GetRealmName()].Characters[UnitName("player")]
end

local function AddTooltipHeader(char, label)
    local lr, lg, lb = AAM.ClassColor(char.Class)
    --local rr, rg, rb = AAM.TooltipHeaderColor()
    GameTooltip:AddDoubleLine(label, format("%s - %s", char.Name, char.Realm), nil, nil, nil, lr, lg, lb)--, rr, rg, rb)
end

local function AddCurrencyLine(char, cID, icon)
	if char.Currencies[cID] ~= nil then
		GameTooltip:AddLine(format("%s %s", icon, AAM.FormatInt(char.Currencies[cID].CurrentAmount)), AAM.DefaultColor())
	end
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
                392, -- Honor Points
                393, -- Fossil Archaeology Fragment
                394, -- Night Elf Archaeology Fragment
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
                1379, -- Trial of Style Token
                1767, -- Stygia
                1813, -- Reservoir Anima
                1822, -- Renown
                1828, -- Soul Ash
            }
            local char = CurrentChar()
            char.Currencies = {}
            for _, cid in pairs(curIDs) do
                if not char.Currencies[cid] then 
                    char.Currencies[cid] = {} 
					char.Currencies[cid].IsDiscovered = false
					char.Currencies[cid].CurrentAmount = 0
					char.Currencies[cid].Name = ""
                end
                local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(cid)
				if currencyInfo ~= nil then
					char.Currencies[cid].Name = currencyInfo.name
					char.Currencies[cid].CurrentAmount = currencyInfo.quantity
					char.Currencies[cid].EarnedThisWeek = currencyInfo.quantityEarnedThisWeek
					char.Currencies[cid].WeeklyMax = currencyInfo.maxWeeklyQuantity
					char.Currencies[cid].TotalMax = currencyInfo.maxQuantity
					char.Currencies[cid].IsDiscovered = currencyInfo.isDiscovered
				end
            end
        end,
    },
    ["INTERNAL_Professions"] = {
        Internal = true,
        Display = false,
        Order = 0,
        Update = function()
            local char = CurrentChar()
            char.Professions = {}
            local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
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
        end,
    },
    ["Name"] = {
        Label = "Name",
        Order = 10,
        Display = true,
        Tooltip = function(char)
            AddTooltipHeader(char, "Name")
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
            AddTooltipHeader(char, "Class")
            GameTooltip:AddLine(AAM.ClassName(char.Class), AAM.ClassColor(char.Class))
            GameTooltip:Show()
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
            AddTooltipHeader(char, "Realm")
            GameTooltip:AddLine(char.Realm, AAM.DefaultColor())
            GameTooltip:Show()
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
            AddTooltipHeader(char, "Faction")
            GameTooltip:AddLine(char.Faction, AAM.FactionColor(char.Faction))
            GameTooltip:Show()
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
        Tooltip = function(char)
            AddTooltipHeader(char, "Race")
            GameTooltip:AddLine(char.Race, AAM.DefaultColor())
            GameTooltip:Show()
        end,
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
        Tooltip = function(char)
            AddTooltipHeader(char, "Gender")
            local map = {
                [1] = "Unknown",
                [2] = "Male",
                [3] = "Female",
            }
            GameTooltip:AddLine(map[char.Gender], AAM.DefaultColor())
            GameTooltip:Show()
        end,
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
            AddTooltipHeader(char, "Updated")
            GameTooltip:AddLine(format("%d days %d hrs %d mins %d secs", days, hours, minutes, seconds), AAM.DefaultColor())
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
            AddTooltipHeader(char, "Gold")
            local r, g, b = AAM.DefaultColor()
            GameTooltip:AddDoubleLine("Character:", 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(charGold), charSilver, charCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine(format("%s |cFF0099FFAlliance|r Total:", char.Realm), 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(realmAlliGold), realmAlliSilver, realmAlliCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddDoubleLine(format("%s |cFFD80000Horde|r Total:", char.Realm), 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(realmHordeGold), realmHordeSilver, realmHordeCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddDoubleLine(format("%s Total:", char.Realm), 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(realmGold), realmSilver, realmCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddLine(" ")
                GameTooltip:AddDoubleLine("Account |cFF0099FFAlliance|r Total:", 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(totalAlliGold), totalAlliSilver, totalAlliCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddDoubleLine("Account |cFFD80000Horde|r Total:", 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(totalHordeGold), totalHordeSilver, totalHordeCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:AddDoubleLine("Account Total:", 
                format("%s|cFFefca00g|r %d|cFFcdcdd6s|r %d|cFFe2a05fc|r", AAM.FormatInt(totalGold), totalSilver, totalCopper), 
                r, g, b, AAM.DefaultColor())
            GameTooltip:Show()
        end,
        Value = function(char)
            local g = floor(char.Money / 100 / 100)
            local str = format("%s|cFFefca00g|r", AAM.FormatInt(g))
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
        Tooltip = function(char)
            AddTooltipHeader(char, "Class Campaign")
            if not char.ClassCampaign then
                GameTooltip:AddLine(AAM.FormatBool(char.ClassCampaign), AAM.ErrorColor())
            else
                GameTooltip:AddLine(AAM.FormatBool(char.ClassCampaign), AAM.DefaultColor())
            end
            GameTooltip:Show()
        end,
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
            CurrentChar().ClassCampaign = C_QuestLog.IsQuestFlaggedCompleted(quests[class])
        end,
    },
    ["ClassMount"] = {
        Label = "Class Mount",
        Order = 120,
        Display = true,
        Tooltip = function(char)
            AddTooltipHeader(char, "Class Mount")
            if not char.ClassMount then
                GameTooltip:AddLine(AAM.FormatBool(char.ClassMount), AAM.ErrorColor())
            else
                GameTooltip:AddLine(AAM.FormatBool(char.ClassMount), AAM.DefaultColor())
            end
            GameTooltip:Show()
        end,
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
            CurrentChar().ClassMount = C_QuestLog.IsQuestFlaggedCompleted(quests[class])
        end,
    },
    ["Level"] = {
        Label = "Level",
        Order = 50,
        Display = true,
        Tooltip = function(char)
            AddTooltipHeader(char, "Level")
            GameTooltip:AddLine(format("Level %d", char.Level), AAM.DefaultColor())
            GameTooltip:Show()
        end,
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
        Tooltip = function(char)
            AddTooltipHeader(char, "Riding")
            GameTooltip:AddLine(format("%s%%", char.MountSpeed), AAM.DefaultColor())
            GameTooltip:Show()
        end,
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
    ["KeystoneMaster"] = {
        Label = "Keystone Master",
        Order = 135,
        Display = true,
        Tooltip = function(char)
            AddTooltipHeader(char, "Keystone Master")
            if not char.KeystoneMaster then
                GameTooltip:AddLine(AAM.FormatBool(char.KeystoneMaster), AAM.ErrorColor())
            else
                GameTooltip:AddLine(AAM.FormatBool(char.KeystoneMaster), AAM.DefaultColor())
            end
            GameTooltip:Show()
        end,
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
    ["TimePlayed"] = {
        Label = "Time Played",
        Order = 170,
        Display = true,
        Tooltip = function(char)
            if char.TimePlayed ~= nil then
                AddTooltipHeader(char, "Time Played")
                GameTooltip:AddLine(format("Total: %d days %d hrs %d mins %d secs", AAM.FormatTime(char.TimePlayed.Total)), AAM.DefaultColor())
                GameTooltip:AddLine(format("This Level: %d days %d hrs %d mins %d secs", AAM.FormatTime(char.TimePlayed.Level)), AAM.DefaultColor())
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
    ["Gear"] = {
        Label = "Gear",
        Order = 21,
        Display = true,
        Tooltip = function(char)
            if char.Gear ~= nil and char.Gear.Items ~= nil and char.Gear.AvgItemLevelBags ~= nil then
                AddTooltipHeader(char, format("Item Level %d (Equipped %d)", char.Gear.AvgItemLevelBags, char.Gear.AvgItemLevelEquipped))
                for k, v in pairs(char.Gear.Items) do
                    if v.Texture ~= nil and v.ItemLevel ~= nil and v.Name ~= nil then
                        local r, g, b = GetItemQualityColor(v.Rarity)
                        GameTooltip:AddDoubleLine(format("|T%s:24|t (%d) %s", v.Texture, v.ItemLevel, v.Name), _G[v.EquipLoc], r, g, b, AAM.DefaultColor())
                    else
                        GameTooltip:AddLine("Unknown", AAM.ErrorColor())
                    end
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
            AddTooltipHeader(char, "Guild")
            GameTooltip:AddLine(char.GuildName, AAM.DefaultColor())
            GameTooltip:Show()
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
    ["Title"] = {
        Label = "Title",
        Order = 15,
        Display = true,
        Tooltip = function(char)
            if char.Title ~= nil then
                AddTooltipHeader(char, "Title")
                GameTooltip:AddLine(GetTitleName(char.Title), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Title == nil then
                return "?"
            end
            return GetTitleName(char.Title)
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
            CurrentChar().Title = GetCurrentTitle()
        end,
    },
    ["Prof_Primary1"] = {
        Label = "Profession 1",
        Order = 101,
        Display = true,
        Tooltip = function(char)
            if char.Professions ~= nil and char.Professions.Primary1 ~= nil then
                AddTooltipHeader(char, char.Professions.Primary1.Name)
                GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Primary1.Icon, char.Professions.Primary1.SkillLevel, char.Professions.Primary1.MaxSkillLevel), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Professions ~= nil and char.Professions.Primary1 ~= nil then
                return format("|T%s:0|t %d/%d", char.Professions.Primary1.Icon, char.Professions.Primary1.SkillLevel, char.Professions.Primary1.MaxSkillLevel)
            end
            return "?"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
        end,
    },
    ["Prof_Primary2"] = {
        Label = "Profession 2",
        Order = 102,
        Display = true,
        Tooltip = function(char)
            if char.Professions ~= nil and char.Professions.Primary2 ~= nil then
                AddTooltipHeader(char, char.Professions.Primary2.Name)
                GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Primary2.Icon, char.Professions.Primary2.SkillLevel, char.Professions.Primary2.MaxSkillLevel), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Professions ~= nil and char.Professions.Primary2 ~= nil then
                return format("|T%s:0|t %d/%d", char.Professions.Primary2.Icon, char.Professions.Primary2.SkillLevel, char.Professions.Primary2.MaxSkillLevel)
            end
            return "?"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
        end,
    },
    ["Prof_Archaeology"] = {
        Label = "Archaeology",
        Order = 103,
        Display = true,
        Tooltip = function(char)
            if char.Professions ~= nil and char.Professions.Archaeology ~= nil and char.Professions.Archaeology.Icon ~= nil then
                AddTooltipHeader(char, char.Professions.Archaeology.Name)
                GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Archaeology.Icon, char.Professions.Archaeology.SkillLevel, char.Professions.Archaeology.MaxSkillLevel), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Professions ~= nil and char.Professions.Archaeology ~= nil and char.Professions.Archaeology.Icon ~= nil then
                return format("|T%s:0|t %d/%d", char.Professions.Archaeology.Icon, char.Professions.Archaeology.SkillLevel, char.Professions.Archaeology.MaxSkillLevel)
            end
            return "?"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
        end,
    },
    ["Prof_Fishing"] = {
        Label = "Fishing",
        Order = 103,
        Display = true,
        Tooltip = function(char)
            if char.Professions ~= nil and char.Professions.Fishing ~= nil and char.Professions.Fishing.Icon ~= nil then
                AddTooltipHeader(char, char.Professions.Fishing.Name)
                GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Fishing.Icon, char.Professions.Fishing.SkillLevel, char.Professions.Fishing.MaxSkillLevel), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Professions ~= nil and char.Professions.Fishing ~= nil and char.Professions.Fishing.Icon ~= nil then
                return format("|T%s:0|t %d/%d", char.Professions.Fishing.Icon, char.Professions.Fishing.SkillLevel, char.Professions.Fishing.MaxSkillLevel)
            end
            return "?"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
        end,
    },
    ["Prof_Cooking"] = {
        Label = "Cooking",
        Order = 103,
        Display = true,
        Tooltip = function(char)
            if char.Professions ~= nil and char.Professions.Cooking ~= nil and char.Professions.Cooking.Icon ~= nil then
                AddTooltipHeader(char, char.Professions.Cooking.Name)
                GameTooltip:AddLine(format("|T%s:0|t %d/%d", char.Professions.Cooking.Icon, char.Professions.Cooking.SkillLevel, char.Professions.Cooking.MaxSkillLevel), AAM.DefaultColor())
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if char.Professions ~= nil and char.Professions.Cooking ~= nil and char.Professions.Cooking.Icon ~= nil then
                return format("|T%s:0|t %d/%d", char.Professions.Cooking.Icon, char.Professions.Cooking.SkillLevel, char.Professions.Cooking.MaxSkillLevel)
            end
            return "?"
        end,
        Color = function(char)
            return AAM.DefaultColor()
        end,
        Update = function()
        end,
    },
    ["Renown"] = {
        Label = "|T3726261:0|t Renown",
        Order = 91,
        Display = true,
        Tooltip = function(char)
            if char.Currencies ~= nil then
                AddTooltipHeader(char, "Renown")
                AddCurrencyLine(char, 1822, "|T3726261:0|t")
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if not char.Currencies or not char.Currencies[1822] or not char.Currencies[1822].CurrentAmount then
                return ""
            end
            return AAM.FormatInt(char.Currencies[1822].CurrentAmount)
        end,
        Color = function(char)
            if not char.Currencies or not char.Currencies[1822] then
                return AAM.ErrorColor()
            end
            local cur = char.Currencies[1822].CurrentAmount
            if cur == 40 then
                return AAM.SuccessColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["SoulAsh"] = {
        Label = "|T3743738:0|t soul ash",
        Order = 91,
        Display = true,
        Tooltip = function(char)
            if char.Currencies ~= nil then
                AddTooltipHeader(char, "soul ash")
                AddCurrencyLine(char, 1828, "|T3743738:0|t")
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if not char.Currencies or not char.Currencies[1828] or not char.Currencies[1828].CurrentAmount then
                return ""
            end
            return AAM.FormatInt(char.Currencies[1828].CurrentAmount)
        end,
        Color = function(char)
            if not char.Currencies or not char.Currencies[1828] then
                return AAM.ErrorColor()
            end
            local cur = char.Currencies[1828].CurrentAmount
            if cur == char.Currencies[1828].WeeklyMax then
                return AAM.SuccessColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Stygia"] = {
        Label = "|T3743739:0|t Stygia",
        Order = 91,
        Display = true,
        Tooltip = function(char)
            if char.Currencies ~= nil then
                AddTooltipHeader(char, "stygia")
                AddCurrencyLine(char, 1767, "|T3743739:0|t")
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if not char.Currencies or not char.Currencies[1767] or not char.Currencies[1767].CurrentAmount then
                return ""
            end
            return AAM.FormatInt(char.Currencies[1767].CurrentAmount)
        end,
        Color = function(char)
            if not char.Currencies or not char.Currencies[1767] then
                return AAM.ErrorColor()
            end
            local cur = char.Currencies[1767].CurrentAmount
            if cur == char.Currencies[1767].WeeklyMax then
                return AAM.SuccessColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["ReservoirAnima"] = {
        Label = "|T3528288:0|t Reservoir Anima",
        Order = 91,
        Display = true,
        Tooltip = function(char)
            if char.Currencies ~= nil then
                AddTooltipHeader(char, "Reservoir Anima")
                AddCurrencyLine(char, 1813, "|T3528288:0|t")
                GameTooltip:Show()
            end
        end,
        Value = function(char)
            if not char.Currencies or not char.Currencies[1813] or not char.Currencies[1813].CurrentAmount then
                return ""
            end
            return AAM.FormatInt(char.Currencies[1813].CurrentAmount)
        end,
        Color = function(char)
            if not char.Currencies or not char.Currencies[1813] then
                return AAM.ErrorColor()
            end
            local cur = char.Currencies[1813].CurrentAmount
            if cur == char.Currencies[1813].WeeklyMax then
                return AAM.SuccessColor()
            end
            return AAM.DefaultColor()
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
