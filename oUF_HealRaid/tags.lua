
local _, ns = ...
local config = ns.Config

local timer = {}

oUF.Tags.Events['status:raid'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'
oUF.Tags.Methods['status:raid'] = function(unit)
    local name = UnitName(unit)
    if (UnitIsAFK(unit) or not UnitIsConnected(unit)) then
        if (not timer[name]) then
            timer[name] = GetTime()
        end

        local time = (GetTime() - timer[name])

        return ns.FormatTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end

oUF.Tags.Events['role:raid'] = 'GROUP_ROSTER_UPDATE PLAYER_ROLES_ASSIGNED'
if (not oUF.Tags['role:raid']) then
    oUF.Tags.Methods['role:raid'] = function(unit)
        local role = UnitGroupRolesAssigned(unit)
        if (role) then
            if (role == 'TANK') then
                role = 'T'
            elseif (role == 'HEALER') then
                role = 'H'
            elseif (role == 'DAMAGER') then
                role = 'D'
            elseif (role == 'NONE') then
                role = ''
            end

            return role
        else
            return ''
        end
    end
end

oUF.Tags.Events['name:raid'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['name:raid'] = function(unit)
    local name = UnitName(unit)
            return ns.utf8sub(name, config.units.raid.nameLength)
end

oUF.Tags.Events['name:def'] = 'UNIT_NAME_UPDATE UNIT_HEALTH'
oUF.Tags.Methods['name:def'] = function(unit)
        local missinghp = UnitHealth(unit) - UnitHealthMax(unit)
        local name = UnitName(unit)

        if(missinghp < 0) then
            return AbbreviateLargeNumbers(missinghp)
        else
            return ns.utf8sub(name, config.units.raid.nameLength)
        end
    end
