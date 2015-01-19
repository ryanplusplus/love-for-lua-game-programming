return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'jumped_on')) do
    if event.jumped_on.jumpee.damaged_when_jumped_on then
      local jumpee = event.jumped_on.jumpee

      if jumpee.life then
        jumpee.life = jumpee.life - event.jumped_on.damage
      end

      if jumpee.life == nil or jumpee.life <= 0 then
        jumpee.dead = true

        scene:new_entity({
          event = true,
          death = {
            entity = jumpee
          }
        })

        scene:new_entity({
          event = true,
          kill = {
            killer = event.jumped_on.jumper,
            killed = jumpee
          }
        })
      end
    end
  end
end
