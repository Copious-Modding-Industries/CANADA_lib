
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
--- @field remaining number 
--- @field recharge_time integer
--- @field capacity integer
--- @field recharge_while_shooting boolean
--- @field locked boolean
--- @field reload_on_empty boolean
CanadaCard = {}

--- @enum prop_types
local prop_types = {
    ammo = "int",
    recharge_time = "int",
    capacity = "int",
    remaining = "int",
    recharge_while_shooting = "bool",
    locked = "bool",
    reload_on_empty = "bool"
}

function CanadaCard:New(id)
    --- @type CanadaCard
    local o = {}
    o.cardId = id
    setmetatable(o, {
        __index = function(_, k)
            local r = self:Getter(k)
            if r ~= nil then return r end
            return CanadaCard[k]
        end,
        __newindex = function(_, k, v)
            self:Setter(k, v)
        end,
    })
    return o
end

setmetatable(CanadaCard, {
    __call = function(id)
        return CanadaCard:New(id)
    end
})

--- @param k string
--- @return nil|number|boolean|string
function CanadaCard:Getter(k)
    if prop_types[k] ~= nil then
        if k == "ammo" then k = "remaining" end
        local vsc = EntityGetComponentIncludingDisabled(self.cardId, "VariableStorageComponent");
        local comp
        if vsc ~= nil then
            for _ = 1, #vsc do
                local v = vsc[_]
                if ComponentGetValue2(v, "name") == "ammo_system_" .. k then
                    comp = v
                end
            end
            return ComponentGetValue2(comp, ("value_%s"):format(prop_types[k]))
        end
    end
end

--- @param k string
--- @param v number|boolean|string
--- @return nil
function CanadaCard:Setter(k, v)
    if prop_types[k] ~= nil then
        if k == "ammo" then k = "remaining" end
        local vsc = EntityGetComponentIncludingDisabled(self.cardId, "VariableStorageComponent");
        local comp
        if vsc ~= nil then
            for _ = 1, #vsc do
                local val = vsc[_]
                if ComponentGetValue2(val, "name") == "ammo_system_" .. k then
                    comp = val
                end
            end
            ComponentSetValue2(comp, ("value_%s"):format(prop_types[k]), v)
        end
    end
end