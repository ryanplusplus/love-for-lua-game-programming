local anim8 = require 'lib/anim8/anim8'
local Animation = require 'Animation'

return function(x, y)
  local sprites = love.graphics.newImage('res/extra_life.png')

  local a8 = anim8.newGrid(16, 16, sprites:getWidth(), sprites:getHeight())
  local idle = anim8.newAnimation(a8('1-4', 1), 0.25)

  return {
    position = {
      x = x,
      y = y
    },
    size = {
      width = 32,
      height = 32
    },
    animation = Animation(
      sprites,
      {
        x = 0,
        y = 0
      },
      {
        idle = idle
      },
      'idle'
    ),
    add_to_world = true,
    extra_life = true,
    remove_from_world_when_dead = true
  }
end
