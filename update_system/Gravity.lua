return function(gravity)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('has_mass', 'velocity')) do
      entity.velocity.y = entity.velocity.y + gravity * dt
    end
  end
end
