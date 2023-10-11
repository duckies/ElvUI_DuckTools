local D, F, E, L, V, P, G = unpack(ElvUI_DuckTools)
local options = D.options.general.args

options.name = {
  order = 1,
  type = "group",
  name = "General",
  get = function(info) return E.db.DT.general[info[#info]] end,
  set = function(info, value)
    E.db.DT.general[info[#info]] = value
    E:StaticPopup_Show("PRIVATE_RL")
  end,
  args = {
    loglevel = {
      order = 1,
      type = "select",
      name = "Log Level",
      desc = "Only display log message of this level or higher.",
      get = function(info) return E.global.DT.core.logLevel end,
      set = function(info, value) E.global.DT.core.logLevel = value end,
      values = {
        [1] = "1 - |cffff3860[ERROR]|r",
        [2] = "2 - |cffffdd57[WARNING]|r",
        [3] = "3 - |cff209cee[INFO]|r",
        [4] = "4 - |cff00d1b2[DEBUG]|r"
      }
    }
  }
}
