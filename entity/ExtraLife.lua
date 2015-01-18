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
    pickup = true,
    animation = animation,
    add_to_world = true,
    extra_life = true,
    on_death = function(scene, entity)
      scene:new_entity(PickedUp(entity.position.x, entity.position.y))
    end
  }
end
