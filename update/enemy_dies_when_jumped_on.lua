return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'jumped_on')) do
    if event.jumped_on.jumpee.enemy then
      local enemy = event.jumped_on.jumpee

      enemy.dead = true

      scene:new_entity({
        event = true,
        death = {
          entity = enemy
        }
      })
    end
  end
end
