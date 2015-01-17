local anim8 = require 'lib/anim8/anim8'
local Animation = require 'Animation'

return function(x, y, name, controls)
  local sprites = love.graphics.newImage('res/player.png')

  local a8 = anim8.newGrid(32, 32, sprites:getWidth(), sprites:getHeight())
  local walk_right = anim8.newAnimation(a8('1-8', 1), 0.05)
  local walk_left = anim8.newAnimation(a8('1-8', 1), 0.05); walk_left:flipH()
  local jump_right = anim8.newAnimation(a8(4, 1), 0.05)
  local jump_left = anim8.newAnimation(a8(4, 1), 0.05); jump_left:flipH()
  local idle_right = anim8.newAnimation(a8(1, 1), 0.05)
  local idle_left = anim8.newAnimation(a8(1, 1), 0.05); idle_left:flipH()

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
    left_right = {
      left_key = controls.left,
      right_key = controls.right,
      speed = 100
    },
    has_mass = true,
    on_ground = true,
    jump = {
      jumping = false,
      speed = 350,
      key = controls.jump
    },
    size = {
      width = 16,
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
    player = true,
    respawn = {
      [{ 'position', 'x' }] = 20,
      [{ 'position', 'y' }] = 10,
      [{ 'direction' }] = 'right',
      [{ 'velocity', 'y' }] = 0
    },
    lives = 3,
    name = name
  }
end
