return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('dead')) do
      scene:remove_entity(entity)

      if entity.remove_from_world_when_dead then
        world:remove(entity)
      end
    end
  end
end
