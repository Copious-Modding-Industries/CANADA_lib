dofile_once("CANADA_PATHcanada_lib.lua")
--- ### Apply all needed components to a card entity file for minimal setup. Ideally, you should use this to minimize issues.
--- ***
--- @param card_entity_path string The file path of the card entity to modify
--- @param recharge_time integer Number of frames until ammo is added
--- @param capacity integer Maximum ammo card may have at once
--- @param initial_ammo integer Amount of ammo card will start with
--- @param recharge_while_shooting boolean Wether card can gain ammo while shooting or not
--- @param enabled_in_inventory boolean? If the canada scripts should be enabled when the wand is not being held. Default is false
--- @param controller_script_path? string Path to script used to control ammo, you likely do not want to mess with this unless you absolutely know what you're doing
--- @param display_script_path? string Path to script used when displaying ammo count
function RegisterCanadaAction(card_entity_path, recharge_time, capacity, initial_ammo, recharge_while_shooting, enabled_in_inventory, controller_script_path, display_script_path)
    -- If the world has been initialised, then ModEntityFileAddComponent won't work
    if ModTextFileSetContent == nil then
        error("RegisterCanadaAction: Actions can only be registered before world init", 2)
    end
    if card_entity_path == nil or recharge_time == nil or capacity == nil or initial_ammo == nil or recharge_while_shooting == nil then
        error("RegisterCanadaAction: Missing required parameter", 2)
    end
    --- Default scripts
    enabled_in_inventory = enabled_in_inventory or false
    display_script_path    = display_script_path or "CANADA_PATHcanada_display.lua"
    controller_script_path = controller_script_path or "CANADA_PATHcanada_controller.lua"

    --- Add components to card file contents
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_recharge_time", recharge_time))
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_capacity", capacity))
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_remaining", initial_ammo))
    ModEntityFileAddComponent(card_entity_path, GenerateVSC("ammo_system_recharge_while_shooting", recharge_while_shooting))
    ModEntityFileAddComponent(card_entity_path, ('<LuaComponent _tags="enabled_in_hand" execute_every_n_frame="1" script_source_file="%s" ></LuaComponent>'):format(display_script_path))
    ModEntityFileAddComponent(card_entity_path, ('<LuaComponent _tags="%s" execute_every_n_frame="1" script_source_file="%s" ></LuaComponent>'):format((enabled_in_inventory and "enabled_in_inventory" or "enabled_in_hand"), controller_script_path))
end

function CanadaGuiPostUpdate()
    GlobalsSetValue("canada_lib_display_iter", "0")
    GlobalsSetValue("canada_lib_display_iter_tl", "0")
end

--- ### Print a file path's contents
--- ***
--- @param file_path string The file path to print
function DebugModTextFilePrint(file_path)
    local contents = ModTextFileGetContent(file_path)
    print(contents)
end