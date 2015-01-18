return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('add_to_world', 'position', 'size')) do
      world:add(entity, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
      entity.add_to_world = nil
      entity.in_world = true
    end
  end
end
