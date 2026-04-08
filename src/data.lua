local internal = FirstHammerInternal

internal.hammerData = {
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

internal.weaponLabels = {
    WeaponStaffSwing = "Staff",
    WeaponDagger = "Blades",
    WeaponAxe = "Axe",
    WeaponTorch = "Torch",
    WeaponLob = "Skull",
    WeaponSuit = "Coat",
}

internal.weaponDrawOrder = {
    "WeaponStaffSwing",
    "WeaponDagger",
    "WeaponAxe",
    "WeaponTorch",
    "WeaponLob",
    "WeaponSuit",
}

internal.aspectLabels = {
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

internal.weaponAspectMapping = {
    WeaponStaffSwing = { "BaseStaffAspect", "StaffClearCastAspect", "StaffSelfHitAspect", "StaffRaiseDeadAspect" },
    WeaponDagger = { "DaggerBackstabAspect", "DaggerHomingThrowAspect", "DaggerBlockAspect", "DaggerTripleAspect" },
    WeaponAxe = { "AxeRecoveryAspect", "AxeArmCastAspect", "AxePerfectCriticalAspect", "AxeRallyAspect" },
    WeaponTorch = { "TorchSpecialDurationAspect", "TorchSprintRecallAspect", "TorchDetonateAspect", "TorchAutofireAspect" },
    WeaponLob = { "LobAmmoBoostAspect", "LobCloseAttackAspect", "LobImpulseAspect", "LobGunAspect" },
    WeaponSuit = { "BaseSuitAspect", "SuitMarkCritAspect", "SuitHexAspect", "SuitComboAspect" },
}

local function AttachAspectHammerData()
    for weaponName, aspects in pairs(internal.weaponAspectMapping) do
        local baseWeaponData = internal.hammerData[weaponName]
        for _, aspectName in ipairs(aspects) do
            internal.hammerData[aspectName] = baseWeaponData
        end
    end
end

local function FinalizeWeaponHammerData()
    for _, weaponName in ipairs(internal.weaponDrawOrder) do
        local data = internal.hammerData[weaponName]
        data.valueIndex = {}
        data.displayValues = {}
        for i, v in ipairs(data.values) do
            data.valueIndex[v] = i
            if v == "" then
                data.displayValues[v] = "None (Random)"
            else
                data.displayValues[v] = v
            end
        end
    end
end

local function BuildDefinitionStorageAndUi()
    local storage = {}
    local ui = {}
    local dropdownGeometry = {
        slots = {
            { name = "control", start = 220, width = 400 },
        },
    }

    for _, weaponName in ipairs(internal.weaponDrawOrder) do
        local groupNode = {
            type = "group",
            label = internal.weaponLabels[weaponName] or weaponName,
            collapsible = true,
            defaultOpen = false,
            children = {},
        }

        for _, aspectName in ipairs(internal.weaponAspectMapping[weaponName] or {}) do
            local hammerOptions = internal.hammerData[aspectName]
            table.insert(storage, {
                type = "string",
                alias = aspectName,
                configKey = { "FirstHammers", aspectName },
                default = "",
            })
            table.insert(groupNode.children, {
                type = "dropdown",
                binds = { value = aspectName },
                quick = true,
                quickId = aspectName,
                label = internal.aspectLabels[aspectName] or aspectName,
                geometry = dropdownGeometry,
                values = hammerOptions.values,
                displayValues = hammerOptions.displayValues,
                tooltip = "Guaranteed first hammer for this aspect. Leave on None (Random) to keep vanilla behavior.",
            })
        end

        if #groupNode.children > 0 then
            table.insert(ui, groupNode)
        end
    end

    public.definition.storage = storage
    public.definition.ui = ui
end

AttachAspectHammerData()
FinalizeWeaponHammerData()
BuildDefinitionStorageAndUi()

function internal.LocalizeHammerLabels()
    if internal._hasLocalizedHammerLabels then
        return
    end
    for _, weaponName in ipairs(internal.weaponDrawOrder) do
        local data = internal.hammerData[weaponName]
        for _, internalString in ipairs(data.values) do
            if internalString ~= "" then
                local localizedName = GetDisplayName({ Text = internalString })
                data.displayValues[internalString] = localizedName or internalString
            end
        end
    end
    internal._hasLocalizedHammerLabels = true
end

function internal.GetEquippedAspect()
    return CurrentRun and CurrentRun.Hero
        and CurrentRun.Hero.SlottedTraits and CurrentRun.Hero.SlottedTraits.Aspect
        or "BaseStaffAspect"
end

local hasForcedHammerThisRun = false

public.definition.selectQuickUi = function()
    return { internal.GetEquippedAspect() }
end

function internal.RegisterHooks()
    modutil.mod.Path.Wrap("StartNewRun", function(baseFunc, prevRun, args)
        if lib.isEnabled(public.store, public.definition.modpack) then
            hasForcedHammerThisRun = false
        end
        return baseFunc(prevRun, args)
    end)

    modutil.mod.Path.Wrap("SetTraitsOnLoot", function(baseFunc, lootData, args)
        baseFunc(lootData, args)

        if not lib.isEnabled(public.store, public.definition.modpack) then return end
        if lootData.Name ~= "WeaponUpgrade" or hasForcedHammerThisRun then return end

        local currentWeapon = internal.GetEquippedAspect()
        local desiredHammer = store.read(currentWeapon)

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
        if not lib.isEnabled(public.store, public.definition.modpack) then return baseFunc(args) end

        local traitName = args.TraitData and args.TraitData.Name
        if traitName then
            local currentWeapon = internal.GetEquippedAspect()
            local desiredHammer = store.read(currentWeapon)
            if desiredHammer == traitName then
                hasForcedHammerThisRun = true
            end
        end

        return baseFunc(args)
    end)
end
