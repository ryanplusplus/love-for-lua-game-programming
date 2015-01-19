return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'ran_into')) do
    if event.ran_into.entity.can_pickup_powerups and event.ran_into.other.extra_life then
      local extra_life = event.ran_into.other
      local player = event.ran_into.entity

      if player.lives then
        player.lives = player.lives + 1
      end

      extra_life.dead = true

      scene:new_entity({
        event = true,
        death = {
          entity = extra_life
        }
      })
    end
  end
end
