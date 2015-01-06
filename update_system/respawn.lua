return function(scene, dt)
  for entity in pairs(scene:entities_with('dead', 'respawn')) do
    entity.dead = nil

    for path, value in pairs(entity.respawn) do
      local thing = entity

      for i = 1, #path - 1 do
        thing = thing[path[i]]
      end

      thing[path[#path]] = value
    end
  end
end
