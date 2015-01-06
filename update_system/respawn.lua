function shallow_copy(original)
  local copy
  if type(original) == 'table' then
    copy = {}
    for k, v in pairs(original) do
      copy[k] = v
    end
  else
    copy = original
  end
  return copy
end

return function(scene, dt)
  for entity in pairs(scene:entities_with('dead', 'respawn')) do
    entity.dead = nil

    for component, value in pairs(entity.respawn) do
      entity[component] = shallow_copy(value)
    end
  end
end
