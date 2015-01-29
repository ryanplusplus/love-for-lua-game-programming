local SoundEffect = require 'utility/SoundEffect'

return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'death')) do
    local entity = event.death.entity
    if entity.death_sound then
      SoundEffect(entity.death_sound):play()
    end
  end
end
