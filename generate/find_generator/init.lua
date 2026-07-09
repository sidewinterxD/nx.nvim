return function(generator_name)
  if generator_name == "component" then
    local component = require("nx.generate.generators.component")
    component(generator_name)
  else
    print("Generator not implemented: " .. generator_name)
  end
end
