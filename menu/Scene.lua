local Scene = require '/lib/scene/Scene'
local Background = require 'entity/Background'

return function(key_pressed, on_start)
  local scene = Scene()

  scene:add_render_system((require 'render/Drawable')('background'))

  scene:add_update_system(function(scene, dt)
    if key_pressed['return'] then
      on_start()
    end
  end)

  scene:new_entity({
    background = Background('res/menu.jpg')
  })

  return scene
end
