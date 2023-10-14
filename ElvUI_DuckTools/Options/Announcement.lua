local D, F, E, L, V, P, G = unpack(ElvUI_DuckTools)

local options = D.options.announcement.args

options.desc = {
  order = 1,
  type = "group",
  inline = true,
  name = "Description",
  args = {
    feature_1 = {
      order = 1,
      type = "description",
      name = "The announcements module lets you send messages to various channels during in-game events.",
      fontSize = "medium"
    }
  }
}

options.enable = {
  order = 2,
  type = "toggle",
  get = function(info)
    return E.db.DT.announcement[info[#info]]
  end,
  set = function(info, value)
    E.db.DT.announcement[info[#info]] = value
    -- A:Toggle()
  end,
  name = "Enable"
}
