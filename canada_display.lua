dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local entity_id = GetUpdatedEntityID()
local canada_card = CanadaCard(entity_id)
local shooter = EntityGetParent(EntityGetParent(entity_id))

local todisplay = canada_card.remaining

local iter = tonumber(GlobalsGetValue("canada_lib_display_iter", "0"))
local iter_tl = tonumber(GlobalsGetValue("canada_lib_display_iter_tl", "0"))
local pos_dist = iter * 5

local angle = { min = 10, max = 170 }
local angle_delta = 160 / canada_card.capacity

local controlscomp = EntityGetFirstComponent(EntityGetRootEntity(entity_id), "ControlsComponent")
if controlscomp ~= nil then
    local mouse_x, mouse_y = ComponentGetValue2(controlscomp, "mMousePosition");
    -- twin linked stuff
    if ("arm_l" == EntityGetName(shooter)) then
        angle.min = 190
        angle.max = 350
        pos_dist = pos_dist + iter_tl * 5
        GlobalsSetValue("canada_lib_display_iter_tl", tostring(iter_tl + 1))
    else
        GlobalsSetValue("canada_lib_display_iter", tostring(iter + 1))
    end
    while (todisplay > 0) do
        GameCreateSpriteForXFrames("CANADA_PATHcanada_gfx/ammo_fill.png",
            mouse_x + (pos_dist * math.cos(angle.min + (angle_delta * todisplay))),
            mouse_y + (pos_dist * math.sin(angle.min + (angle_delta * todisplay))),
            true, 0, 0, 1, true)

        todisplay = todisplay - 1
    end
end