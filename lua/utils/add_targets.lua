return function(items, project_name, dec, pjpath)
  for target in pairs(dec.targets) do
    items[#items + 1] = {
      label = project_name .. ":" .. target,
      cmd = project_name .. ":" .. target,
      meta = { project = project_name, target = target, file = pjpath },
    }
  end
end
