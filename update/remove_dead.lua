return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('dead')) do
      scene:remove_entity(entity)

      if entity.in_world then
        world:remove(entity)
      end
    end
  end
end
