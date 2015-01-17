return function(priorities)
  return function(scene)
    local entities = {}

    for entity in pairs(scene:entities_with('animation', 'position')) do
      entities[entity] = true
    end

    for _, priority in ipairs(priorities) do
      for entity in pairs(entities) do
        if entity[priority] then
          entity.animation:render(entity.position.x, entity.position.y)
          entities[entity] = nil
        end
      end
    end

    for entity in pairs(entities) do
      entity.animation:render(entity.position.x, entity.position.y)
    end
  end
end
