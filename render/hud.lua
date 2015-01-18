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

        local x = hud.x
        local y = hud.y

        if hud.justify == 'right' then
          x = x - box_width
        end

        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0, 175)
        love.graphics.rectangle('fill', x, y, box_width, box_height)
        love.graphics.setColor(255, 255, 255, 200)
        love.graphics.rectangle('line', x, y, box_width, box_height)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, x + width_padding, y + height_padding)
      end
    end
  end
end
