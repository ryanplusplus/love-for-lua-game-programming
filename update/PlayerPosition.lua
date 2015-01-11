return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('velocity', 'position', 'size', 'player', 'jump')) do
      local collisions, collision_x, collision_y
      local resolved_x, resolved_y

      local dx = entity.velocity.x * dt
      local dy = entity.velocity.y * dt

      local target_x = entity.position.x + dx
      local target_y = entity.position.y + dy

      collision_x, collision_y, collisions = world:check(entity, target_x, target_y, function(_, other)
        if other.enemy then return 'bounce' end
        if other.platform then return 'cross' end
      end)

      resolved_x = target_x
      resolved_y = target_y

      entity.on_ground = false

      for _, collision in pairs(collisions) do
        if collision.normal.y == -1 and not collision.overlaps then
          if collision.other.platform then
            entity.on_ground = true
            entity.velocity.y = 0
            resolved_y = collision.touch.y
          else
            resolved_x = collision_x
            resolved_y = collision_y
            entity.velocity.y = math.max(-entity.velocity.y, entity.jump.jump_acceleration)
            collision.other.dead = true
          end
        elseif collision.other.enemy then
          entity.dead = true
        end
      end

      entity.position.x = resolved_x
      entity.position.y = resolved_y

      world:update(entity, entity.position.x, entity.position.y)
    end
  end
end
