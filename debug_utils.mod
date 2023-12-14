return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`debug_utils` encountered an error loading the Darktide Mod Framework.")

		new_mod("debug_utils", {
			mod_script       = "debug_utils/scripts/mods/debug_utils/debug_utils",
			mod_data         = "debug_utils/scripts/mods/debug_utils/debug_utils_data",
			mod_localization = "debug_utils/scripts/mods/debug_utils/debug_utils_localization",
		})
	end,
	packages = {},
}
