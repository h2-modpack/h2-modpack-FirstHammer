local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
chalk = mods['SGG_Modding-Chalk']
reload = mods['SGG_Modding-ReLoad']
local lib = mods['adamant-ModpackLib']

config = chalk.auto('config.lua')
public.config = config

local ImGuiCol = rom.ImGuiCol

local _, revert = lib.createBackupSystem()

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    id            = "FirstHammer",
    name          = "First Hammer Selection",
    tabLabel      = "Hammers",
    category      = "Run Modifiers",
    group         = "Hammers",
    tooltip       = "Select the guaranteed first hammer for each weapon aspect.",
    default       = false,
    special       = true,
    dataMutation  = false,
    modpack = "speedrun",
    -- stateSchema is set below after data tables are built
}

-- =============================================================================
-- WEAPON & ASPECT DATA
-- =============================================================================

local hammerData = {
    WeaponStaffSwing = {
        values = {
            "",
            "StaffDoubleAttackTrait",
            "StaffLongAttackTrait",
            "StaffDashAttackTrait",
            "StaffTripleShotTrait",
            "StaffJumpSpecialTrait",
            "StaffExAoETrait",
            "StaffAttackRecoveryTrait",
            "StaffFastSpecialTrait",
            "StaffExHealTrait",
            "StaffSecondStageTrait",
            "StaffPowershotTrait",
            "StaffOneWayAttackTrait",
            "StaffRaiseDeadBigTrait",
            "StaffRaiseDeadDoubleTrait",
            "StaffLoneShadeRespawnTrait",
            "StaffLoneShadeRallyTrait",
        },
    },
    WeaponDagger = {
        values = {
            "",
            "DaggerBlinkAoETrait",
            "DaggerSpecialJumpTrait",
            "DaggerSpecialLineTrait",
            "DaggerRapidAttackTrait",
            "DaggerSpecialConsecutiveTrait",
            "DaggerBackstabTrait",
            "DaggerSpecialReturnTrait",
            "DaggerSpecialFanTrait",
            "DaggerAttackFinisherTrait",
            "DaggerFinalHitTrait",
            "DaggerChargeStageSkipTrait",
            "DaggerDashAttackTripleTrait",
            "DaggerTripleBuffTrait",
            "DaggerTripleRepeatWomboTrait",
            "DaggerTripleHomingSpecialTrait",
        },
    },
    WeaponAxe = {
        values = {
            "",
            "AxeSpinSpeedTrait",
            "AxeChargedSpecialTrait",
            "AxeAttackRecoveryTrait",
            "AxeMassiveThirdStrikeTrait",
            "AxeThirdStrikeTrait",
            "AxeRangedWhirlwindTrait",
            "AxeFreeSpinTrait",
            "AxeArmorTrait",
            "AxeBlockEmpowerTrait",
            "AxeSecondStageTrait",
            "AxeDashAttackTrait",
            "AxeSturdyTrait",
            "AxeRallyFrenzyTrait",
            "AxeRallyFirstStrikeTrait",
        },
    },
    WeaponTorch = {
        values = {
            "",
            "TorchExSpecialCountTrait",
            "TorchSpecialSpeedTrait",
            "TorchAttackSpeedTrait",
            "TorchSpecialLineTrait",
            "TorchSpecialImpactTrait",
            "TorchMoveSpeedTrait",
            "TorchSplitAttackTrait",
            "TorchEnhancedAttackTrait",
            "TorchDiscountExAttackTrait",
            "TorchLongevityTrait",
            "TorchOrbitPointTrait",
            "TorchSpinAttackTrait",
            "TorchAutofireSprintTrait",
        },
    },
    WeaponLob = {
        values = {
            "",
            "LobAmmoTrait",
            "LobAmmoMagnetismTrait",
            "LobRushArmorTrait",
            "LobSpreadShotTrait",
            "LobSpecialSpeedTrait",
            "LobSturdySpecialTrait",
            "LobOneSideTrait",
            "LobInOutSpecialExTrait",
            "LobStraightShotTrait",
            "LobPulseAmmoTrait",
            "LobPulseAmmoCollectTrait",
            "LobGrowthTrait",
            "LobGunOverheatTrait",
            "LobGunBounceTrait",
            "LobGunSpecialBounceTrait",
            "LobGunAttackRangeTrait",
            "LobGunAttackDoublerTrait",
        },
    },
    WeaponSuit = {
        values = {
            "",
            "SuitArmorTrait",
            "SuitAttackSpeedTrait",
            "SuitAttackSizeTrait",
            "SuitAttackRangeTrait",
            "SuitFullChargeTrait",
            "SuitDashAttackTrait",
            "SuitSpecialJumpTrait",
            "SuitSpecialStartUpTrait",
            "SuitSpecialAutoTrait",
            "SuitSpecialBlockTrait",
            "SuitSpecialDiscountTrait",
            "SuitSpecialConsecutiveHitTrait",
            "SuitComboForwardRocketTrait",
            "SuitComboBlockBuffTrait",
            "SuitComboDoubleSpecialTrait",
            "SuitComboDashAttackTrait",
            "SuitPowershotTrait",
        },
    },
}

