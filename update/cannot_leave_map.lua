return function(scene, dt)
  local map_right

  for entity in pairs(scene:entities_with('map')) do
    map_right = entity.map.width * entity.map.tileWidth
  end

  for entity in pairs(scene:entities_with('cannot_leave_map', 'position')) do
    if entity.position.x < 0 then
      entity.position.x = 0
      entity.velocity.x = 0
    elseif entity.position.x + entity.size.width > map_right then
      entity.position.x = map_right - entity.size.width
      entity.velocity.x = 0
    end
  end
end
