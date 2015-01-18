return function(scene, dt)
  for entity in pairs(scene:entities_with('death_animation', 'direction', 'directional_death_animation')) do
    entity.death_animation = entity.directional_death_animation[entity.direction]
  end
end
