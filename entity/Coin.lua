local Animation = require 'utility/Animation'

return function(sprites, points)
  local animation = Animation({
    sprites = sprites,
    frame_time = 0.25
  })

  local pickup = Animation({
    sprites = 'res/picked_up.png',
    frame_time = 0.05,
    once = true
  })

  return {
    position = {
      x = x,
      y = y
    },
    velocity = {
      x = 0,
      y = 0
    },
    size = {
      width = 16,
      height = 16
    },
    has_mass = true,
    pickup = true,
    animation = animation,
    add_to_world = true,
    coin = true,
    points = points,
    death_animation = pickup,
    one_way_platform_position = true
  }
end
