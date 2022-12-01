dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())

if canada_card.reload_on_empty then
    -- enter lock state
    if canada_card.remaining == 0 then
        canada_card.reloading = true
    end

    -- locked handler
    if canada_card.reloading then
        -- lock wand
        local parent = EntityGetParent(GetUpdatedEntityID())
        local ability_comp = EntityGetFirstComponent(parent, "AbilityComponent" )
        if ability_comp ~= nil then
            ComponentSetValue2( ability_comp, "mNextFrameUsable", GameGetFrameNum() + 1 )
        end
        -- add ammo
        if GameGetFrameNum() % canada_card.recharge_time == 0 then
            canada_card.remaining = math.min(canada_card.remaining + 1, canada_card.capacity)
        end
        -- end lock state
        if canada_card.remaining == canada_card.capacity then
            canada_card.reloading = false
            GlobalsSetValue("canada_lib_reload_frame", tostring(GameGetFrameNum()))
        end
    end
else
    -- Auto ammo regen mode
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

end
