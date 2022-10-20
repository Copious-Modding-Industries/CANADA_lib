dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())
local recharge = true

-- Don't recharge while shooting attribute
if canada_card.ammo_system_recharge_while_shooting ~= true then
    local shooterControls = EntityGetComponent(EntityGetRootEntity(GetUpdatedEntityID()), "ControlsComponent")
    if shooterControls then
        if ComponentGetValue2(shooterControls, "mButtonDownFire") then
            recharge = false
        end
    end
end

-- Ammo recharge time attribute
if GameGetFrameNum() % canada_card.ammo_system_recharge_time ~= 0 then
    recharge = false
end

-- Add ammo if possible
if recharge then
    canada_card.ammo_system_remaining = math.min(canada_card.ammo_system_remaining + 1, canada_card.ammo_system_capacity)
end