return function(file)
  local background = love.graphics.newImage(file)

  return {
    draw = function()
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.draw(background)
    end
  }
end
