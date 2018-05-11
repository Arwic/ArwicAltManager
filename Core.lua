ArwicAltManager = {}
local events = {}

function ArwicAltManager.InitDB()
    -- check the saved data version
    local REQ_CONFIG_VERSION = tonumber(GetAddOnMetadata("ArwicAltManager", "X-SavedVariablesVersion"))
    if ArwicAltManagerDB ~= nil then
        if ArwicAltManagerDB.Version == nil then
            ArwicAltManagerDB.Version = 0
        end
        if ArwicAltManagerDB.Version < REQ_CONFIG_VERSION then
            print(format("ArwicAltManager: Your saved data is incompatible with the current version of AAM and has been reset. (You: v%d, Current: v%d)", ArwicAltManagerDB.Version, REQ_CONFIG_VERSION))
            ArwicAltManagerDB = nil
        end
    end

    -- root table
    if not ArwicAltManagerDB then ArwicAltManagerDB = {} end
    ArwicAltManagerDB.Version = REQ_CONFIG_VERSION
    -- config table
    if not ArwicAltManagerDB.Config then ArwicAltManagerDB.Config = {} end
    local config = ArwicAltManagerDB.Config
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

local function RegisterEvents()
    local f = CreateFrame("FRAME")
    f:SetScript("OnEvent", function(self, event, addonName)
        if event == "ADDON_LOADED" and addonName == "ArwicAltManager" then
            ArwicAltManager.InitDB()
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
