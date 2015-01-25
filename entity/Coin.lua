local Animation = require 'utility/Animation'

return function(x, y)
  x = x or 0
  y = y or 0

  local animation = Animation({
    sprites = 'res/gold_coin.png',
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
    points = 10,
    death_animation = pickup,
    one_way_platform_position = true
  }
end
