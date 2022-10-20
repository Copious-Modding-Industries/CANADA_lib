dofile_once("CANADA_PATHcanada_util.lua")
local CanadaCard = {}

--- todo: what is this
--- ***
--- ### Gets the ammo of the Canada Card.
--- ***
--- @param id integer The *Entity ID* of the ***GUS WHAT DOES IT TAKE IDK***.
--- ***
--- @return integer o The amount of ammo the card has. Returns 1 if the card has unlimited ammo. 
function CanadaCard:New(id)
    local o = {}
    local prop_types = {
        ammo_system_recharge_time = "int",
        ammo_system_capacity = "int",
        ammo_system_remaining = "int",
        ammo_system_recharge_while_shooting = "bool",
        ammo_system_locked = "bool"
    }
    o.cardId = id
    setmetatable(o, {
        __index = function(t, k)
            if k == "ammo" then
                return self:GetAmmo(o.cardId)
            end
            if prop_types[k] ~= nil then
                local vsc = EntityGetComponentIncludingDisabled(id, "VariableStorageComponent");
                local comp
                for _ = 1, #vsc do
                    local v = vsc[_]
                    if ComponentGetValue2(v, "name") == k then
                        comp = v
                    end
                end
                if vsc ~= nil then
                    return ComponentGetValue2(comp, ("value_%s"):format(prop_types[k]))
                end
                return nil
            end
            return self[k]
        end,
        __newindex = function(t, k, v)
            if k == "ammo" then
                return self:SetAmmo(o.cardId, v)
            end
            if prop_types[k] ~= nil then
                local vsc = EntityGetComponentIncludingDisabled(id, "VariableStorageComponent");
                local comp
                for _ = 1, #vsc do
                    local val = vsc[_]
                    if ComponentGetValue2(v, "name") == k then
                        comp = val
                    end
                end
                if vsc ~= nil then
                    ComponentSetValue2(comp, ("value_%s"):format(prop_types[k]), v)
                end
            end
        end,
    })
    function self:New()
        return nil
    end
    return o
end

setmetatable(CanadaCard, {
    __call = function(id)
        return CanadaCard:New(id)
    end
})
function IsActionUnlimited(entity, action)
    local unlimited = false
    if action.permanently_attached then
        unlimited = true
    end
    return unlimited
end

function CurrentCard(entity)
    local wand = GetWand(entity)
    local cards = GetSpells(wand)
    local me = hand[#hand]
    local mycard = cards[me.deck_index + 1]
    return mycard
end

--- ### Gets the ammo of the Canada Card.
--- ***
--- @return integer ammo The amount of ammo the card has. Returns 1 if the card has unlimited ammo. 
function CanadaCard:GetAmmo()
    local ammo = 0
    if IsActionUnlimited(GetUpdatedEntityID()) then
        ammo = 1
    else
        local vsc = EntityGetFirstComponentIncludingDisabled(self.cardId, "VariableStorageComponent",
            "ammo_system_remaining");
        if vsc ~= nil then
            ammo = ComponentGetValue2(vsc, "value_int")
        end
    end
    return ammo
end

--- ### Sets the ammo of the Canada Card.
--- ***
--- @param count integer The amount of ammo the card will have.
function CanadaCard:SetAmmo(count)
    if IsActionUnlimited(GetUpdatedEntityID()) then
        return
    else
        local vsc = EntityGetFirstComponentIncludingDisabled(self.cardId, "VariableStorageComponent",
            "ammo_system_remaining");
        if vsc ~= nil then
            ComponentSetValue2(vsc, "value_int", count)
        end
    end
end