local weaponLabels = {
    WeaponStaffSwing = "Staff",
    WeaponDagger = "Blades",
    WeaponAxe = "Axe",
    WeaponTorch = "Torch",
    WeaponLob = "Skull",
    WeaponSuit = "Coat",
}

local weaponDrawOrder = {
    "WeaponStaffSwing",
    "WeaponDagger",
    "WeaponAxe",
    "WeaponTorch",
    "WeaponLob",
    "WeaponSuit",
}

local aspectLabels = {
    BaseStaffAspect = "Mel Staff",
    StaffClearCastAspect = "Circe",
    StaffSelfHitAspect = "Momus",
    StaffRaiseDeadAspect = "Anubis",

    DaggerBackstabAspect = "Mel Blades",
    DaggerHomingThrowAspect = "Pan",
    DaggerBlockAspect = "Artemis",
    DaggerTripleAspect = "The Morrigan",

    LobAmmoBoostAspect = "Mel Skull",
    LobCloseAttackAspect = "Medea",
    LobImpulseAspect = "Persephone",
    LobGunAspect = "Hel",

    AxeRecoveryAspect = "Mel Axe",
    AxeArmCastAspect = "Charon",
    AxePerfectCriticalAspect = "Thanatos",
    AxeRallyAspect = "Nergal",

    TorchSpecialDurationAspect = "Mel Torch",
    TorchSprintRecallAspect = "Eos",
    TorchDetonateAspect = "Moros",
    TorchAutofireAspect = "Supay",

    BaseSuitAspect = "Mel Coat",
    SuitMarkCritAspect = "Nyx",
    SuitHexAspect = "Selene",
    SuitComboAspect = "Shiva",
}

local WeaponAspectMapping = {
    WeaponStaffSwing = { "BaseStaffAspect", "StaffClearCastAspect", "StaffSelfHitAspect", "StaffRaiseDeadAspect" },
    WeaponDagger = { "DaggerBackstabAspect", "DaggerHomingThrowAspect", "DaggerBlockAspect", "DaggerTripleAspect" },
    WeaponAxe = { "AxeRecoveryAspect", "AxeArmCastAspect", "AxePerfectCriticalAspect", "AxeRallyAspect" },
    WeaponTorch = { "TorchSpecialDurationAspect", "TorchSprintRecallAspect", "TorchDetonateAspect", "TorchAutofireAspect" },
    WeaponLob = { "LobAmmoBoostAspect", "LobCloseAttackAspect", "LobImpulseAspect", "LobGunAspect" },
    WeaponSuit = { "BaseSuitAspect", "SuitMarkCritAspect", "SuitHexAspect", "SuitComboAspect" },
}

-- Propagate base weapon hammer data to each aspect
for weaponName, aspects in pairs(WeaponAspectMapping) do
    local baseWeaponData = hammerData[weaponName]
    for _, aspectName in ipairs(aspects) do
        hammerData[aspectName] = baseWeaponData
    end
end

-- Build a flat ordered list of all aspects
local aspectDrawOrder = {}
for _, weaponName in ipairs(weaponDrawOrder) do
    local aspects = WeaponAspectMapping[weaponName]
    if aspects then
        for _, aspectName in ipairs(aspects) do
            table.insert(aspectDrawOrder, aspectName)
        end
    end
end

-- =============================================================================
-- UTILITY
-- =============================================================================

local function GetEquippedAspect()
    local currentWeapon = CurrentRun and CurrentRun.Hero
        and CurrentRun.Hero.SlottedTraits and CurrentRun.Hero.SlottedTraits.Aspect or "BaseStaffAspect"
    return currentWeapon
