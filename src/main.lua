-- =============================================================================
-- BOILERPLATE (do not modify)
-- =============================================================================

local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
chalk = mods['SGG_Modding-Chalk']
reload = mods['SGG_Modding-ReLoad']

config = chalk.auto('config.lua')
public.config = config

local NIL = {}
local backups = {}

local function backup(tbl, key)
    if not backups[tbl] then backups[tbl] = {} end
    if backups[tbl][key] == nil then
        local v = tbl[key]
        backups[tbl][key] = v == nil and NIL or (type(v) == "table" and DeepCopyTable(v) or v)
    end
end

local function restore()
    for tbl, keys in pairs(backups) do
        for key, v in pairs(keys) do
            tbl[key] = v == NIL and nil or (type(v) == "table" and DeepCopyTable(v) or v)
        end
    end
end

local function isEnabled()
    return config.Enabled
end

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    id       = "FirstHammer",
    name     = "First Hammer Selection",
    category = "RunModifiers",
    group    = "Hammers",
    tooltip  = "Select the guaranteed first hammer for each weapon aspect.",
    default  = false,
    special  = true,  -- signals to adamant-core: not a boolean toggle
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

local function disable()
    restore()
end

local function registerHooks()
    -- Reset forced hammer flag at start of each run
    modutil.mod.Path.Wrap("StartNewRun", function(baseFunc, prevRun, args)
        if isEnabled() then
            hasForcedHammerThisRun = false
        end
        return baseFunc(prevRun, args)
    end)

    -- Force the configured hammer as the only option on first weapon upgrade
    modutil.mod.Path.Wrap("SetTraitsOnLoot", function(baseFunc, lootData, args)
        baseFunc(lootData, args)

        if not isEnabled() then return end
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

    -- Lock out after granting the forced hammer
    modutil.mod.Path.Wrap("AddTraitToHero", function(baseFunc, args)
        args = args or {}
        if not isEnabled() then return baseFunc(args) end

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

--- Draw a single aspect's hammer dropdown.
--- @param ui table ImGui handle
--- @param aspectKey string The aspect trait name
--- @param displayLabel string Label shown next to the dropdown
--- @param staging table The staging table to read/write FirstHammers from
--- @param onChanged function|nil Optional callback when selection changes
local function DrawHammerDropdown(ui, aspectKey, displayLabel, staging, onChanged)
    local data = hammerData[aspectKey]
    if not data then return end

    if not hasLocalizedLabels then
        BuildLocalizedLabels()
    end

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
    ui.SetCursorPosX(ui.GetWindowWidth() * 0.25)
    ui.PushItemWidth(ui.GetWindowWidth() * 0.4)
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

--- Draw the quick hammer select for current equipped aspect.
--- @param ui table ImGui handle
--- @param staging table Staging table with FirstHammers
--- @param onChanged function|nil Callback on change
local function DrawQuickSelect(ui, staging, onChanged)
    local currentWeapon = GetEquippedAspect()
    local weaponNameLabel = aspectLabels[currentWeapon] or "Unknown Weapon"

    if hammerData[currentWeapon] then
        DrawHammerDropdown(ui, currentWeapon, "Equipped: " .. weaponNameLabel, staging, onChanged)
    end
end

--- Draw the full hammer selection tab content (all weapons, all aspects).
--- @param ui table ImGui handle
--- @param staging table Staging table with FirstHammers
--- @param onChanged function|nil Callback on change
local function DrawFullHammerTab(ui, staging, onChanged)
    ui.Spacing()
    ui.Text("Select the guaranteed first hammer for each aspect.")
    ui.Spacing()

    for _, weaponKey in ipairs(weaponDrawOrder) do
        local weaponDisplayName = weaponLabels[weaponKey] or weaponKey

        if ui.CollapsingHeader(weaponDisplayName) then
            ui.Indent()
            local aspects = WeaponAspectMapping[weaponKey]
            if aspects then
                for _, aspectKey in ipairs(aspects) do
                    local aspectDisplayName = aspectLabels[aspectKey] or aspectKey
                    DrawHammerDropdown(ui, aspectKey, aspectDisplayName, staging, onChanged)
                end
            end
            ui.Unindent()
        end
    end
    ui.Spacing()
end

-- =============================================================================
-- PUBLIC API
-- =============================================================================

public.definition.enable = function()
    apply()
end

public.definition.disable = function()
    disable()
end

-- Expose data and UI functions for adamant-core to consume
public.hammerData = hammerData
public.aspectDrawOrder = aspectDrawOrder
public.aspectLabels = aspectLabels
public.weaponLabels = weaponLabels
public.weaponDrawOrder = weaponDrawOrder
public.WeaponAspectMapping = WeaponAspectMapping

public.DrawQuickSelect = DrawQuickSelect
public.DrawFullHammerTab = DrawFullHammerTab
public.DrawHammerDropdown = DrawHammerDropdown
public.GetEquippedAspect = GetEquippedAspect

-- =============================================================================
-- LIFECYCLE (do not modify)
-- =============================================================================

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(function()
        import_as_fallback(rom.game)
        registerHooks()
        if config.Enabled then apply() end
    end)
end)

-- =============================================================================
-- STANDALONE UI
-- =============================================================================
-- When adamant-core is NOT installed, renders its own ImGui window with
-- enable toggle + full hammer dropdown UI.
-- When adamant-core IS installed, the core handles UI — this is skipped.

local imgui = rom.ImGui

local showWindow = false

-- Standalone staging writes directly to config (no batch commit needed)
local standaloneStaging = { FirstHammers = config.FirstHammers }

local function onStandaloneChanged()
    -- FirstHammers table is shared by reference, so changes are already in config
end

rom.gui.add_imgui(function()
    if mods['adamant-Core'] then return end
    if not showWindow then return end

    if imgui.Begin("First Hammer Selection", true) then
        local val, chg = imgui.Checkbox("Enabled", config.Enabled)
        if chg then
            config.Enabled = val
            if val then apply() else disable() end
        end
        if imgui.IsItemHovered() then
            imgui.SetTooltip(public.definition.tooltip)
        end

        imgui.Separator()
        imgui.Spacing()

        DrawQuickSelect(imgui, standaloneStaging, onStandaloneChanged)

        imgui.Spacing()
        imgui.Separator()

        DrawFullHammerTab(imgui, standaloneStaging, onStandaloneChanged)

        imgui.End()
    else
        showWindow = false
    end
end)

rom.gui.add_to_menu_bar(function()
    if mods['adamant-Core'] then return end
    if imgui.BeginMenu("adamant") then
        if imgui.MenuItem("First Hammer") then
            showWindow = not showWindow
        end
        imgui.EndMenu()
    end
end)
