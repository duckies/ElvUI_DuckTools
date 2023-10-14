local D, _, E = unpack(ElvUI_DuckTools)

local IsResting = IsResting
local UnitLevel = UnitLevel
local UnitIsWildBattlePet = UnitIsWildBattlePet
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitIsUnit = UnitIsUnit
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsConnected = UnitIsConnected
local UnitPlayerControlled = UnitPlayerControlled
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsPlayer = UnitIsPlayer
local UnitIsBoss = UnitIsBoss

local format = string.format

E:AddTag("duck:health:current-percent",
  "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_UPDATE_RESTING",
  function(unit)
    local status = UnitIsDead(unit) and "Dead"
        or UnitIsGhost(unit) and "Ghost"
        or not UnitIsConnected(unit) and "Offline"

    if status then
      return status
    end

    local currentHealth, maximumHealth = UnitHealth(unit), UnitHealthMax(unit)
    local healthPercent = currentHealth / maximumHealth * 100

    if (healthPercent ~= 100) then
      return format('%.1f%s | %s', healthPercent, '%', E:ShortValue(currentHealth))
    else
      return E:ShortValue(currentHealth)
    end
  end
)

E:AddTagInfo("duck:health:current-percent", D.Title,
  "Displays the unit's health percentage, a bar, then their current health, or status if dead, ghost, offline, ...etc.")

E:AddTag("duck:level", "UNIT_LEVEL PLAYER_LEVEL_UP PLAYER_UPDATE_RESTING", function(unit)
  if unit == 'player' and IsResting() then
    return "|cfff7d358zZz|r"
  end

  local level = UnitLevel(unit)

  if (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
    return UnitBattlePetLevel(unit)
  end

  if level > 0 then
    return level
  end

  return "|cffff033e??|r"
end)

E:AddTagInfo("duck:level", D.Title, "Displays the unit's level, 'zZz' if resting, or '??' if unknown.")

E:AddTag("duck:targeting-count", "UNIT_TARGET PLAYER_TARGET_CHANGED GROUP_ROSTER_UPDATE", function(unit)
  if not IsInGroup() then return nil end

  local targetingCount = 0

  for i = 1, GetNumGroupMembers() do
    local groupUnit = (IsInRaid() and 'raid' .. i or 'party' .. i);
    if (UnitIsUnit(groupUnit .. 'target', unit) and not UnitIsUnit(groupUnit, 'player')) then
      targetingCount = targetingCount + 1
    end
  end

  if UnitIsUnit("playertarget", unit) then
    targetingCount = targetingCount + 1
  end

  return (targetingCount > 0 and targetingCount or nil)
end)

E:AddTagInfo("duck:targeting-count", D.Title, "Displays the number of players targeting the unit if in a group.")

-- E:AddTag('duck:power:healer', )
