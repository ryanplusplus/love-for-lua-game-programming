return function(scene, dt)
  local map_height
  local tile_height

  for entity in pairs(scene:entities_with('map')) do
    map_height = entity.map.height
    tile_height = entity.map.tileHeight
  end

  for entity in pairs(scene:entities_with('dies_when_off_stage', 'position')) do
    if entity.position.y > map_height * tile_height then
      entity.dead = true
    end
  end
end
