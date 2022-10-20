return {
    init =
    --- ### Initializes Canada Lib, and sets up file paths.
    --- ***
    --- @param path string The file path where `CANADA_lib/` is located, within the mods folder. Example path would be `mods/mods/copis_gun/CANADA_lib`
    function(path)
        path = path:gsub("/$", "") .. "/"
        local files = {
            "canada_utils.lua",
            "canada_lib.lua",
            "canada_actions.lua"
        }
        for i, v in ipairs(files) do 
            local m = ModTextFileGetContent(path .. v)
            m = m:gsub("CANADA_PATH", path)
            ModTextFileSetContent(path .. v, m)
        end
    end
}