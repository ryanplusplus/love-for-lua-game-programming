return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('velocity', 'position', 'size', 'player')) do
      local collisions
      local resolved_x, resolved_y

      local dx = entity.velocity.x * dt
      local dy = entity.velocity.y * dt

      local target_x = entity.position.x + dx
      local target_y = entity.position.y + dy

      _, _, collisions = world:check(entity, target_x, target_y, function() return 'cross' end)

      resolved_x = target_x
      resolved_y = target_y

      entity.on_ground = false

      for _, collision in pairs(collisions) do
        if collision.normal.y == -1 and not collision.overlaps then
          entity.on_ground = true
          entity.jump.jumping = false
          entity.velocity.y = 0
          resolved_y = collision.touch.y
        end
      end

      entity.position.x = resolved_x
      entity.position.y = resolved_y

      world:update(entity, entity.position.x, entity.position.y)
    end
  end
end
