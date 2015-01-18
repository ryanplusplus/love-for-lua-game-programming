local GameOver = require 'entity/GameOver'

return function(scene, dt)
  for entity in pairs(scene:entities_with('player')) do
    return
  end

  scene:new_entity(GameOver())
end
