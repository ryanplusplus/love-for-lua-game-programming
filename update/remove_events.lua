return function(scene, dt)
  for event in pairs(scene:entities_with('event')) do
    scene:remove_entity(event)
  end
end
