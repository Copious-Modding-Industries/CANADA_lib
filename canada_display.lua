dofile_once("CANADA_PATHcanada_lib.lua")

Gui = Gui or GuiCreate()
GuiStartFrame(Gui)
GuiIdPushString(Gui, "CANADA_GUI_" .. tostring(GetUpdatedEntityID()))
local entity_id = GetUpdatedEntityID()
local canada_card = CanadaCard(entity_id)
local shooter = entity_id
for i = 1, 3 do
    shooter = EntityGetParent(shooter)
end

local id = 0
local function getID()
    id = id + 1
    return id
end

local controlscomp = EntityGetFirstComponent(EntityGetRootEntity(entity_id), "ControlsComponent")
if controlscomp ~= nil then
    local angle_min = 10
    local angle_max = 170
    local remaining = canada_card.remaining
    local capacity = canada_card.capacity - 1
    local swidth, sheight = GuiGetScreenDimensions(Gui)
    local mraw_x, mraw_y = ComponentGetValue2(controlscomp, "mMousePositionRaw")
    local mouse_x, mouse_y = mraw_x * swidth / 1280, mraw_y * sheight / 720
    local image = "CANADA_PATHcanada_gfx/ammo_fill.png"
    local animation_tick = GameGetFrameNum() / 8

    -- twin linked stuff
    if ("arm_l" == EntityGetName(shooter)) then
        angle_min = angle_min + 180
        angle_max = angle_max + 180
        animation_tick = animation_tick + 4
    end

    for i = 0, capacity do
        if i + 1 == remaining then
            image = table.concat { "CANADA_PATHcanada_gfx/ammo_curnt_", (math.floor(animation_tick) % 3) + 1, ".png" }
        elseif i + 1 > remaining then
            image = "CANADA_PATHcanada_gfx/ammo_nonel.png"
        end

        local length = 15 + ((i % math.ceil(capacity / 10)) * 4)
        local image_w, image_h = GuiGetImageDimensions(Gui, image)
        local angle_range = angle_max - angle_min
        local angle = angle_min + (i / capacity * angle_range)
        local pip_x = math.cos(math.rad(angle)) * length
        local pip_y = math.sin(math.rad(angle)) * length

        GuiZSetForNextWidget(Gui, -100 - i)
        GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
        GuiImage(Gui, getID(),
            mouse_x + pip_x - (image_w / 2),
            mouse_y + pip_y - (image_h / 2),
            image, 1, 1, 1, 0
        )
    end
end

GuiIdPop(Gui)