return function(key_pressed)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('animation', 'position', 'size', 'jump')) do
      if key_pressed[entity.jump.key] then
        entity.jump.jump_rel = true
      end

      if entity.on_ground then
        if entity.jump.jump_rel then
          entity.velocity.y = entity.jump.jump_acceleration
          entity.jump.jumping = true
          entity.jump.jump_rel = false
          entity.jump.jump_timer = 0.065
        end
      elseif entity.jump.jump_rel == false and entity.jump.jump_timer > 0 then
        entity.velocity.y = entity.velocity.y + entity.jump.jump_acceleration * dt
      else
        entity.jump.jumping = false
        entity.jump.jump_rel = false
      end

      if entity.jump.jump_timer > 0 then
        entity.jump.jump_timer = entity.jump.jump_timer - dt
      end
    end
  end
end
