local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
chalk = mods['SGG_Modding-Chalk']
reload = mods['SGG_Modding-ReLoad']
local lib = mods['adamant-Modpack_Lib']

config = chalk.auto('config.lua')
public.config = config

local backup, revert = lib.createBackupSystem()

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    id       = "FirstHammer",
    name     = "First Hammer Selection",
    tabLabel = "Hammers",
    category = "RunModifiers",
    group    = "Hammers",
    tooltip  = "Select the guaranteed first hammer for each weapon aspect.",
    default  = false,
    special  = true,
    dataMutation = false,
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
        if lib.isEnabled(config) then
            hasForcedHammerThisRun = false
        end
        return baseFunc(prevRun, args)
    end)

    modutil.mod.Path.Wrap("SetTraitsOnLoot", function(baseFunc, lootData, args)
        baseFunc(lootData, args)

        if not lib.isEnabled(config) then return end
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
        if not lib.isEnabled(config) then return baseFunc(args) end

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
-- UI RENDERING (exposed via public for adamant-core or standalone ImGui)
-- =============================================================================

local hasLocalizedLabels = false

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

--- Optional theme table (Core.Theme when hosted, nil when standalone).
--- Modules pick the keys they need, falling back to baked-in defaults.
local function DrawHammerDropdown(ui, aspectKey, displayLabel, staging, onChanged, theme)
    local data = hammerData[aspectKey]
    if not data then return end

    if not hasLocalizedLabels then
        BuildLocalizedLabels()
    end

    local labelOffset = (theme and theme.LABEL_OFFSET) or 0.25
    local fieldWidth  = (theme and theme.FIELD_MEDIUM)  or 0.4

    local currentId = staging.FirstHammers[aspectKey] or ""
    local currentIndex = 1
    for i, val in ipairs(data.values) do
        if val == currentId then
            currentIndex = i
            break
        end
    end

    local currentPreview = data.labels[currentIndex] or "None (Random)"

    ui.PushID(aspectKey)
    ui.Text(displayLabel)
    ui.SameLine()
    ui.SetCursorPosX(ui.GetWindowWidth() * labelOffset)
    ui.PushItemWidth(ui.GetWindowWidth() * fieldWidth)
    if ui.BeginCombo("##HammerCombo", currentPreview) then
        for i, txt in ipairs(data.labels) do
            local isSelected = (i == currentIndex)
            if ui.Selectable(txt, isSelected) then
                if i ~= currentIndex then
                    staging.FirstHammers[aspectKey] = data.values[i]
                    if onChanged then onChanged() end
                end
            end
        end
        ui.EndCombo()
    end
    ui.PopItemWidth()
    ui.PopID()
end

local function DrawQuickSelect(ui, staging, onChanged, theme)
    local currentWeapon = GetEquippedAspect()
    local weaponNameLabel = aspectLabels[currentWeapon] or "Unknown Weapon"

    if hammerData[currentWeapon] then
        DrawHammerDropdown(ui, currentWeapon, "Equipped: " .. weaponNameLabel, staging, onChanged, theme)
    end
end

local function DrawFullHammerTab(ui, staging, onChanged, theme)
    for _, weaponKey in ipairs(weaponDrawOrder) do
        local weaponDisplayName = weaponLabels[weaponKey] or weaponKey

        if ui.CollapsingHeader(weaponDisplayName) then
            ui.Indent()
            local aspects = WeaponAspectMapping[weaponKey]
            if aspects then
                for _, aspectKey in ipairs(aspects) do
                    local aspectDisplayName = aspectLabels[aspectKey] or aspectKey
                    DrawHammerDropdown(ui, aspectKey, aspectDisplayName, staging, onChanged, theme)
                end
            end
            ui.Unindent()
        end
    end
end

-- =============================================================================
-- STATE (staging driven by lib.createSpecialState, hashing by Core)
-- =============================================================================

-- Build stateSchema: one dropdown per aspect, nested under config.FirstHammers
public.definition.stateSchema = {}
for _, aspectKey in ipairs(aspectDrawOrder) do
    table.insert(public.definition.stateSchema, {
        type      = "dropdown",
        configKey = { "FirstHammers", aspectKey },
        values    = hammerData[aspectKey].values,
        bits      = 5,
        default   = "",
    })
end

local staging, snapshotStaging, syncToConfig =
    lib.createSpecialState(config, public.definition.stateSchema)

-- =============================================================================
-- PUBLIC API (generic special module contract)
-- =============================================================================

public.definition.apply = apply
public.definition.revert = revert

public.SnapshotStaging    = snapshotStaging
public.SyncToConfig       = syncToConfig

--- Draw the full tab content (Core renders the enable checkbox above this).
function public.DrawTab(imgui, onChanged, theme)
    imgui.Spacing()
    imgui.Text("Select the guaranteed first hammer for each aspect.")
    imgui.Spacing()
    DrawFullHammerTab(imgui, staging, onChanged, theme)
end

--- Draw quick-access content for the Quick Setup tab.
function public.DrawQuickContent(imgui, onChanged, theme)
    DrawQuickSelect(imgui, staging, onChanged, theme)
end

-- =============================================================================
-- Wiring
-- =============================================================================

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(function()
        import_as_fallback(rom.game)
        registerHooks()
        if lib.isEnabled(config) then apply() end
    end)
end)

-- =============================================================================
-- STANDALONE UI
-- =============================================================================

local showWindow = false

local function onStandaloneChanged()
    syncToConfig()
end

rom.gui.add_imgui(function()
    if mods['adamant-Modpack_Core'] then return end
    if not showWindow then return end

    if rom.ImGui.Begin("First Hammer Selection", true) then
        local val, chg = rom.ImGui.Checkbox("Enabled", config.Enabled)
        if chg then
            config.Enabled = val
            if val then apply() else revert() end
        end
        rom.ImGui.Separator()
        rom.ImGui.Spacing()
        DrawQuickSelect(rom.ImGui, staging, onStandaloneChanged)
        rom.ImGui.Spacing()
        rom.ImGui.Separator()
        rom.ImGui.Spacing()
        rom.ImGui.Text("Select the guaranteed first hammer for each aspect.")
        rom.ImGui.Spacing()
        DrawFullHammerTab(rom.ImGui, staging, onStandaloneChanged)
        rom.ImGui.End()
    else
        showWindow = false
    end
end)

rom.gui.add_to_menu_bar(function()
    if mods['adamant-Modpack_Core'] then return end
    if rom.ImGui.BeginMenu("adamant") then
        if rom.ImGui.MenuItem("First Hammer Selection") then
            showWindow = not showWindow
        end
        rom.ImGui.EndMenu()
    end
end)
