return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'ran_into')) do
    if event.ran_into.entity.can_pickup_powerups and event.ran_into.other.coin then
      local coin = event.ran_into.other
      local player = event.ran_into.entity

      if player.score and coin.points then
        player.score = player.score + coin.points
      end

      coin.dead = true

      scene:new_entity({
        event = true,
        death = {
          entity = coin
        }
      })
    end
  end
end
