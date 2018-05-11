function ArwicAltManager.ClassColor(className)
    return RAID_CLASS_COLORS[className].r, 
        RAID_CLASS_COLORS[className].g, 
        RAID_CLASS_COLORS[className].b
end

function ArwicAltManager.FactionColor(factionName)
    if factionName == "Alliance" then
        return 0, 0.8, 1
    elseif factionName == "Horde" then
        return 0.85, 0, 0
    end
end

function ArwicAltManager.ClassName(classID)
    if classID == "DEMONHUNTER" then
        return "Demon Hunter"
    elseif classID == "DEATHKNIGHT" then
        return "Death Knight"
    end
    return classID:sub(1,1):upper() .. classID:sub(2):lower()
end

function ArwicAltManager.ErrorColor()
    return 0.85, 0.33, 0.25
end

function ArwicAltManager.DefaultColor()
    return 1.0, 1.0, 1.0
end

function ArwicAltManager.TooltipHeaderColor()
    return 1, 1, 1
end

function ArwicAltManager.SuccessColor()
    return 0.0, 1.0, 0.0
end

function ArwicAltManager.FormatBool(b)
    if b then 
        return "Yes" 
    else
        return "No" 
    end
end

function ArwicAltManager.FormatInt(i)
    return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function ArwicAltManager.FormatTime(timeSeconds)
    local days = floor(timeSeconds / 86400)
    local hours = floor((timeSeconds % 86400) / 3600)
    local minutes = floor((timeSeconds % 3600) / 60)
    local seconds = floor(timeSeconds % 60)
    return days, hours, minutes, seconds
end
