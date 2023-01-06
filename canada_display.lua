dofile_once("CANADA_PATHcanada_lib.lua")

gui = gui or GuiCreate()
GuiStartFrame(gui)
local entity_id = GetUpdatedEntityID()
local canada_card = CanadaCard(entity_id)
local shooter = EntityGetParent(EntityGetParent(entity_id))
IterMH = IterMH or 0
IterOH = IterOH or 0
local pos_dist
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
    local swidth, sheight = GuiGetScreenDimensions(gui)
    local mraw_x, mraw_y = ComponentGetValue2(controlscomp, "mMousePositionRaw")
    local mouse_x, mouse_y = mraw_x * swidth / 1280, mraw_y * sheight / 720
    -- twin linked stuff
    if ("arm_l" == EntityGetName(shooter)) then
        angle.min = 190
        angle.max = 350
        pos_dist = IterOH * 24
        IterOH = (IterOH + 1) or 0
    else
        pos_dist = IterMH * 24
        IterMH = (IterMH + 1) or 0
    end
    while (todisplay > 0) do
        GuiImage(gui, getID(),
            mouse_x + (pos_dist * math.cos(math.rad(angle.min + (angle_delta * todisplay)))),
            mouse_y + (pos_dist * math.sin(math.rad(angle.min + (angle_delta * todisplay)))),
            "CANADA_PATHcanada_gfx/ammo_fill.png", 1, 1, 1, angle_delta * todisplay)
        todisplay = todisplay - 1
    end
end




-- TEMP!! display ammo in chat until gus does his stuff
local txt = canada_card.reloading and tostring(canada_card.reload_end_frame - GameGetFrameNum()) or ""
GamePrint(tostring(canada_card.remaining) .. " | " .. txt)