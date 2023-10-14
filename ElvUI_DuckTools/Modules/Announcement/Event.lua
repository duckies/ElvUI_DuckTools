local D, F, E, L = unpack(ElvUI_DuckTools)
local A = D:GetModule("Announcement")

A.EventList = {
  "CHALLENGE_MODE_COMPLETED",
  "CHAT_MSG_PARTY",
  "CHAT_MSG_PARTY_LEADER",
  "CHAT_MSG_GUILD",
  "ITEM_CHANGED",
  "PLAYER_ENTERING_WORLD"
}

function A:CHAT_MSG_PARTY(event, ...)
  self:KeystoneLink(event, ...)
end

function A:CHAT_MSG_PARTY_LEADER(event, ...)
  self:KeystoneLink(event, ...)
end

function A:CHAT_MSG_GUILD(event, ...)
  self:KeystoneLink(event, ...)
end

function A:ITEM_CHANGED(event, ...)
  E:Delay(0.5, self.Keystone, self, event)
end

function A:PLAYER_ENTERING_WORLD(event, ...)
  E:Delay(2, self.Keystone, self, event)
end

function A:CHALLENGE_MODE_COMPLETED(event, ...)
  E:Delay(2, self.Keystone, self, event)
end
