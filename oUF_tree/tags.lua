
local _, ns = ...
local config = ns.Config

oUF.Tags.Events["level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
oUF.Tags.Methods["level"] = function(unit)
    
    local c = UnitClassification(unit)
    local l = UnitLevel(unit)
    local d = GetQuestDifficultyColor(l)
    
    local str = l
        
    if l <= 0 then l = "??" end
    
    if c == "worldboss" then
        str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
    elseif c == "eliterare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
    elseif c == "elite" then
        str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
    elseif c == "rare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
    else
        if not UnitIsConnected(unit) then
            str = "??"
        else
            if UnitIsPlayer(unit) then
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            elseif UnitPlayerControlled(unit) then
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            else
                str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
            end
        end     
    end
    
    return str
end

oUF.Tags.Events['ns:pp'] = "UNIT_POWER"
oUF.Tags.Methods['ns:pp'] = function(unit)
    local pp = UnitPower(unit)

    if pp <= 9999 then return pp end
    if pp >= 1000000 then
        local value = string.format("%.1fm",pp/1000000)
        return value
    elseif pp >= 10000 then
        local value = string.format("%.1fk",pp/1000)
        return value
    end
end

oUF.Tags.Events['name:normal'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['name:normal'] = function(unit)
    local name = UnitName(unit)
    return string.sub(name,1,20)
end

oUF.Tags.Events["ns:hp"] = "UNIT_HEALTH"
oUF.Tags.Methods["ns:hp"] = function(unit)
        if not UnitIsDeadOrGhost(unit) then
            local hp = UnitHealth(unit)
            if hp <= 9999 then return hp end
            if hp >= 1000000 then
                local value = string.format("%.1fm",hp/1000000)
                return value
            elseif hp >= 10000 then
                local value = string.format("%.1fk",hp/1000)
                return value
        end
    end
end