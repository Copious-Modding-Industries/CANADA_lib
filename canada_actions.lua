dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

--- ### Gets the current card entity.
--- ***
--- @return integer|nil card The *Entity ID* of the card being played.
function CurrentCard()
    local shooter = GetUpdatedEntityID()
    local inv2comp = EntityGetFirstComponentIncludingDisabled(shooter, "Inventory2Component")
    if inv2comp then
        local activeitem = ComponentGetValue2(inv2comp, "mActiveItem")
        if EntityHasTag(activeitem, "wand") then
            local wand_actions = EntityGetAllChildren(activeitem) or {}
            for j = 1, #wand_actions do
                local itemcomp = EntityGetFirstComponentIncludingDisabled(wand_actions[j], "ItemComponent")
                if itemcomp then
                    if ComponentGetValue2(itemcomp, "mItemUid") == current_action.inventoryitem_id then
                        return wand_actions[j]
                    end
                end
            end
        end
    end
end

