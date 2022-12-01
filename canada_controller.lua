dofile_once("CANADA_PATHcanada_lib.lua")
--- @module "canada_lib"

local canada_card = CanadaCard(GetUpdatedEntityID())

if canada_card.reload_on_empty then

    -- enter lock state
    if canada_card.remaining == 0 then
        if not canada_card.reloading then

            -- enter lock state
            canada_card.reloading = true
            canada_card.reload_end_frame = GameGetFrameNum() + canada_card.recharge_time * canada_card.capacity
        else

            -- end lock state
            if GameGetFrameNum() == canada_card.reload_end_frame then
                canada_card.remaining = canada_card.capacity
                canada_card.reloading = false
                GlobalsSetValue("canada_lib_reload_frame", tostring(GameGetFrameNum()))
                if canada_card.reload_audio_bank ~= "" and canada_card.reload_audio_event then
                    GamePlaySound(canada_card.reload_audio_bank, canada_card.reload_audio_event, EntityGetTransform(EntityGetParent(GetUpdatedEntityID())))
                end
            end
        end
    else

        -- no clue why this works but if you change it the whole thing fucking implodes
        canada_card.reloading = false
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
