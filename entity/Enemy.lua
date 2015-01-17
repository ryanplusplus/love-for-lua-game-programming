local Animation = require 'Animation'
local EnemyDeath = require 'entity/EnemyDeath'

return function(x, y)
  local walk_right = Animation({
    sprites = 'res/enemy_walk_right.png',
    offsets = {
      x = -8,
      y = -6
    },
    frame_time = 0.05
  })

  local walk_left = Animation({
    sprites = 'res/enemy_walk_left.png',
    offsets = {
      x = -8,
      y = -6
    },
    frame_time = 0.05
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
      width = 18,
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
    basic_enemy_ai = {
      speed = 100
    },
    remove_from_world_when_dead = true,
    bounciness = 0.9,
    spawn_on_death = {
      function(entity)
        return EnemyDeath(entity.position.x, entity.position.y, entity.direction)
      end
    }
  }
end
