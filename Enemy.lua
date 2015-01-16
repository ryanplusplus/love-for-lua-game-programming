local anim8 = require 'lib/anim8/anim8'
local Animation = require 'Animation'

return function(x, y)
  local sprites = love.graphics.newImage('res/enemy.png')

  local a8 = anim8.newGrid(32, 32, sprites:getWidth(), sprites:getHeight())
  local walk_right = anim8.newAnimation(a8('1-4', 1), 0.05)
  local walk_left = anim8.newAnimation(a8('1-4', 1), 0.05); walk_left:flipH()
  local jump_right = anim8.newAnimation(a8(4, 1), 0.05)
  local jump_left = anim8.newAnimation(a8(4, 1), 0.05); jump_left:flipH()
  local idle_right = anim8.newAnimation(a8(1, 1), 0.05)
  local idle_left = anim8.newAnimation(a8(1, 1), 0.05); idle_left:flipH()

  return {
    position = {
      x = x,
      y = y
    },
    velocity = {
      x = 0,
      y = 0
    },
    direction = -1,
    has_mass = true,
    on_ground = false,
    size = {
      width = 18,
      height = 26
    },
    animation = Animation(
      sprites,
      {
        x = -8,
        y = -6
      },
      {
        walk_right = walk_right,
        walk_left = walk_left,
        air_right = jump_right,
        air_left = jump_left,
        idle_right = idle_right,
        idle_left = idle_left
      },
      'idle_right'
    ),
    movement_animations = {
      walk_right = 'walk_right',
      walk_left = 'walk_left',
      air_right = 'air_right',
      air_left = 'air_left',
      idle_right = 'idle_right',
      idle_left = 'idle_left'
    },
    add_to_world = true,
    enemy = true,
    basic_enemy_ai = {
      speed = 100
    },
    remove_from_world_when_dead = true,
    bounciness = 0.9
  }
end
