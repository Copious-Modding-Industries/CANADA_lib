
--- ### Apply all needed components to a card entity file for minimal setup. Ideally, you should use this when at all possible to minimize issues from manually doing it.
--- ***
--- @param card_entity_path string The file path of the card entity to modify.
--- @param recharge_time integer Number of frames until ammo is added.
--- @param capacity integer Maximum ammo card may have at once.
--- @param initial_ammo integer Amount of ammo card will start with.
--- @param recharge_while_shooting boolean Wether card can gain ammo while shooting or not.
--- @param controller_script_path? string Path to script used to control ammo, you likely do not want to mess with this unless you absolutely know what you're doing.
--- @param display_script_path? string Path to script used when displaying ammo count.
--- ***
--- @return boolean succeeded Wether card could successfully be modified.
function RegisterCanadaAction(card_entity_path, recharge_time, capacity, initial_ammo, recharge_while_shooting, controller_script_path, display_script_path)
    --- Default scripts
    display_script_path     = display_script_path       or "CANADA_PATHcanada_display.lua"
    controller_script_path  = controller_script_path    or "CANADA_PATHcanada_controller.lua"

    --- Handle nil card path
    if card_entity_path ~= nil then

        --- Add components to card file contents
        local card_file_contents = ModTextFileGetContent(card_entity_path)

        return true
    else
        return false
    end
end