local Animation = require 'utility/Animation'

return function(x, y)
  local death = Animation({
    sprites = 'res/player_death.png',
    offsets = {
      x = -8,
      y = -6
    },
    frames = { '1-4', 1 },
    frame_time = 0.1,
    once = true
  })

  return {
    remove_when_animation_complete = true,
    position = {
      x = x,
      y = y
    },
    animation = death
  }
end
