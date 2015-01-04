return function(file)
  local background = love.graphics.newImage(file)

  return {
    draw = function()
      love.graphics.draw(background)
    end
  }
end
