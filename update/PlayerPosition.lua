return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('velocity', 'position', 'size', 'player', 'jump')) do
      local collisions
      local resolved_x, resolved_y

      local dx = entity.velocity.x * dt
      local dy = entity.velocity.y * dt

      local target_x = entity.position.x + dx
      local target_y = entity.position.y + dy

      _, _, collisions = world:check(entity, target_x, target_y,
        function(_, other)
          if other.platform then
            return 'cross'
          elseif other.enemy then
            return 'cross'
          else
            return false
          end
        end)

      resolved_x = target_x
      resolved_y = target_y

      entity.on_ground = false

      for _, collision in pairs(collisions) do
        local other = collision.other

        if collision.normal.y == -1 and not collision.overlaps then
          local bounciness = other.bounciness or 0

          if bounciness == 0 then
            entity.on_ground = true
            entity.velocity.y = 0
          else
            entity.velocity.y = -entity.velocity.y * bounciness
          end

          if other.enemy then
            other.dead = true
          end

          resolved_y = collision.touch.y
        elseif other.enemy then
          entity.dead = true
        end
      end

      entity.position.x = resolved_x
      entity.position.y = resolved_y

      world:update(entity, entity.position.x, entity.position.y)
    end
  end
end
