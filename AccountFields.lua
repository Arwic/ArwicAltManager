local AAM = ArwicAltManager

local function Account()
    return ArwicAltManagerDB.Account
end

local armorProficiency = {
    ["WARRIOR"] = 4,
    ["PALADIN"] = 4,
    ["HUNTER"] = 3,
    ["ROGUE"] = 2,
    ["PRIEST"] = 1,
    ["DEATHKNIGHT"] = 4,
    ["SHAMAN"] = 3,
    ["MAGE"] = 1,
    ["WARLOCK"] = 1,
    ["MONK"] = 2,
    ["DRUID"] = 2,
    ["DEMONHUNTER"] = 2,
}

if ArwicAltManager.Fields == nil then ArwicAltManager.Fields = {} end
ArwicAltManager.Fields.Account = {
    ["INTERNAL_Mounts"] = {
        Internal = true,
        Display = false,
        Order = 0,
        Update = function()
            local account = Account()
            account.Mounts = {}
            -- get collected mounts
            local mountIDs = C_MountJournal.GetMountIDs()
            for _, mid in pairs(mountIDs) do
                local creatureName, spellID, _, _, _, _, _, _, _, _, isCollected, mountID = C_MountJournal.GetMountInfoByID(mid)
                account.Mounts[spellID] = {}
                account.Mounts[spellID].Name = creatureName
                account.Mounts[spellID].IsCollected = isCollected
                account.Mounts[spellID].MountID = mountID
            end
        end,
    },
    ["Mount_VioletSpellwing"] = {
        Label = "Violet Spellwing",
        Order = 500,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Violet Spellwing", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Heroic difficulty or higher in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[253639].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[253639].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Mount_ShackledUrzul"] = {
        Label = "Shackled Urzul",
        Order = 510,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Shackled Urzul", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Argus the Unmaker on Mythic difficulty in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[243651].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[243651].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Mount_HellfireInfernal"] = {
        Label = "Hellfire Infernal",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Hellfire Infernal", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Mythic difficulty in the Nighthold.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[171827].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[171827].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Mount_FelblazeInfernal"] = {
        Label = "Felblaze Infernal",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Felblaze Infernal", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Gul'dan on Normal difficulty or higher in the Nighthold.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[213134].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[213134].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Mount_AbyssWorm"] = {
        Label = "Abyss Worm",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Abyss Worm", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Mistress Sassz'ine on Raid Finder difficulty or higher in the Tomb of Sargeras.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[232519].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[232519].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["Mount_AntoranCharhound"] = {
        Label = "Antoran Charhound",
        Order = 520,
        Display = true,
        Tooltip = function(char)
            GameTooltip:AddLine("Antoran Charhound", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by defeating Felhounds of Sargeras on Raid Finder difficulty or higher in Antorus, the Burning Throne.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Value = function()
            if not Account().Mounts then
                return "?"
            end
            return AAM.FormatBool(Account().Mounts[253088].IsCollected)
        end,
        Color = function()
            if not Account().Mounts or not Account().Mounts[253088].IsCollected then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
    },
    ["FieldMedic"] = {
        Label = "Field Medic",
        Order = 600,
        Display = true,
        Value = function()
            return AAM.FormatBool(Account().FieldMedic)
        end,
        Color = function()
            if not Account().FieldMedic then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Tooltip = function()
            GameTooltip:SetHyperlink(GetAchievementLink(11139))
            GameTooltip:Show()
        end,
        Update = function()
            Account().FieldMedic = select(4, GetAchievementInfo(11139))
        end,
    },
    ["ChosenTransmogs_Cloth"] = {
        Label = "Chosen Cloth",
        Order = 701,
        Display = true,
        Value = function()
            if Account().ChosenTransmogUnlocked ~= nil then
                return AAM.FormatBool(Account().ChosenTransmogUnlocked[1])
            end
        end,
        Color = function()
            if Account().ChosenTransmogUnlocked ~= nil and Account().ChosenTransmogUnlocked[1] then
                return AAM.DefaultColor()
            end
            return AAM.ErrorColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Cloth", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a cloth wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Update = function()
            local account = Account()
            if not account.ChosenTransmogUnlocked then account.ChosenTransmogUnlocked = {} end
            account.ChosenTransmogUnlocked[1] = C_TransmogCollection.PlayerHasTransmog(143346) or account.ChosenTransmogUnlocked[1]
        end,
    },
    ["ChosenTransmogs_Leather"] = {
        Label = "Chosen Leather",
        Order = 702,
        Display = true,
        Value = function()
            if Account().ChosenTransmogUnlocked ~= nil then
                return AAM.FormatBool(Account().ChosenTransmogUnlocked[2])
            end
        end,
        Color = function()
            if Account().ChosenTransmogUnlocked ~= nil and Account().ChosenTransmogUnlocked[2] then
                return AAM.DefaultColor()
            end
            return AAM.ErrorColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Leather", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a leather wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Update = function()
            local account = Account()
            if not account.ChosenTransmogUnlocked then account.ChosenTransmogUnlocked = {} end
            account.ChosenTransmogUnlocked[2] = C_TransmogCollection.PlayerHasTransmog(143348) or account.ChosenTransmogUnlocked[2]
        end,
    },
    ["ChosenTransmogs_Mail"] = {
        Label = "Chosen Mail",
        Order = 703,
        Display = true,
        Value = function()
            if Account().ChosenTransmogUnlocked ~= nil then
                return AAM.FormatBool(Account().ChosenTransmogUnlocked[3])
            end
        end,
        Color = function()
            if Account().ChosenTransmogUnlocked ~= nil and Account().ChosenTransmogUnlocked[3] then
                return AAM.DefaultColor()
            end
            return AAM.ErrorColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Mail", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a mail wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Update = function()
            local account = Account()
            if not account.ChosenTransmogUnlocked then account.ChosenTransmogUnlocked = {} end
            account.ChosenTransmogUnlocked[3] = C_TransmogCollection.PlayerHasTransmog(143347) or account.ChosenTransmogUnlocked[3]
        end,
    },
    ["ChosenTransmogs_Plate"] = {
        Label = "Chosen Plate",
        Order = 704,
        Display = true,
        Value = function()
            if Account().ChosenTransmogUnlocked ~= nil then
                return AAM.FormatBool(Account().ChosenTransmogUnlocked[4])
            end
        end,
        Color = function()
            if Account().ChosenTransmogUnlocked ~= nil and Account().ChosenTransmogUnlocked[4] then
                return AAM.DefaultColor()
            end
            return AAM.ErrorColor()
        end,
        Tooltip = function(char)
            GameTooltip:AddLine("Chosen Plate", AAM.TooltipHeaderColor())
            GameTooltip:AddLine("Obtained by completing the achievement [The Chosen] and opening the box on a plate wearing character.", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Update = function()
            local account = Account()
            if account.ChosenTransmogUnlocked == nil then account.ChosenTransmogUnlocked = {} end
            account.ChosenTransmogUnlocked[4] = C_TransmogCollection.PlayerHasTransmog(143345) or account.ChosenTransmogUnlocked[4]
        end,
    },
    ["FisherfriendOfTheIsles"] = {
        Label = "Fisherfriend of the Isles",
        Order = 710,
        Display = true,
        Value = function()
            return AAM.FormatBool(Account().FisherfriendOfTheIsles)
        end,
        Color = function()
            if not Account().FisherfriendOfTheIsles then
                return AAM.ErrorColor()
            end
            return AAM.DefaultColor()
        end,
        Tooltip = function()
            GameTooltip:SetHyperlink(GetAchievementLink(11725))
            GameTooltip:Show()
        end,
        Update = function()
            Account().FisherfriendOfTheIsles = select(4, GetAchievementInfo(11725))
        end,
    },
}

function ArwicAltManager.UpdateAccountData()
    for k, v in pairs(ArwicAltManager.Fields.Account) do
        if v.Update ~= nil then
            v.Update()
        end
    end
end

local function InitFields()
    -- load the config table or set it to defaults
    for k, v in pairs(ArwicAltManager.Fields.Account) do
        -- check if the field exists
        if ArwicAltManagerDB.Config.Fields.Account[k] == nil then
            -- it doesnt so copy defaults to the config
            ArwicAltManagerDB.Config.Fields.Account[k] = {}
            ArwicAltManagerDB.Config.Fields.Account[k].Internal = v.Internal
            ArwicAltManagerDB.Config.Fields.Account[k].Display = v.Display
            ArwicAltManagerDB.Config.Fields.Account[k].Order = tonumber(v.Order)
        else
            -- it does so copy config to the formatter
            v.Internal = ArwicAltManagerDB.Config.Fields.Account[k].Internal
            v.Display = ArwicAltManagerDB.Config.Fields.Account[k].Display
            v.Order = tonumber(ArwicAltManagerDB.Config.Fields.Account[k].Order)
        end
    end
end
local function RegisterEvents()
    local f = CreateFrame("FRAME")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            InitFields()
            ArwicAltManager.UpdateAccountData()
        end
    end)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    hooksecurefunc("ToggleGameMenu", ArwicAltManager.UpdateAccountData)
    hooksecurefunc("Logout", ArwicAltManager.UpdateAccountData)
    hooksecurefunc("Quit", ArwicAltManager.UpdateAccountData)
end
RegisterEvents()

local function RegisterEventUpdates()
    for k, v in pairs(ArwicAltManager.Fields.Account) do
        if v.EventUpdates ~= nil then
            local ef = CreateFrame("FRAME", "AAM_eventFrame_accountFields_" .. k)
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
