return function(scene, dt)
  for entity in pairs(scene:entities_with('spawn_on_death', 'dead')) do
    for _, spawn in ipairs(entity.spawn_on_death) do
      scene:new_entity(spawn(entity))
    end
  end
end
