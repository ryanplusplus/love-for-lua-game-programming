local Animation = {}
Animation.__index = Animation

function Animation:update(dt)
  if self.current then
    self.current:update(dt)
  end
end

function Animation:render(x, y)
  if self.current then
    self.current:draw(self.sprites, x + self.offset.x, y + self.offset.y)
  end
end

function Animation:select(which)
  self.current = self.animations[which]
end

return function(sprites, offsets, animations, initial_animation)
  local animation = {
    current = initial_animation,
    offset = offsets,
    animations = animations,
    sprites = sprites
  }

  return setmetatable(animation, Animation)
end
