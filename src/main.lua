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
local config = chalk.auto('config.lua')

FirstHammerInternal = FirstHammerInternal or {}
local internal = FirstHammerInternal
internal.ImGuiCol = rom.ImGuiCol

public.definition = {
    id = "FirstHammer",
    name = "First Hammer Selection",
    tabLabel = "Hammers",
    category = "Run Modifiers",
    group = "Hammers",
    tooltip = "Select the guaranteed first hammer for each weapon aspect.",
    default = false,
    special = true,
    affectsRunData = false,
    modpack = "speedrun",
}

import 'data.lua'
import 'ui.lua'

public.store = lib.createStore(config, public.definition)
store = public.store

local loader = reload.auto_single()

local function init()
    import_as_fallback(rom.game)
    internal.RegisterHooks()
    if lib.isEnabled(store, public.definition.modpack) then
        lib.applyDefinition(public.definition, store)
    end
end

modutil.once_loaded.game(function()
    loader.load(init, init)
end)

local standalone = lib.standaloneSpecialUI(public.definition, store, store.uiState, {
    getDrawQuickContent = function()
        return public.DrawQuickContent
    end,
    getDrawTab = function()
        return public.DrawTab
    end,
})

rom.gui.add_imgui(standalone.renderWindow)
rom.gui.add_to_menu_bar(standalone.addMenuBar)
