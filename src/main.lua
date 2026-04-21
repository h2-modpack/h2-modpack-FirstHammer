local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
local chalk = mods['SGG_Modding-Chalk']
local reload = mods['SGG_Modding-ReLoad']
---@type AdamantModpackLib
lib = mods['adamant-ModpackLib']

local dataDefaults = import("config.lua")
local config = chalk.auto('config.lua')

---@class FirstHammerInternal
---@field store ManagedStore|nil
---@field standaloneUi StandaloneRuntime|nil
---@field RegisterHooks fun()|nil
---@field DrawTab fun(imgui: table, session: AuthorSession)|nil
---@field DrawQuickContent fun(imgui: table, session: AuthorSession)|nil
---@field LocalizeHammerLabels fun()|nil
FirstHammerInternal = FirstHammerInternal or {}
---@type FirstHammerInternal
local internal = FirstHammerInternal

public.definition = {
    id             = "FirstHammer",
    name           = "Hammer Selection",
    shortName      = "Hammer Selection",
    tooltip        = "Select the guaranteed first hammer for each weapon aspect.",
    default        = dataDefaults.Enabled,
    affectsRunData = false,
    modpack        = "speedrun",
}

public.host = nil
local store
local session
internal.standaloneUi = nil

local loader = reload.auto_single()

local function init()
    import_as_fallback(rom.game)
    import("data.lua")
    import("logic.lua")
    import("ui.lua")

    store, session = lib.createStore(config, public.definition, dataDefaults)
    internal.store = store

    if internal.LocalizeHammerLabels then
        internal.LocalizeHammerLabels()
    end
    public.host = lib.createModuleHost({
        definition = public.definition,
        store = store,
        session = session,
        hookOwner = internal,
        registerHooks = internal.RegisterHooks,
        drawTab = internal.DrawTab,
        drawQuickContent = internal.DrawQuickContent,
    })
    internal.standaloneUi = lib.standaloneHost(public.host)
end

modutil.once_loaded.game(function()
    loader.load(nil, init)
end)

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_imgui(function()
    if internal.standaloneUi and internal.standaloneUi.renderWindow then
        internal.standaloneUi.renderWindow()
    end
end)

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_to_menu_bar(function()
    if internal.standaloneUi and internal.standaloneUi.addMenuBar then
        internal.standaloneUi.addMenuBar()
    end
end)
