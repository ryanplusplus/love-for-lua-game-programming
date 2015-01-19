return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('velocity', 'position', 'size', 'non_interacting_position')) do
      local dx = entity.velocity.x * dt
      local dy = entity.velocity.y * dt

      entity.position.x = entity.position.x + dx
      entity.position.y = entity.position.y + dy

      world:update(entity, entity.position.x, entity.position.y)
    end
  end
end
