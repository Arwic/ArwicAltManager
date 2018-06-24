function AAM_ClassColor(className)
    return RAID_CLASS_COLORS[className].r, 
        RAID_CLASS_COLORS[className].g, 
        RAID_CLASS_COLORS[className].b
end

function AAM_FactionColor(factionName)
    if factionName == "Alliance" then
        return 0, 0.6, 1
    elseif factionName == "Horde" then
        return 0.85, 0, 0
    end
end

function AAM_ClassName(classID)
    if classID == "DEMONHUNTER" then
        return "Demon Hunter"
    elseif classID == "DEATHKNIGHT" then
        return "Death Knight"
    end
    return classID:sub(1,1):upper() .. classID:sub(2):lower()
end

function AAM_ErrorColor()
    return 0.85, 0.33, 0.25
end

function AAM_DefaultColor()
    return 1.0, 1.0, 1.0
end

function AAM_TooltipHeaderColor()
    return 1, 1, 1
end

function AAM_SuccessColor()
    return 0.0, 1.0, 0.0
end

function AAM_FormatBool(b)
    if b then 
        return "Yes" 
    else
        return "No" 
    end
end

function AAM_FormatInt(i)
    return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function AAM_FormatTime(timeSeconds)
    local days = floor(timeSeconds / 86400)
    local hours = floor((timeSeconds % 86400) / 3600)
    local minutes = floor((timeSeconds % 3600) / 60)
    local seconds = floor(timeSeconds % 60)
    return days, hours, minutes, seconds
end

function AAM_ColorEscape(r, g, b)
    if r == nil then r = 1 end
    if g == nil then g = 1 end
    if b == nil then b = 1 end
    return format('|cff%.2x%.2x%.2x', r * 255, g * 255, b * 255)
end
