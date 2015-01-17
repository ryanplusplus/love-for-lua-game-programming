local anim8 = require 'lib/anim8/anim8'
local Animation = require 'Animation'

return function(x, y)
  local sprites = love.graphics.newImage('res/player_death.png')

  local a8 = anim8.newGrid(32, 32, sprites:getWidth(), sprites:getHeight())
  local death = anim8.newAnimation(a8('1-4', 1), 0.05)

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
    animation = Animation(
      sprites,
      {
        x = -8,
        y = -6
      },
      {
        death = death
      },
      'death'
    ),
    non_interacting = true
  }
end
