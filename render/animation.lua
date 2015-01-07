return function(scene)
  for entity in pairs(scene:entities_with('animation', 'position')) do
    entity.animation:render(entity.position.x, entity.position.y)
  end
end
