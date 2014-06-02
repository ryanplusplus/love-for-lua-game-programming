local width = 10
local height = 10

function love.load()
  character = {}
  character.x = 300
  character.y = 400

  love.graphics.setBackgroundColor(255, 153, 0)

  love.graphics.setColor(0, 0, 225)
end

function love.update(dt)
  if love.keyboard.isDown('d') then
    character.x = character.x + 10 * dt
  end
  if love.keyboard.isDown('a') then
    character.x = character.x - 10 * dt
  end

  if love.keyboard.isDown('w') then
    character.y = character.y - 10 * dt
  end
  if love.keyboard.isDown('s') then
    character.y = character.y + 10 * dt
  end
end

function love.draw()
  love.graphics.rectangle('fill', character.x, character.y, width, height)
end
