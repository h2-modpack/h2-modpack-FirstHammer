local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
local chalk = mods['SGG_Modding-Chalk']
local reload = mods['SGG_Modding-ReLoad']
lib = mods['adamant-ModpackLib']

local dataDefaults = import("config.lua")
local config = chalk.auto('config.lua')

FirstHammerInternal = FirstHammerInternal or {}
local internal = FirstHammerInternal

public.definition = {
    id = "FirstHammer",
    name = "Hammer Selection",
    shortName = "Equiped Weapon Hammer",
    category = "Hammer Selection",
    tooltip = "Select the guaranteed first hammer for each weapon aspect.",
    default = dataDefaults.Enabled,
    affectsRunData = false,
    modpack = "speedrun",
}

import 'data.lua'

public.store = lib.createStore(config, public.definition, dataDefaults)
store = public.store

local loader = reload.auto_single()

local function init()
    import_as_fallback(rom.game)
    if internal.LocalizeHammerLabels then
        internal.LocalizeHammerLabels()
    end
    internal.RegisterHooks()
    if lib.isEnabled(store, public.definition.modpack) then
        lib.applyDefinition(public.definition, store)
    end
end

modutil.once_loaded.game(function()
    loader.load(init, init)
end)

local uiCallback = lib.standaloneUI(public.definition, store)
rom.gui.add_to_menu_bar(uiCallback)
