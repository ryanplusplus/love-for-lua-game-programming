return function(scene)
  for entity in pairs(scene:entities_with('text', 'position', 'font')) do
    love.graphics.setFont(entity.font)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(entity.text, entity.position.x, entity.position.y)
  end
end
