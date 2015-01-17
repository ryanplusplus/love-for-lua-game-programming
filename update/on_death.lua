return function(scene, dt)
  for entity in pairs(scene:entities_with('on_death', 'dead')) do
    entity.on_death(scene, entity)
  end
end
