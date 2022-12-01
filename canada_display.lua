dofile_once("CANADA_PATHcanada_lib.lua")

gui = gui or GuiCreate()
GuiStartFrame(gui)
local entity_id = GetUpdatedEntityID()
local canada_card = CanadaCard(entity_id)
local shooter = EntityGetParent(EntityGetParent(entity_id))
local iter = tonumber(GlobalsGetValue("canada_lib_display_iter", "0"))
local iter_tl = tonumber(GlobalsGetValue("canada_lib_display_iter_tl", "0"))
local pos_dist = 2 + iter * 12
_id = 0
local getID = function ()
    _id = _id + 1
    return _id
end

local angle = { min = 10, max = 170 }
local angle_delta = 160 / canada_card.capacity
local todisplay = canada_card.remaining
local controlscomp = EntityGetFirstComponent(EntityGetRootEntity(entity_id), "ControlsComponent")
if controlscomp ~= nil then
    local mx, my = ComponentGetValue2(controlscomp, "mMousePosition")
    local screen_w, screen_h = GuiGetScreenDimensions(gui)
    local cx, cy = GameGetCameraPos()
    local vx = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
    local vy = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
    local gmx = ((mx - cx) * screen_w / vx + screen_w / 2)
    local gmy = ((my - cy) * screen_h / vy + screen_h / 2)
    local mouse_x, mouse_y = math.floor(gmx), math.floor(gmy)
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
        GuiImage(gui, getID(),
            mouse_x + (pos_dist * math.cos(math.rad(angle.min + (angle_delta * todisplay)))),
            mouse_y + (pos_dist * math.sin(math.rad(angle.min + (angle_delta * todisplay)))),
            "CANADA_PATHcanada_gfx/ammo_fill.png", 1, 1, 1, angle_delta)
        todisplay = todisplay - 1
    end
end