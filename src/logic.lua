local internal = FirstHammerInternal

function internal.LocalizeHammerLabels()
    for _, weaponName in ipairs(internal.weaponDrawOrder) do
        local data = internal.hammerData[weaponName]
        for _, internalString in ipairs(data.values) do
            if internalString ~= "" then
                local traitData = TraitData and TraitData[internalString] or nil
                local textKey = traitData and traitData.Name or internalString
                local localizedName = game.GetDisplayName({ Text = textKey })
                data.displayValues[internalString] = localizedName or internalString
            end
        end
    end
end

function internal.GetEquippedAspect()
    return CurrentRun and CurrentRun.Hero
        and CurrentRun.Hero.SlottedTraits and CurrentRun.Hero.SlottedTraits.Aspect
        or "BaseStaffAspect"
end

local hasForcedHammerThisRun = false

function internal.RegisterHooks()
    lib.hooks.Wrap(internal, "StartNewRun", function(baseFunc, prevRun, args)
        if lib.isModuleEnabled(internal.store, public.definition.modpack) then
            hasForcedHammerThisRun = false
        end
        return baseFunc(prevRun, args)
    end)

    lib.hooks.Wrap(internal, "SetTraitsOnLoot", function(baseFunc, lootData, args)
        baseFunc(lootData, args)

        if not lib.isModuleEnabled(internal.store, public.definition.modpack) then return end
        if lootData.Name ~= "WeaponUpgrade" or hasForcedHammerThisRun then return end

        local currentWeapon = internal.GetEquippedAspect()
        local desiredHammer = internal.store.read(currentWeapon)

        if desiredHammer and desiredHammer ~= "" then
            local traitData = TraitData[desiredHammer]
            if traitData and IsTraitEligible(traitData, args) then
                lootData.UpgradeOptions = {
                    { ItemName = desiredHammer, Type = "Trait" }
                }
            end
        end
    end)

    lib.hooks.Wrap(internal, "AddTraitToHero", function(baseFunc, args)
        args = args or {}
        if not lib.isModuleEnabled(internal.store, public.definition.modpack) then return baseFunc(args) end

        local traitName = args.TraitData and args.TraitData.Name
        if traitName then
            local currentWeapon = internal.GetEquippedAspect()
            local desiredHammer = internal.store.read(currentWeapon)
            if desiredHammer == traitName then
                hasForcedHammerThisRun = true
            end
        end

        return baseFunc(args)
    end)
end

return internal
