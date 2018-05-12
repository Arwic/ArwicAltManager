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
    -- minimap icon config tabesl
    if not config.MinimapIcon then config.MinimapIcon = {} end
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
    local ldbConfig = {
        type = "launcher",
        icon = "132212",
        label = "Arwic Alt Manager",
        text  = "AAM",
        OnClick = function(sender, btn)
            if btn == "LeftButton" then
                if IsShiftKeyDown() then
                    ArwicAltManager.ToggleAccountGrid()
                else
                    ArwicAltManager.ToggleCharacterGrid()
                end
            elseif btn == "RightButton" then
                ArwicAltManager.ToggleConfig()
            end
        end,
        OnEnter = function(sender)
            GameTooltip:SetOwner(sender, "ANCHOR_BOTTOMLEFT")
            GameTooltip:AddLine("Arwic Alt Manager")
            GameTooltip:AddDoubleLine("Character Grid", "Left Click")
            GameTooltip:AddDoubleLine("Account Grid", "Shift Left Click")
            GameTooltip:AddDoubleLine("Config", "Right Click")
            GameTooltip:Show()
            if IsShiftKeyDown() then
                ArwicAltManager.Peeking = true
                ArwicAltManager.ShowCharacterGrid() 
            end
        end,
        OnLeave = function(sender)
            GameTooltip_Hide()
        end,
    }
    local obj = ldb:NewDataObject("ArwicAltManager", ldbConfig)
    ldbi:Register("ArwicAltManager", obj, ArwicAltManagerDB.Config.MinimapIcon)
end

local function RegisterEvents()
    local f = CreateFrame("FRAME")
    f:SetScript("OnEvent", function(self, event, addonName)
        if event == "ADDON_LOADED" and addonName == "ArwicAltManager" then
            ArwicAltManager.InitDB()
            ArwicAltManager.InitLDB()
        end
    end)
    f:RegisterEvent("ADDON_LOADED")
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
