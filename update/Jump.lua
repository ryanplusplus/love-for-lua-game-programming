return function(key_pressed)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('animation', 'position', 'size', 'jump')) do
      if entity.on_ground then
        if key_pressed[entity.jump.key] then
          entity.velocity.y = -entity.jump.speed
          entity.jump.jumping = true
        else
          entity.jump.jumping = false
        end
      end
    end
  end
end