end

-- =============================================================================
-- MODULE LOGIC
-- =============================================================================

local hasForcedHammerThisRun = false

local function apply()
end

local function registerHooks()
    modutil.mod.Path.Wrap("StartNewRun", function(baseFunc, prevRun, args)
        if lib.isEnabled(config, public.definition.modpack) then
            hasForcedHammerThisRun = false
        end
        return baseFunc(prevRun, args)
    end)

    modutil.mod.Path.Wrap("SetTraitsOnLoot", function(baseFunc, lootData, args)
        baseFunc(lootData, args)

        if not lib.isEnabled(config, public.definition.modpack) then return end
        if lootData.Name ~= "WeaponUpgrade" or hasForcedHammerThisRun then return end

        local currentWeapon = GetEquippedAspect()
        local desiredHammer = config.FirstHammers[currentWeapon]

        if desiredHammer and desiredHammer ~= "" then
            local traitData = TraitData[desiredHammer]
            if traitData and IsTraitEligible(traitData, args) then
                lootData.UpgradeOptions = {
                    { ItemName = desiredHammer, Type = "Trait" }
                }
            end
        end
    end)

    modutil.mod.Path.Wrap("AddTraitToHero", function(baseFunc, args)
        args = args or {}
        if not lib.isEnabled(config, public.definition.modpack) then return baseFunc(args) end

        local traitName = args.TraitData and args.TraitData.Name
        if traitName then
            local currentWeapon = GetEquippedAspect()
            local desiredHammer = config.FirstHammers[currentWeapon]
            if desiredHammer == traitName then
                hasForcedHammerThisRun = true
            end
        end

        return baseFunc(args)
    end)
end

-- =============================================================================
-- UI RENDERING (exposed via public for coordinator or standalone ImGui)
-- =============================================================================

local DEFAULT_LABEL_OFFSET = 0.25
local DEFAULT_FIELD_MEDIUM = 0.4

local hasLocalizedLabels   = false

local function BuildLocalizedLabels()
    for _, data in pairs(hammerData) do
        data.labels = {}
        for i, internalString in ipairs(data.values) do
            if internalString == "" then
                data.labels[i] = "None (Random)"
            else
                local localizedName = GetDisplayName({ Text = internalString })
                data.labels[i] = localizedName or internalString
            end
        end
    end
    hasLocalizedLabels = true
end

-- labelOffset and fieldMedium are pre-unpacked by the caller (no theme param).
local function DrawHammerDropdown(ui, aspectKey, displayLabel, specialState, labelOffset, fieldMedium)
    local data = hammerData[aspectKey]
    if not data then return end
    if not hasLocalizedLabels then BuildLocalizedLabels() end

    local currentId = specialState.view.FirstHammers[aspectKey] or ""
    local currentIndex = 1
    for i, val in ipairs(data.values) do
        if val == currentId then
            currentIndex = i; break
        end
    end
    local currentPreview = data.labels[currentIndex] or "None (Random)"

    ui.PushID(aspectKey)
    ui.Text(displayLabel)
    ui.SameLine()
    ui.SetCursorPosX(ui.GetWindowWidth() * labelOffset)
    ui.PushItemWidth(ui.GetWindowWidth() * fieldMedium)
    if ui.BeginCombo("##HammerCombo", currentPreview) then
        for i, txt in ipairs(data.labels) do
            if ui.Selectable(txt, i == currentIndex) then
                if i ~= currentIndex then
                    specialState.set({ "FirstHammers", aspectKey }, data.values[i])
                end
            end
        end
        ui.EndCombo()
    end
    ui.PopItemWidth()
    ui.PopID()
end

-- headerColor is nil when no theme is active (uses current ImGuiCol.Text as-is).
local function DrawFullHammerTab(ui, specialState, headerColor, labelOffset, fieldMedium)
    for _, weaponKey in ipairs(weaponDrawOrder) do
        local weaponDisplayName = weaponLabels[weaponKey] or weaponKey
        ui.PushStyleColor(ImGuiCol.Text, table.unpack(headerColor))
        local open = ui.CollapsingHeader(weaponDisplayName)
        ui.PopStyleColor()
        if open then
            ui.Indent()
            for _, aspectKey in ipairs(WeaponAspectMapping[weaponKey] or {}) do
                DrawHammerDropdown(ui, aspectKey, aspectLabels[aspectKey] or aspectKey, specialState, labelOffset,
                    fieldMedium)
            end
            ui.Unindent()
        end
    end
