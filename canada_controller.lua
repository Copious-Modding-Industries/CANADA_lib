dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())
local recharge = true

-- Don't recharge while shooting attribute
if canada_card.recharge_while_shooting ~= true then
    local shooterControls = EntityGetFirstComponent(EntityGetRootEntity(GetUpdatedEntityID()), "ControlsComponent")
    if shooterControls then
        if ComponentGetValue2(shooterControls, "mButtonDownFire") then
            recharge = false
        end
    end
end

-- Ammo recharge time attribute
if GameGetFrameNum() % canada_card.recharge_time ~= 0 then
    recharge = false
end

-- Add ammo if possible
if recharge then
    canada_card.remaining = math.min(canada_card.remaining + 1, canada_card.capacity)
end