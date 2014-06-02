function love.load()
  quads = {}
  quads['left'] = {}
  quads['right'] = {}

  for j = 1, 8 do
    quads['right'][j] = love.graphics.newQuad((j - 1) * 32, 0, 32, 32, 256, 32);
    quads['left'][j] = love.graphics.newQuad((j) * 32, 0, -32, 32, 256, 32);
  end

  sprite = {
    player = love.graphics.newImage('res/sprite.png'),
    x = 50,
    y = 50,
    direction = 'right',
    idle = true,
    animation = {
      iteration = 1,
      count = 8
    }
  }

  timer = 0
end

function love.update(dt)
  if not sprite.idle then
    timer = timer + dt
    if timer > 0.1 then
      timer = 0

      sprite.animation.iteration = sprite.animation.iteration + 1

      if love.keyboard.isDown('right') then
        sprite.x = sprite.x + 5
      end

      if love.keyboard.isDown('left') then
        sprite.x = sprite.x - 5
      end

      if sprite.animation.iteration > sprite.animation.count then
        sprite.animation.iteration = 1
      end
    end
  end
end

function love.keypressed(key)
  if key == 'left' or key == 'right' then
    sprite.direction = key
    sprite.idle = false
  end
end

function love.keyreleased(key)
  if (key == 'left' or key == 'right') and sprite.direction == key then
    sprite.idle = true
    sprite.animation.iteration = 1
    -- sprite.direction = key
  end
end

function love.draw()
  local xscale = 1
  if sprite.direction == 'left' then xscale = -1 end
  love.graphics.draw(sprite.player, quads[sprite.direction][sprite.animation.iteration], sprite.x, sprite.y, 0, xscale, 1)
end
