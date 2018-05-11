local dataLabels = {}
local events = {}

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
            ["Unholy"] = 45861, -- An Impossible Foe
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
            ["Feral"] = 45861, -- An Impossible Foe
            ["Restoration"] = 45864, -- End of the Risen Threat
        }
    elseif class == "HUNTER" then
        return {
            ["Marksmanship"] = 45866, -- Thwarting the Twins
            ["Beast Mastery"] = 45842, -- Feltotem's Fall
            ["Survival"] = 45865, -- Closing the Eye
        }
    elseif class == "MAGE" then
        return {
            ["Fire"] = 45861, -- An Impossible Foe
            ["Frost"] = 45866, -- Thwarting the Twins
            ["Arcane"] = 45862, -- The God-Queen's Fury
        }
    elseif class == "MONK" then
        return {
            ["Windwalker"] = 45842, -- Feltotem's Fall
            ["Mistweaver"] = 45864, -- End of the Risen Threat
            ["Brewmaster"] = 45863, -- The Highlord's Return
        }
    elseif class == "PALADIN" then
        return {
            ["Retribution"] = 45862, -- The God-Queen's Fury
            ["Holy"] = 45864, -- End of the Risen Threat
            ["Protection"] = 45863, -- The Highlord's Return
        }
    elseif class == "PRIEST" then
        return {
            ["Shadow"] = 45866, -- Thwarting the Twins
            ["Holy"] = 45864, -- End of the Risen Threat
            ["Discipline"] = 45842, -- Feltotem's Fall
        }
    elseif class == "ROGUE" then
        return {
            ["Assassination"] = 45862, -- The God-Queen's Fury
            ["Outlaw"] = 45861, -- An Impossible Foe
            ["Subtlety"] = 45865, -- Closing the Eye
        }
    elseif class == "SHAMAN" then
        return {
            ["Enhancement"] = 45862, -- The God-Queen's Fury
            ["Elemental"] = 45861, -- An Impossible Foe
            ["Restoration"] = 45864, -- End of the Risen Threat
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
            ["Fury"] = 45861, -- An Impossible Foe
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

local function ChampionEquipmentNames(c)
    return ARWIC_ChampionEquipment[c.Equipment[1].ID].Name,
        ARWIC_ChampionEquipment[c.Equipment[2].ID].Name,
        ARWIC_ChampionEquipment[c.Equipment[3].ID].Name
end

local function ChampionQualityName(qID)
    local qualityNames = {
        [1] = "Common",
        [2] = "Common",
        [3] = "Uncommon",
        [4] = "Rare",
        [5] = "Epic",
        [6] = "Titled",
    }
    return qualityNames[qID]
end

local function ChampionQualityColor(qID)
    local qualityColors = {
        [1] = "ffffffff",
        [2] = "ffffffff",
        [3] = "ff1eff00",
        [4] = "ff0070dd",
        [5] = "ffa335ee",
        [6] = "ffe6cc80",
    }
    return qualityColors[qID]
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
            if char.Gear == nil or char.Gear.Items == nil or char.Gear.AvgItemLevelBags == nil then
                GameTooltip:AddLine("No Gear Data")
                GameTooltip:Show()
            else
                GameTooltip:AddLine(format("Item Level %d (Equipped %d)", char.Gear.AvgItemLevelBags, char.Gear.AvgItemLevelEquipped), TooltipHeaderColor())
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
                return ErrorColor()
            end
            return DefaultColor()
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
            return DefaultColor()
        end,
    },
    ["Champions"] = {
        Label = "Orderhall Champions",
        Order = 22,
        Display = true,
        Tooltip = function(char)
            if char.Followers == nil then
                GameTooltip:AddLine("No Champion Data", ErrorColor())
                GameTooltip:Show()
            else
                GameTooltip:AddLine("Orderhall Champions", TooltipHeaderColor())
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
                    GameTooltip:AddLine(format("|T%s:24|t |c%s%s|r", v.PortraitIconID, ChampionQualityColor(v.Quality), v.Name))
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
            return DefaultColor()
        end,
    },
}

local function NewLabel(parent, fontHeight, text)
    local str = parent:CreateFontString()
    str:SetParent(parent)
    str:SetFont("fonts/ARIALN.ttf", fontHeight)
    str:SetText(text)
    return str
end

function ARWIC_AAM_BuildGrid()
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
    local closeButton = CreateFrame("BUTTON", "AAM_closeButton", titleBar, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, 0)
    closeButton:SetWidth(titleBarHeight)
    closeButton:SetHeight(titleBarHeight)
    closeButton:SetScript("OnClick", function()
        mainFrame:Hide()
    end)

    -- config button
    local configButton = CreateFrame("BUTTON", "AAM_configButton", titleBar, "OptionsBoxTemplate")
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

function ARWIC_AAM_UpdateGrid()
    -- make sure we have a grid
    ARWIC_AAM_BuildGrid()
    -- update the values in the grid
    for _, v in pairs(dataLabels) do
        v.lbl:SetText(v.formatter.Value(v.char))
        v.lbl:SetTextColor(v.formatter.Color(v.char))
    end
end

-- loads display and order of field formatters from file
local function InitFormatters()
    -- create the config table if needed
    if ArwicAltManagerDB.Config.FieldFormatters == nil then
        ArwicAltManagerDB.Config.FieldFormatters = {}
    end
    -- load the config table or set it to defaults
    for k, v in pairs(fieldFormatters) do
        -- check if the field exists
        if ArwicAltManagerDB.Config.FieldFormatters[k] == nil then
            -- it doesnt so copy defaults to the config
            ArwicAltManagerDB.Config.FieldFormatters[k] = {}
            ArwicAltManagerDB.Config.FieldFormatters[k].Display = v.Display
            ArwicAltManagerDB.Config.FieldFormatters[k].Order = tonumber(v.Order)
        else
            -- it does so copy config to the formatter
            v.Display = ArwicAltManagerDB.Config.FieldFormatters[k].Display
            v.Order = tonumber(ArwicAltManagerDB.Config.FieldFormatters[k].Order)
        end
    end
end

function ARWIC_AAM_Toggle()
    ARWIC_AAM_UpdateGrid()
    ARWIC_AAM_mainFrame:SetShown(not ARWIC_AAM_mainFrame:IsVisible())
end

function ARWIC_AAM_Show()
    ARWIC_AAM_UpdateGrid()
    ARWIC_AAM_mainFrame:Show()
end

function ARWIC_AAM_Hide()
    ARWIC_AAM_mainFrame:Hide()
end

function events:PLAYER_ENTERING_WORLD(...)
    -- init formatters
    InitFormatters()
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
