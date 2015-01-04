return function(scene)
  for entity in pairs(scene:entities_with('background')) do
    entity.background:draw()
  end
end
