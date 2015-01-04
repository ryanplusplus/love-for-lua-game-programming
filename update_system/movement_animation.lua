return function(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'velocity', 'on_ground', 'direction', 'movement_animations')) do
    if entity.velocity.x < 0 then
      if entity.on_ground then
        entity.animation:select(entity.movement_animations.walk_left)
      else
        entity.animation:select(entity.movement_animations.air_left)
      end
    elseif entity.velocity.x > 0 then
      if entity.on_ground then
        entity.animation:select(entity.movement_animations.walk_right)
      else
        entity.animation:select(entity.movement_animations.air_right)
      end
    else
      if entity.direction == 'right' then
        entity.animation:select(entity.movement_animations.idle_right)
      else
        entity.animation:select(entity.movement_animations.idle_left)
      end
    end
  end
end
