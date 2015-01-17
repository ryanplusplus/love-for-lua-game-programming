return function(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'remove_when_animation_complete')) do
    if entity.animation:is_complete() then
      scene:remove_entity(entity)
    end
  end
end
