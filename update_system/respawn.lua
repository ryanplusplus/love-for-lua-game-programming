return function(scene, dt)
  for entity in pairs(scene:entities_with('dead', 'respawn')) do
    entity.dead = nil

    entity.position.x = 20
    entity.position.y = 10
    entity.direction = 'right'
    entity.velocity.y = 0

    -- for path, value in pairs(entity.respawn) do
    --   local thing = entity

    --   for i = 1, #path - 1 do
    --     thing = thing[path[i]]
    --   end

    --   thing[path[#path]] = value
    -- end
  end
end
