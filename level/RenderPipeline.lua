return function()
  return {
    (require 'render/Drawable')('background'),
    (require 'render/Drawable')('map'),
    (require 'render/Animation')({ 'pickup', 'player', 'enemy' }),
    (require 'render/hud'),
    (require 'render/fancy_message')
  }
end
