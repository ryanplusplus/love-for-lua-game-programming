return function(component)
  return function(scene)
    for entity in pairs(scene:entities_with(component)) do
      entity[component]:draw()
    end
  end
end
