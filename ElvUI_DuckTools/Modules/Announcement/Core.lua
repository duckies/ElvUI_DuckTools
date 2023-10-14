local D, F, E, L = unpack(ElvUI_DuckTools)
local A = D:NewModule("Announcement", "AceEvent-3.0")

local _G = _G

local time = time

local IsInRaid = IsInRaid
local SendChatMessage = SendChatMessage

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

A.ChatHistory = {}

function A:SendChatMessage_Throttled(text, channel)
  -- Turn into DB value eventually.
  local throttleInterval = 10

  local key = channel .. "|" .. text

  if self.ChatHistory[key] and time() < self.ChatHistory[key] + throttleInterval then
    return false
  end

  self.ChatHistory[key] = time()

  return SendChatMessage(text, channel)
end

function A:SendMessage(text, channel, raidWarning)
  -- Change channel if it's protected by Blizzard.
  if channel == "YELL" or channel == "SAY" then
    if not IsInInstance() then
      channel = "SELF"
    end
  end

  if channel == "SELF" then
    _G.ChatFrame1:AddMessage(text)
  end

  -- Switch to raid chat if we cannot make raid warnings.
  if channel == "RAID_WARNING" and IsInRaid(LE_PARTY_CATEGORY_HOME) then
    if not UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
      channel = "RAID"
    end
  end

  self:SendChatMessage_Throttled(text, channel)
end

function A:Initialize()
  self.db = E.db.DT.announcement

  if not self.db.enable or self.initialized then
    return
  end

  for _, event in pairs(self.EventList) do
    print("Registering event: " .. event)
    A:RegisterEvent(event)
  end

  self.initialized = true
end

D:RegisterModule(A:GetName())
