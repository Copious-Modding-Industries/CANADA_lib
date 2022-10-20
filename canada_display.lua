dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())
local todisplay = canada_card.ammo_system_remaining
local iter = tonumber(GlobalsGetValue("canada_lib_display_iter", "0"))

local angle_dist = canada_card.ammo_system_remaining / canada_card.ammo_system_capacity * 160
local pos_dist = 12

while (todisplay > 0) do
    GameCreateSpriteForXFrames( "mods/copis_spellbook/files/particles/ammo_temp.png", pos_dist * math.cos(10 + angle_dist * todisplay), pos_dist * math.sin(10 + angle_dist * todisplay), true, 0, 0, 1, true )
    todisplay = todisplay - 1
end
GlobalsSetValue("canada_lib_display_iter", tostring(iter + 1))