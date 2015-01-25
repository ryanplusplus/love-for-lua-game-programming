return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'death')) do
    local entity = event.death.entity
    if entity.drops and entity.position then
      local drop = scene:new_entity(entity.drops)
      if drop.position and entity.position then
        drop.position.x = entity.position.x
        drop.position.y = entity.position.y
      end
    end
  end
end
