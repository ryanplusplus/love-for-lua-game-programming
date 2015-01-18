return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'death')) do
    if event.death.entity.on_death then
      event.death.entity.on_death(scene, event.death.entity)
    end
  end
end
