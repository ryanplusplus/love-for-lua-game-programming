local loader = require('lib/advanced-tiled-loader/Loader')

bg = love.graphics.newImage('res/background.png')

function love.load()
  love.graphics.setBackgroundColor(255, 153, 0)
  map = loader.load('res/map.tmx')
end

function love.draw()
  love.graphics.draw(bg)
  map:draw()
end
