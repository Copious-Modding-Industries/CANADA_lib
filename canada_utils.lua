--- Apply all needed components to a card entity file for minimal setup. Ideally, you should use this to minimize issues.
--- @param card_entity_path string The file path of the card entity to modify
--- @param recharge_time integer Number of frames until ammo is added
--- @param capacity integer Maximum ammo card may have at once
--- @param initial_ammo integer Amount of ammo card will start with
--- @param recharge_while_shooting boolean Wether card can gain ammo while shooting or not
--- @param controller_script_path? string Path to script used to control ammo, you likely do not want to mess with this unless you absolutely know what you're doing
--- @param display_script_path? string Path to script used when displaying ammo count
--- @return boolean succeeded Wether card could successfully be modified
function RegisterCanadaAction(card_entity_path, recharge_time, capacity, initial_ammo, recharge_while_shooting, controller_script_path, display_script_path)
    -- If the world has been initialised, then ModEntityFileAddComponent won't work
    if ModTextFileSetContent == nil then
        error("RegisterCanadaAction: Actions can only be registered before world init", 2)
    end
    if card_entity_path == nil or recharge_time == nil or capacity == nil or initial_ammo == nil or recharge_while_shooting == nil then 
        error("RegisterCanadaAction: Missing required parameter", 2)
    end
    --- Default scripts
    display_script_path    = display_script_path or "CANADA_PATHcanada_display.lua"
    controller_script_path = controller_script_path or "CANADA_PATHcanada_controller.lua"

    --- Add components to card file contents
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_recharge_time", recharge_time))
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_capacity", capacity))
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_remaining", initial_ammo))
    ModEntityFileAddComponent(card_entity_path,
        GenerateVSC("ammo_system_recharge_while_shooting", recharge_while_shooting))
    return true
end