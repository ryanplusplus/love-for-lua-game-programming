local font = love.graphics.newFont(11)

local width_padding = 1
local height_padding = 1

return function(scene)
  for entity in pairs(scene:entities_with('hud')) do
    local hud = entity.hud
    for player in pairs(scene:entities_with('player', 'name', 'lives')) do
      if hud.player_name == player.name then
        local text = player.name .. ': ' .. player.lives
        local box_width = font:getWidth(text) + 2 * width_padding
        local box_height = font:getHeight(text) + 2 * height_padding

        love.graphics.setFont(font)
        love.graphics.setColor(255, 255, 255, 150)
        love.graphics.rectangle('line', hud.x, hud.y, box_width, box_height)
        love.graphics.setColor(0, 0, 0, 150)
        love.graphics.rectangle('fill', hud.x, hud.y, box_width, box_height)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, hud.x + width_padding, hud.y + height_padding)
      end
    end
  end
end
