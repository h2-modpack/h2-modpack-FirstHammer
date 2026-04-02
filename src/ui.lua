local internal = FirstHammerInternal
local ImGuiCol = internal.ImGuiCol

local DEFAULT_LABEL_OFFSET = 0.25
local DEFAULT_FIELD_MEDIUM = 0.4
local DEFAULT_HEADER_COLOR = { 1, 1, 1, 1 }

local hasLocalizedLabels = false
local lastEquippedAspect = nil
local lastEquippedLabel = nil

local function BuildLocalizedLabels()
    for _, data in pairs(internal.hammerData) do
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

local function DrawHammerDropdown(ui, aspectKey, displayLabel, uiState, labelOffset, fieldMedium)
    local data = internal.hammerData[aspectKey]
    if not data then return end
    if not hasLocalizedLabels then BuildLocalizedLabels() end

    local currentId = uiState.view.FirstHammers[aspectKey] or ""
    local currentIndex = data.valueIndex[currentId] or 1
    local currentPreview = data.labels[currentIndex] or "None (Random)"

    local winW = ui.GetWindowWidth()
    ui.PushID(aspectKey)
    ui.Text(displayLabel)
    ui.SameLine()
    ui.SetCursorPosX(winW * labelOffset)
    ui.PushItemWidth(winW * fieldMedium)
    if ui.BeginCombo("##HammerCombo", currentPreview) then
        for i, txt in ipairs(data.labels) do
            if ui.Selectable(txt, i == currentIndex) and i ~= currentIndex then
                uiState.set(internal.hammerPaths[aspectKey], data.values[i])
            end
        end
        ui.EndCombo()
    end
    ui.PopItemWidth()
    ui.PopID()
end

local function DrawFullHammerTab(ui, uiState, headerColor, labelOffset, fieldMedium)
    local hcR, hcG, hcB, hcA = table.unpack(headerColor)
    for _, weaponKey in ipairs(internal.weaponDrawOrder) do
        local weaponDisplayName = internal.weaponLabels[weaponKey] or weaponKey
        ui.PushStyleColor(ImGuiCol.Text, hcR, hcG, hcB, hcA)
        local open = ui.CollapsingHeader(weaponDisplayName)
        ui.PopStyleColor()
        if open then
            ui.Indent()
            for _, aspectKey in ipairs(internal.weaponAspectMapping[weaponKey] or {}) do
                DrawHammerDropdown(
                    ui,
                    aspectKey,
                    internal.aspectLabels[aspectKey] or aspectKey,
                    uiState,
                    labelOffset,
                    fieldMedium
                )
            end
            ui.Unindent()
        end
    end
end

local function DrawQuickSelect(ui, uiState, labelOffset, fieldMedium)
    local currentWeapon = internal.GetEquippedAspect()
    if currentWeapon ~= lastEquippedAspect then
        lastEquippedAspect = currentWeapon
        lastEquippedLabel = "Equipped: " .. (internal.aspectLabels[currentWeapon] or "Unknown Weapon")
    end
    if internal.hammerData[currentWeapon] then
        DrawHammerDropdown(ui, currentWeapon, lastEquippedLabel, uiState, labelOffset, fieldMedium)
    end
end

function public.DrawTab(ui, uiState, theme)
    local colors = theme and theme.colors
    local headerColor = (colors and colors.info) or DEFAULT_HEADER_COLOR
    local fieldMedium = (theme and theme.FIELD_MEDIUM) or DEFAULT_FIELD_MEDIUM
    ui.Spacing()
    ui.TextColored(
        headerColor[1],
        headerColor[2],
        headerColor[3],
        headerColor[4],
        "Select the guaranteed first hammer for each aspect."
    )
    ui.Spacing()
    DrawFullHammerTab(ui, uiState, headerColor, DEFAULT_LABEL_OFFSET, fieldMedium)
end

function public.DrawQuickContent(ui, uiState, theme)
    local fieldMedium = (theme and theme.FIELD_MEDIUM) or DEFAULT_FIELD_MEDIUM
    DrawQuickSelect(ui, uiState, DEFAULT_LABEL_OFFSET, fieldMedium)
end
