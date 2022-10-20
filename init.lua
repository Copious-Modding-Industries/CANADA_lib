return {
    init =
    --- ### Initializes Canada Lib, and sets up file paths.
    --- ***
    --- @param path string The file path where `CANADA_lib/` is located, within the mods folder. Example path would be `mods/copis_gun/CANADA_lib`
    function(path)
        path = path:gsub("/$", "") .. "/"
        local files = {
            "canada_utils.lua",
            "canada_lib.lua",
            "canada_actions.lua",
            "canada_display.lua",
            "canada_controller.lua"
        }
        for i, v in ipairs(files) do
            local m = ModTextFileGetContent(path .. v)
            if m ~= nil then
                m = m:gsub("CANADA_PATH", path)
                ModTextFileSetContent(path .. v, m)
            end
        end
    end
}
