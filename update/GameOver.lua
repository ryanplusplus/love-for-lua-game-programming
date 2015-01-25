local GameOver = require 'entity/GameOver'

return function(key_pressed, on_game_over)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('game_over')) do
      if key_pressed['return'] then
        on_game_over()
      end
    end
  end
end
