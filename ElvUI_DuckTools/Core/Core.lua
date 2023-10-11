local D, F, E = unpack(ElvUI_DuckTools)

local tinsert = table.insert
local unpack = unpack

D.RegisteredModules = {}

-- Module registration.
function D:RegisterModule(name)
  if not name then
    F.Developer.ThrowError("The name of the module is required to register it.")
  end

  if self.initialized then
    self:GetModule(name):Initialize()
  else
    tinsert(self.RegisteredModules, name)
  end
end

-- Module initialization.
function D:InitializeModules()
  for _, moduleName in pairs(D.RegisteredModules) do
    local module = self:GetModule(moduleName)

    if module.Initialize then
      print(pcall(module.Initialize, module))
    end
  end
end

-- Module update after profile switch.
function D:ProfileUpdateModules()
  for _, name in pairs(self.RegisteredModules) do
    local module = D:GetModule(name)

    if module.ProfileUpdate then
      pcall(module.ProfileUpdate, module)
    end
  end
end
