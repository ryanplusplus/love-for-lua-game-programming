local Animation = require 'utility/Animation'

return function(config)
  local animation = Animation({
    sprites = 'res/extra_life.png',
    frame_time = 0.25
  })

  local pickup = Animation({
    sprites = 'res/picked_up.png',
    frame_time = 0.05,
    once = true
  })

  return {
    position = {
      x = config.x,
      y = config.y
    },
    size = {
      width = 16,
      height = 16
    },
    pickup = true,
    animation = animation,
    add_to_world = true,
    extra_life = true,
    death_animation = pickup,
    death_sound = 'res/plink.wav'
  }
end
