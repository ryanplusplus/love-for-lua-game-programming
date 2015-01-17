local Animation = require 'Animation'

return function(x, y)
  local pickup = Animation({
    sprites = 'res/picked_up.png',
    sprite_width = 16,
    frame_time = 0.05,
    once = true
  })

  return {
    position = {
      x = x,
      y = y
    },
    animation = pickup,
    non_interacting = true,
    remove_when_animation_complete = true
  }
end
