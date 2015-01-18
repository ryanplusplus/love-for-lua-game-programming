local font = love.graphics.newFont(22)

local width_padding = 5
local height_padding = 2

local x_fudge = -1

return function(scene)
  local map_height
  local map_width

  for entity in pairs(scene:entities_with('map')) do
    map_height = entity.map.height * entity.map.tileHeight
    map_width = entity.map.width * entity.map.tileWidth
  end

  for entity in pairs(scene:entities_with('game_over')) do
    local text = 'Game Over'
    local box_width = font:getWidth(text) + 2 * width_padding
    local box_height = font:getHeight(text) + 2 * height_padding

    local x = map_width / 2 - box_width / 2
    local y = map_height / 2 - box_height / 2

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 175)
    love.graphics.rectangle('fill', x, y, box_width, box_height)
    love.graphics.setColor(255, 255, 255, 200)
    love.graphics.rectangle('line', x, y, box_width, box_height)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(text, x + width_padding + x_fudge, y + height_padding)
  end
end
