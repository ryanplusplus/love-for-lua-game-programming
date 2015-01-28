return function(font_size, text)
  return {
    fancy_message = {
      font = love.graphics.newFont(font_size),
      text = text
    }
  }
end
