
function table.len(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.containskey(t, k)
    for tk, _ in pairs(t) do
        if tk == k then
            return true
        end
    end
end

function table.containsval(t, v)
    for _, tv in pairs(t) do
        if tv == v then
            return true
        end
    end
end

function string.starts(s, v)
   return string.sub(s, 1, string.len(v)) == v
end

function spairs(t, order) -- https://stackoverflow.com/a/15706820/3105105
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end