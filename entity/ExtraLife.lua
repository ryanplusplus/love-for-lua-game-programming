local Animation = require 'Animation'

return function(x, y)
  local animation = Animation({
    sprites = 'res/extra_life.png',
    sprite_width = 16,
    sprite_height = 16,
    frames = { '1-4', 1 },
    frame_time = 0.25
  })

  return {
    position = {
      x = x,
      y = y
    },
    size = {
      width = 16,
      height = 16
    },
    animation = animation,
    add_to_world = true,
    extra_life = true,
    remove_from_world_when_dead = true
  }
end
