local Animation = require 'Animation'

return function(x, y)
  local death = Animation({
    sprites = 'res/player_death.png',
    sprite_width = 32,
    sprite_height = 32,
    offsets = {
      x = -8,
      y = -6
    },
    frames = { '1-4', 1 },
    frame_time = 0.05
  })

  return {
    dies_when_off_stage = true,
    position = {
      x = x,
      y = y
    },
    velocity = {
      x = 0,
      y = 0
    },
    direction = 1,
    has_mass = true,
    size = {
      width = 16,
      height = 26
    },
    add_to_world = true,
    animation = death,
    non_interacting = true
  }
end
