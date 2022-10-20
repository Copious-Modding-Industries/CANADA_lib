dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

--- ### Gets the current card entity.
--- ***
--- @param entity integer The *Entity ID* of the shooter.
--- ***
--- @return integer|nil card The *Entity ID* of the card being played.
function CurrentCard(entity)
    local wand = GetWand(entity)
    if wand == nil then return end
    local cards = GetSpells(wand)
    if cards == nil then return end
    local me = hand[#hand]
    local card = cards[me.deck_index + 1]
    return card
end