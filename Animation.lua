local anim8 = require 'lib/anim8/anim8'

local Animation = {}
Animation.__index = Animation

function Animation:update(dt)
  self.animation:update(dt)
end

function Animation:render(x, y)
  self.animation:draw(self.sprites, x + self.offset.x, y + self.offset.y)
end

function Animation:reset()
  self.animation:gotoFrame(1)
end

return function(config)
  local sprites = love.graphics.newImage(config.sprites)
  local grid = anim8.newGrid(config.sprite_width, config.sprite_height, sprites:getWidth(), sprites:getHeight())
  local animation = anim8.newAnimation(grid:getFrames(unpack(config.frames)), config.frame_time)

  if config.flip_horizontal then
    animation:flipH()
  end

  local animation = {
    offset = config.offsets or { x = 0, y = 0 },
    animation = animation,
    sprites = sprites
  }

  return setmetatable(animation, Animation)
end
