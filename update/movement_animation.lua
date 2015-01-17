return function(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'movement_animations', 'velocity', 'on_ground', 'direction')) do
    if entity.on_ground then
      if entity.velocity.x == 0 then
        if entity.direction == 1 then
          entity.animation = entity.movement_animations.idle_right
        else
          entity.animation = entity.movement_animations.idle_left
        end
      else
        if entity.direction == 1 then
          entity.animation = entity.movement_animations.walk_right
        else
          entity.animation = entity.movement_animations.walk_left
        end
      end
    else
      if entity.direction == 1 then
        entity.animation = entity.movement_animations.air_right
      else
        entity.animation = entity.movement_animations.air_left
      end
    end
  end
end