end

local function DrawQuickSelect(ui, specialState, labelOffset, fieldMedium)
    local currentWeapon = GetEquippedAspect()
    local weaponNameLabel = aspectLabels[currentWeapon] or "Unknown Weapon"
    if hammerData[currentWeapon] then
        DrawHammerDropdown(ui, currentWeapon, "Equipped: " .. weaponNameLabel, specialState, labelOffset,
            fieldMedium)
    end
end

-- =============================================================================
-- STATE (managed special state driven by lib.createSpecialState, hashing by Core)
-- =============================================================================

-- Build stateSchema: one dropdown per aspect, nested under config.FirstHammers
public.definition.stateSchema = {}
for _, aspectKey in ipairs(aspectDrawOrder) do
    table.insert(public.definition.stateSchema, {
        type      = "dropdown",
        configKey = { "FirstHammers", aspectKey },
        values    = hammerData[aspectKey].values,
        default   = "",
    })
end

local managedSpecialState = lib.createSpecialState(config, public.definition.stateSchema)

-- =============================================================================
-- PUBLIC API (generic special module contract)
-- =============================================================================

public.definition.apply                      = apply
public.definition.revert                     = revert
public.specialState                          = managedSpecialState

--- Draw the full tab content (Core renders the enable checkbox above this).
function public.DrawTab(ui, specialState, theme)
    local colors      = theme and theme.colors
    local headerColor = (colors and colors.info) or { 1, 1, 1, 1 }
    local fieldMedium = (theme and theme.FIELD_MEDIUM) or DEFAULT_FIELD_MEDIUM
    ui.Spacing()
    ui.TextColored(headerColor[1], headerColor[2], headerColor[3], headerColor[4],
        "Select the guaranteed first hammer for each aspect.")
    ui.Spacing()
    DrawFullHammerTab(ui, specialState, headerColor, DEFAULT_LABEL_OFFSET, fieldMedium)
end

--- Draw quick-access content for the Quick Setup tab.
function public.DrawQuickContent(ui, specialState, theme)
    local fieldMedium = (theme and theme.FIELD_MEDIUM) or DEFAULT_FIELD_MEDIUM
    DrawQuickSelect(ui, specialState, DEFAULT_LABEL_OFFSET, fieldMedium)
end

-- =============================================================================
-- Wiring
-- =============================================================================

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(function()
        import_as_fallback(rom.game)
        registerHooks()
        if lib.isEnabled(config, public.definition.modpack) then apply() end
    end)
end)

-- =============================================================================
-- STANDALONE UI
-- =============================================================================

local showWindow = false

local function warnIfStandaloneBypassedState(before)
    lib.warnIfSpecialConfigBypassedState(
        public.definition.name,
        config.DebugMode,
        public.specialState,
        config,
        public.definition.stateSchema,
        before
    )
end

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_imgui(function()
    if lib.isCoordinated(public.definition.modpack) then return end
    if not showWindow then return end

    if rom.ImGui.Begin("First Hammer Selection", true) then
        local val, chg = rom.ImGui.Checkbox("Enabled", config.Enabled)
        if chg then
            config.Enabled = val
            if val then apply() else revert() end
        end
        rom.ImGui.Separator()
        rom.ImGui.Spacing()
        local beforeQuick = lib.captureSpecialConfigSnapshot(config, public.definition.stateSchema)
        public.DrawQuickContent(rom.ImGui, public.specialState, nil)
        warnIfStandaloneBypassedState(beforeQuick)
        if public.specialState.isDirty() then public.specialState.flushToConfig() end
        rom.ImGui.Spacing()
        rom.ImGui.Separator()
        local beforeTab = lib.captureSpecialConfigSnapshot(config, public.definition.stateSchema)
        public.DrawTab(rom.ImGui, public.specialState, nil)
        warnIfStandaloneBypassedState(beforeTab)
        if public.specialState.isDirty() then public.specialState.flushToConfig() end
        rom.ImGui.End()
    else
        showWindow = false
    end
end)

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_to_menu_bar(function()
    if lib.isCoordinated(public.definition.modpack) then return end
    if rom.ImGui.BeginMenu("adamant") then
        if rom.ImGui.MenuItem("First Hammer Selection") then
            showWindow = not showWindow
        end
        rom.ImGui.EndMenu()
    end
end)
