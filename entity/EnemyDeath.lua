local Animation = require 'Animation'

return function(x, y, direction)
  local image

  if direction == 1 then
    image = 'res/enemy_die_right.png'
  else
    image = 'res/enemy_die_left.png'
  end

  local death = Animation({
    sprites = image,
    frame_time = 0.5,
    offsets = {
      x = -8,
      y = -6
    },
    once = true
  })

  return {
    position = {
      x = x,
      y = y
    },
    animation = death,
    non_interacting = true,
    remove_when_animation_complete = true
  }
end
