local D, F, E, L, V, P, G = unpack(ElvUI_DuckTools)

D.options = {
  general = {
    order = 101,
    name = "General",
    args = {}
  },
  announcement = {
    order = 102,
    name = "Announcement",
    desc = "Chatterbox behaviors",
    args = {}
  },
}

function D:InsertOptions()
  E.Options.args.DuckTools = {
    type = "group",
    childGroups = "tree",
    name = "DuckTools",
    args = {},
  }

  for category, info in pairs(D.options) do
    E.Options.args.DuckTools.args[category] = {
      order = info.order,
      type = "group",
      childGroups = "tab",
      name = info.name,
      desc = info.desc,
      icon = info.icon,
      args = info.args
    }
  end
end
