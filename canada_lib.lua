
--- ### Returns the *Entity ID* of the wand a creature is currently holding.
--- ***
--- @param entity integer The *Entity ID* of the creature holding the wand.
--- ***
--- @return integer|nil wand_id The *Entity ID* of the held wand, or nil if no wand is held.
function GetWand( entity )
    local inv2_comp = EntityGetFirstComponentIncludingDisabled(entity, "Inventory2Component")
    if inv2_comp ~= nil then
        local wand_id = ComponentGetValue2(inv2_comp, "mActiveItem")
        return wand_id
    end
end

--- ### Returns two tables of *Entity IDs* corresponding to all spells on a wand, and the always cast spells. 
--- ***
--- @param wand integer The *Entity ID* of the wand
--- ***
--- @return table|nil spells The table of spells on the wand, or nil if no wand is held.
--- @return table|nil spells_ac The table of always cast spells on the wand, or nil if no wand is held.
function GetSpells( wand )
    if wand ~= nil then
        local children = EntityGetAllChildren(wand)
        local spells = {}
        local spells_ac = {}
        for _, child in ipairs(children) do
            if EntityHasTag(child, "card_action") then
                local item_comp = EntityGetFirstComponentIncludingDisabled(child, "ItemComponent")
                if item_comp ~= nil then
                    local ac = ComponentGetValue2(item_comp, "permanently_attached")
                    if ac then
                        table.insert(spells_ac, child)
                    else
                        table.insert(spells, child)
                    end
                end
            end
        end
        return spells, spells_ac
    end
end

--- ### Adds a component to an entity file.
--- ***
--- @param file_path string The path to the file you wish to add a component to.
--- @param comp string The component you wish to add.
function ModEntityFileAddComponent(file_path, comp)
    local file_contents = ModTextFileGetContent(file_path)
    local contents = file_contents:gsub("</Entity>$", function() return comp .. "</Entity>" end)
    ModTextFileSetContent(file_path, contents)
end

--- ### Generates the XML for a VariableStorageComponent.
--- ***
--- @param name string The name the VariableStorageComponent should be given.
--- @param value string|number|boolean The value that should be stored.
--- ***
--- @return string vsc The variable storage component which has been generated.
function GenerateVSC(name, value)
    local ty
    if type(value) == "boolean" then ty = "bool" elseif type(value) == "number" then ty = "int" else ty = "string" end
    local vsc = ('<VariableStorageComponent tags="%s" name="%s" value_%s="%s"></VariableStorageComponent>'):format(name, name, ty, tostring(value))
    return vsc
end

--- ### Metatable for Canada Card.
--- @class CanadaCard
--- @operator call: CanadaCard
--- @field cardId number
--- @field ammo number
--- @field ammo_system_recharge_time integer
--- @field ammo_system_capacity integer
--- @field ammo_system_remaining integer
--- @field ammo_system_recharge_while_shooting boolean
--- @field ammo_system_locked boolean
CanadaCard = {}

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
                return o:GetAmmo()
            end
            if prop_types[k] ~= nil then
                local vsc = EntityGetComponentIncludingDisabled(id, "VariableStorageComponent");
                local comp
                if vsc ~= nil then
                    for _ = 1, #vsc do
                        local v = vsc[_]
                        if ComponentGetValue2(v, "name") == k then
                            comp = v
                        end
                    end
                    return ComponentGetValue2(comp, ("value_%s"):format(prop_types[k]))
                end
                return nil
            end
            return CanadaCard[k]
        end,
        __newindex = function(t, k, v)
            if k == "ammo" then
                return o:SetAmmo(v)
            end
            if prop_types[k] ~= nil then
                local vsc = EntityGetComponentIncludingDisabled(id, "VariableStorageComponent");
                local comp
                if vsc ~= nil then
                    for _ = 1, #vsc do
                        local val = vsc[_]
                        if ComponentGetValue2(v, "name") == k then
                            comp = val
                        end
                    end
                    ComponentSetValue2(comp, ("value_%s"):format(prop_types[k]), v)
                end
            end
        end,
    })
    return o
end

setmetatable(CanadaCard, {
    __call = function(id)
        return CanadaCard:New(id)
    end
})

--- ### Gets the ammo of the Canada Card.
--- ***
--- @return integer ammo The amount of ammo the card has.
function CanadaCard:GetAmmo()
    local ammo = 0
    local vsc = EntityGetFirstComponentIncludingDisabled(self.cardId, "VariableStorageComponent", "ammo_system_remaining");
    if vsc ~= nil then
        ammo = ComponentGetValue2(vsc, "value_int")
    end
    return ammo
end

--- ### Sets the ammo of the Canada Card.
--- ***
--- @param count integer The amount of ammo the card will have.
function CanadaCard:SetAmmo(count)
    local vsc = EntityGetFirstComponentIncludingDisabled(self.cardId, "VariableStorageComponent", "ammo_system_remaining");
    if vsc ~= nil then
        ComponentSetValue2(vsc, "value_int", count)
    end
end