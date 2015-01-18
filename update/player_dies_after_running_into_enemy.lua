return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'ran_into')) do
    if event.ran_into.entity.player and event.ran_into.other.enemy then
      event.ran_into.entity.dead = true
    end

    if event.ran_into.other.player and event.ran_into.entity.enemy then
      event.ran_into.other.dead = true
    end
  end
end
