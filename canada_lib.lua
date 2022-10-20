function GetWand( entity )
    local inv2_comp = EntityGetFirstComponentIncludingDisabled(entity, "Inventory2Component")
    if inv2_comp ~= nil then
        return ComponentGetValue2(inv2_comp, "mActiveItem")
    end
end

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

--- @param file_path string The contents of the file you wish to add a component to
--- @param comp string The component you wish to add
function ModEntityFileAddComponent(file_path, comp)
    local file_contents = ModTextFileGetContent(file_path)
    local contents = file_contents:gsub("</Entity>$", function() return comp .. "</Entity>" end)
    ModTextFileSetContent(file_path, contents)
end

--- @param name string The name the VariableStorageComponent should be given
--- @param value string|number|boolean The value that should be stored
--- @return string
function GenerateVSC(name, value)
    local ty
    if type(value) == "boolean" then ty = "bool" elseif type(value) == "number" then ty = "float" else ty = "string" end
    return ('<VariableStorageComponent tags="%s" name="%s" value_%s="%s"></VariableStorageComponent>'):format(name, name, ty, tostring(value))
end