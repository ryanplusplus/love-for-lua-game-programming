local loader = require('advanced-tile-loader/Loader')

function love.load()
  love.graphics.setBackgroundColor(255, 153, 0)
  map = loader.load('res/map.tmx')
end

function love.draw()
  map:draw()
end
