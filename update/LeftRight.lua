return function(key_held)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('animation', 'position', 'left_right', 'jump', 'direction')) do
      if key_held[entity.left_right.left_key] then
        entity.velocity.x = -entity.left_right.speed
        entity.direction = -1
      elseif key_held[entity.left_right.right_key] then
        entity.velocity.x = entity.left_right.speed
        entity.direction = 1
      else
        entity.velocity.x = 0
      end
    end
  end
end
