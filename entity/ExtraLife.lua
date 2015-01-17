local Animation = require 'utility/Animation'
local PickedUp = require 'entity/PickedUp'

return function(x, y)
  local animation = Animation({
    sprites = 'res/extra_life.png',
    frame_time = 0.25
  })

  return {
    position = {
      x = x,
      y = y
    },
    size = {
      width = 16,
      height = 16
    },
    animation = animation,
    add_to_world = true,
    extra_life = true,
    remove_from_world_when_dead = true,
    spawn_on_death = {
      function(entity)
        return PickedUp(entity.position.x, entity.position.y)
      end
    }
  }
end
