return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('basic_enemy_ai', 'velocity', 'direction', 'on_ground', 'position')) do
      if entity.on_ground and entity.velocity.x == 0 then
        if entity.direction == 1 then
          entity.velocity.x = entity.basic_enemy_ai.speed
        else
          entity.velocity.x = -entity.basic_enemy_ai.speed
        end
      elseif entity.on_ground then
        local dx = entity.velocity.x * dt
        local dy = entity.velocity.y * dt

        local x = entity.position.x + dx
        local y = entity.position.y + dy

        if entity.direction == 1 then
          x = x + entity.size.width
        end

        local items = world:queryRect(x, y, 1, entity.size.height, function(item) return item.platform end)

        if #items == 0 then
          entity.velocity.x = -entity.velocity.x
          entity.direction = entity.direction * -1
        end
      end
    end
  end
end
