return function(scene, dt)
  for entity in pairs(scene:entities_with('basic_enemy_ai', 'velocity', 'direction')) do
    entity.velocity.x = entity.basic_enemy_ai.speed
    entity.direction = entity.basic_enemy_ai.direction
  end
end
