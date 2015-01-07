return function(scene, dt)
  for entity in pairs(scene:entities_with('animation')) do
    entity.animation:update(dt)
  end
end
