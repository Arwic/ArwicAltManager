ArwicAltManager = {}
local events = {}
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbi = LibStub:GetLibrary("LibDBIcon-1.0")

function ArwicAltManager.InitDB()
    -- check the saved data version
    local REQ_CONFIG_VERSION = tonumber(GetAddOnMetadata("ArwicAltManager", "X-SavedVariablesVersion"))
    if REQ_CONFIG_VERSION == nil then REQ_CONFIG_VERSION = 1 end
    if ArwicAltManagerDB ~= nil then
        if ArwicAltManagerDB.Version == nil then
            ArwicAltManagerDB.Version = 1
        end
        if ArwicAltManagerDB.Version < REQ_CONFIG_VERSION then
            print(format("ArwicAltManager: Your saved data is incompatible with the current version of AAM and has been reset. (You: v%d, Current: v%d)", ArwicAltManagerDB.Version, REQ_CONFIG_VERSION))
            --ArwicAltManagerDB = nil
        end
    end

    -- root table
    if not ArwicAltManagerDB then ArwicAltManagerDB = {} end
    ArwicAltManagerDB.Version = REQ_CONFIG_VERSION
    -- config table
    if not ArwicAltManagerDB.Config then ArwicAltManagerDB.Config = {} end
    local config = ArwicAltManagerDB.Config
    -- minimap icon config tabes
    if not config.MinimapIcon then 
        config.MinimapIcon = {} 
        config.MinimapIcon.EnablePeeking = true
        config.MinimapIcon.PeekingRequireShift = true
    end
    -- field config tables
    if not config.Fields then config.Fields = {} end
    if not config.Fields.Character then config.Fields.Character = {} end
    if not config.Fields.Account then config.Fields.Account = {} end
    
    -- character data tables
    local realmName = GetRealmName()
    local charName = UnitName("player")
    if not ArwicAltManagerDB.Realms then ArwicAltManagerDB.Realms = {} end
    if not ArwicAltManagerDB.Realms[realmName] then 
        ArwicAltManagerDB.Realms[realmName] = {} 
        ArwicAltManagerDB.Realms[realmName].Display = true 
        ArwicAltManagerDB.Realms[realmName].Characters = {} 
    end
    if not ArwicAltManagerDB.Realms[realmName].Characters[charName] then 
        ArwicAltManagerDB.Realms[realmName].Characters[charName] = {} 
        ArwicAltManagerDB.Realms[realmName].Characters[charName].Display = true 
    end
    -- account data tables
    if not ArwicAltManagerDB.Account then
        ArwicAltManagerDB.Account = {}
    end
end

function ArwicAltManager.InitLDB()
    ArwicAltManager.ManuallyOpen = false
    local ldbConfig = {
        type = "launcher",
        icon = "132212",
        label = "Arwic Alt Manager",
        text  = "AAM",
        OnClick = function(sender, btn)
            if btn == "LeftButton" then
                if IsControlKeyDown() then
                    ArwicAltManager.ToggleAccountGrid()
                else
                    if ArwicAltManager.ManuallyOpen then
                        ArwicAltManager.ManuallyOpen = false
                        ArwicAltManager.HideCharacterGrid()
                    else
                        ArwicAltManager.ManuallyOpen = true
                        ArwicAltManager.ShowCharacterGrid()
                    end
                end
            elseif btn == "RightButton" then
                ArwicAltManager.ToggleConfig()
            end
        end,
        OnEnter = function(sender)
            ArwicAltManager.MouseOverIcon = true
            GameTooltip:SetOwner(sender, "ANCHOR_BOTTOMLEFT")
            GameTooltip:AddLine("Arwic Alt Manager")
            if ArwicAltManagerDB.Config.MinimapIcon.EnablePeeking then
                if ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift then
                    GameTooltip:AddLine("|cFFFFA500Hold Shift|cFFFFFFFF to peek character grid.")
                else
                    GameTooltip:AddLine("|cFFFFA500Hover|cFFFFFFFF to peek character grid.")
                end
            end
            GameTooltip:AddLine("|cFFFFA500Left Click|cFFFFFFFF to open character grid.")
            GameTooltip:AddLine("|cFFFFA500Control Left Click|cFFFFFFFF to open account grid.")
            GameTooltip:AddLine("|cFFFFA500Right Click|cFFFFFFFF to open config.")
            GameTooltip:AddLine("You can change peeking behaviour and hide this icon in config", 0.4, 1, 0.4, true)
            GameTooltip:Show()
            if ArwicAltManagerDB.Config.MinimapIcon.EnablePeeking then
                if ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift and IsShiftKeyDown() then
                    ArwicAltManager.ShowCharacterGrid()
                elseif not ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift then
                    ArwicAltManager.ShowCharacterGrid()
                end
            end
        end,
        OnLeave = function(sender)
            ArwicAltManager.MouseOverIcon = false
            if not ArwicAltManager.ManuallyOpen then -- we should hide the grid only if it is not manually open
                ArwicAltManager.HideCharacterGrid()
            end
            GameTooltip_Hide()
        end,
    }
    local obj = ldb:NewDataObject("ArwicAltManager", ldbConfig)
    ldbi:Register("ArwicAltManager", obj, ArwicAltManagerDB.Config.MinimapIcon)
end

events["ADDON_LOADED"] = function(self, addonName)
    if addonName == "ArwicAltManager" then
        ArwicAltManager.InitDB()
        ArwicAltManager.InitLDB()
    end
end

events["MODIFIER_STATE_CHANGED"] = function(self, key, state)
    if ArwicAltManagerDB.Config.MinimapIcon.PeekingRequireShift and ArwicAltManagerDB.Config.MinimapIcon.EnablePeeking then
        if key == "LSHIFT" or key == "RSHIFT" then
            if ArwicAltManager.MouseOverIcon and not ArwicAltManager.ManuallyOpen then
                if state == 0 then -- key release
                    ArwicAltManager.HideCharacterGrid()
                elseif state == 1 then -- key pressed
                    ArwicAltManager.ShowCharacterGrid()
                end
            end
        end
    end
end

local function RegisterEvents()
    -- register events
    local eventFrame = CreateFrame("FRAME", "AAM_core_eventFrame")
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
    if args[1] == "config" then
        ArwicAltManager.ToggleConfig()
    elseif args[1] == "account" then
        ArwicAltManager.ToggleAccountGrid()
    else
        ArwicAltManager.ToggleCharacterGrid()
    end
end
