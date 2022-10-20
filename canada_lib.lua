
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
--- @param file_contents string The contents of the file you wish to add a component to
--- @param comp string The component you wish to add
--- ***
--- @return string edited_contents The contents of the file with the component applied
function ModEntityFileAddComponent(file_contents, comp)
    local contents = file_contents:gsub("</Entity>$", function() return comp .. "</Entity>" end)
    return contents
end