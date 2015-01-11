return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('dead', 'respawn')) do
      if entity.lives then
        entity.lives = math.max(entity.lives - 1, 0)

        if entity.lives == 0 then
          return
        end
      end

      entity.dead = nil

      for path, value in pairs(entity.respawn) do
        local thing = entity

        for i = 1, #path - 1 do
          thing = thing[path[i]]
        end

        thing[path[#path]] = value
      end

      if entity.position then
        world:update(entity, entity.position.x, entity.position.y)
      end
    end
  end
end
