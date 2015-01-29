local Animation = require 'utility/Animation'
local GoldCoin = require 'entity/GoldCoin'
local SilverCoin = require 'entity/SilverCoin'

return function(x, y)
  local walk_right = Animation({
    sprites = 'res/enemy_walk_right.png',
    offsets = {
      x = -6,
      y = -6
    },
    frame_time = 0.05
  })

  local walk_left = Animation({
    sprites = 'res/enemy_walk_left.png',
    offsets = {
      x = -6,
      y = -6
    },
    frame_time = 0.05
  })

  local death_left = Animation({
    sprites = 'res/enemy_die_left.png',
    frame_time = 0.5,
    offsets = {
      x = -6,
      y = -6
    },
    once = true
  })

  local death_right = Animation({
    sprites = 'res/enemy_die_right.png',
    frame_time = 0.5,
    offsets = {
      x = -6,
      y = -6
    },
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
    direction = -1,
    has_mass = true,
    on_ground = false,
    size = {
      width = 22,
      height = 26
    },
    animation = walk_right,
    movement_animations = {
      walk_right = walk_right,
      walk_left = walk_left,
      air_right = walk_right,
      air_left = walk_left,
      idle_right = walk_right,
      idle_left = walk_left
    },
    add_to_world = true,
    enemy = true,
    patrol_ai = {
      speed = 100
    },
    solid = true,
    bounciness = 0.9,
    death_animation = death_right,
    directional_death_animation = {
      [1] = death_right,
      [-1] = death_left
    },
    points = 10,
    life = 15,
    damaged_when_jumped_on = true,
    damage_dealt_when_run_into = 10,
    one_way_platform_position = true,
    drops = {
      [GoldCoin()] = 1,
      [SilverCoin()] = 4
    },
    death_sound = 'res/squish.wav'
  }
end
