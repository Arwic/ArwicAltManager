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
    elseif args[1] == "account" then
        if ARWIC_AAM_accountFrame then
            ARWIC_AAM_ToggleAccount()
        else
            ARWIC_AAM_BuildAccountGrid()
        end
    else
        ARWIC_AAM_UpdateData()
        if ARWIC_AAM_mainFrame then
            ARWIC_AAM_Toggle()
        else
            ARWIC_AAM_BuildGrid()
        end
    end
end
