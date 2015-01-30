local Win = require 'entity/Win'

return function(scene, dt)
  for entity in pairs(scene:entities_with('enemy')) do
    return
  end

  for entity in pairs(scene:entities_with('win')) do
    return
  end

  scene:new_entity(Win())
end
