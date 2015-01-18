return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'jumped_on')) do
    if event.jumped_on.jumpee.enemy then
      event.jumped_on.jumpee.dead = true
    end
  end
end
