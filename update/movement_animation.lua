function set_animation(entity, animation)
  if entity.animation ~= entity.movement_animations[animation] then
    entity.animation:reset()
  end

  entity.animation = entity.movement_animations[animation]
end

return function(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'movement_animations', 'velocity', 'on_ground', 'direction')) do
    if entity.on_ground then
      if entity.velocity.x == 0 then
        if entity.direction == 1 then
          set_animation(entity, 'idle_right')
        else
          set_animation(entity, 'idle_left')
        end
      else
        if entity.direction == 1 then
          set_animation(entity, 'walk_right')
        else
          set_animation(entity, 'walk_left')
        end
      end
    else
      if entity.direction == 1 then
        set_animation(entity, 'air_right')
      else
        set_animation(entity, 'air_left')
      end
    end
  end
end
