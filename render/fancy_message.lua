local width_padding = 5
local height_padding = 2

return function(scene)
  local map_height
  local map_width

  for entity in pairs(scene:entities_with('map')) do
    map_height = entity.map.height * entity.map.tileHeight
    map_width = entity.map.width * entity.map.tileWidth
  end

  for entity in pairs(scene:entities_with('fancy_message')) do
    local fancy_message = entity.fancy_message
    local text = fancy_message.text
    local box_width = fancy_message.font:getWidth(text) + 2 * width_padding
    local box_height = fancy_message.font:getHeight(text) + 2 * height_padding

    local x = map_width / 2 - box_width / 2
    local y = map_height / 2 - box_height / 2

    love.graphics.setFont(fancy_message.font)
    love.graphics.setColor(0, 0, 0, 175)
    love.graphics.rectangle('fill', x, y, box_width, box_height)
    love.graphics.setColor(255, 255, 255, 200)
    love.graphics.rectangle('line', x, y, box_width, box_height)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(text, x + width_padding, y + height_padding)
  end
end
