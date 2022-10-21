dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())

if canada_card.reload_on_empty then
    -- Auto ammo regen mode
    local recharge = true

    -- Don't recharge while shooting attribute
    if canada_card.ammo_system_recharge_while_shooting ~= true then
        local shooterControls = EntityGetFirstComponent(EntityGetRootEntity(GetUpdatedEntityID()), "ControlsComponent")
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

else
    -- enter lock state
    if canada_card.ammo_system_remaining == 0 then
        canada_card.ammo_system_locked = true
    end

    -- locked handler
    if canada_card.ammo_system_locked then
        -- lock wand
        local parent = EntityGetParent(GetUpdatedEntityID())
        local ability_comp = EntityGetFirstComponent(parent, "AbilityComponent" )
        if ability_comp ~= nil then
            ComponentSetValue2( ability_comp, "mNextFrameUsable", GameGetFrameNum() + 1 )
        end
        -- add ammo
        if GameGetFrameNum() % canada_card.ammo_system_recharge_time == 0 then
            canada_card.ammo_system_remaining = math.min(canada_card.ammo_system_remaining + 1, canada_card.ammo_system_capacity)
        end
        -- end lock state
        if canada_card.ammo_system_remaining == canada_card.ammo_system_capacity then
            canada_card.ammo_system_locked = false
            GlobalsSetValue("camada_lib_reload_frame", tostring(GameGetFrameNum()))
        end
    end
end
