dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local entity_id = GetUpdatedEntityID()
local canada_card = CanadaCard(entity_id)
local todisplay = canada_card.ammo_system_remaining
local iter = tonumber(GlobalsGetValue("canada_lib_display_iter", "0"))

local angle_dist = canada_card.ammo_system_remaining / canada_card.ammo_system_capacity * 160
local pos_dist = 12

local wand = EntityGetParent(entity_id)
local shooter = EntityGetParent(wand)
local angle_init = 10
-- twin linked stuff
if ( "arm_l" == EntityGetName(shooter)) then angle_init = 190 end

while (todisplay > 0) do
    GameCreateSpriteForXFrames( "mods/copis_spellbook/files/particles/ammo_temp.png", pos_dist * math.cos(angle_init + angle_dist * todisplay), pos_dist * math.sin(angle_init + angle_dist * todisplay), true, 0, 0, 1, true )
    todisplay = todisplay - 1
end
GlobalsSetValue("canada_lib_display_iter", tostring(iter + 1))