return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'kill')) do
    if event.kill.killer.player then
      local player = event.kill.killer

      player.score = player.score + (event.kill.killed.points or 0)
    end
  end
end
