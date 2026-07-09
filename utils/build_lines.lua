-- returns lines for display, a map of label to item, and an ordered list of items
return function(items)
  local lines = {}
  local map = {}
  local ordered = {}

  for i = 1, #items do
    local item = items[i]
    local label = item.label
    lines[#lines + 1] = label
    map[label] = item
    ordered[#ordered + 1] = item
  end

  return lines, map, ordered
end
