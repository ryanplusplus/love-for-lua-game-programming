return function(text, x, y, font_size)
  return {
    position = {
      x = x,
      y = y
    },
    font = love.graphics.newFont(font_size),
    text = text
  }
end
