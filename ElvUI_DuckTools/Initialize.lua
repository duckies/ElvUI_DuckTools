local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local AceAddon = E.Libs.AceAddon

local _G = _G
local hooksecurefunc = hooksecurefunc


local D = AceAddon:NewAddon(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

D.Title = "DuckTools"

local EP = LibStub("LibElvUIPlugin-1.0")

V.DT = {} -- Profile Database Defaults
P.DT = {} -- Private Database Defaults
G.DT = {} -- Global Database Defaults

addon[1] = D
addon[2] = {} -- Functions
addon[3] = E
addon[4] = L
addon[5] = V.DT
addon[6] = P.DT
addon[7] = G.DT

_G[addonName] = addon

D.Modules = {
  ChatText = D:NewModule('D_ChatText', 'AceEvent-3.0'),
}

function D:Initialize()
  for name, module in self:IterateModules() do
    addon[2].Developer.InjectLogger(module)
  end

  hooksecurefunc(D, 'NewModule', function(_, name)
    addon[2].Developer.InjectLogger(name)
  end)

  self.initialized = true


  self:InitializeModules()
  EP:RegisterPlugin(addonName, D.InsertOptions)
  self:SecureHook(E, "UpdateAll", "ProfileUpdateModules")
  -- self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

EP:HookInitialize(D, D.Initialize)
