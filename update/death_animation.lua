return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'death')) do
    local entity = event.death.entity
    if entity.death_animation and entity.position then
      scene:new_entity({
        animation = entity.death_animation:clone(),
        remove_when_animation_complete = true,
        position = {
          x = entity.position.x,
          y = entity.position.y
        },
      })
    end
  end
end
