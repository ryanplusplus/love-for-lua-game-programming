return function(scene, dt)
  for entity in pairs(scene:entities_with('dead')) do
    scene:remove_entity(entity)
  end
end
