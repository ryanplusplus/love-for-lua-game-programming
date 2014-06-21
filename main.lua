local bump = require('lib/bump/bump')
local loader = require('lib/advanced-tiled-loader/Loader')
local anim8 = require('lib/anim8/anim8')

local world = bump.newWorld()

local gravity = 400

local tWidth = 16
local tHeight = 16

local playerCollideBoxL = 8
local playerCollideBoxR = 8
local playerCollideBoxY = 4

local map

local player
local playerSprite = love.graphics.newImage('res/sprite.png')

local a8 = anim8.newGrid(32, 32, playerSprite:getWidth(), playerSprite:getHeight())
local playerWalkRight = anim8.newAnimation(a8('1-8', 1), 0.1)
local playerWalkLeft = anim8.newAnimation(a8('8-1', 1), 0.1); playerWalkLeft:flipH()
local playerJumpRight = anim8.newAnimation(a8(4, 1), 0.1)
local playerJumpLeft = anim8.newAnimation(a8(4, 1), 0.1); playerJumpLeft:flipH()
local playerIdleRight = anim8.newAnimation(a8(1, 1), 0.1)
local playerIdleLeft = anim8.newAnimation(a8(1, 1), 0.1); playerIdleLeft:flipH()

local bg = love.graphics.newImage('res/background.png')

function PlayerMovement(dt)
  if player.onGround then
    if player.jumpRel then
      player.vY = player.jumpAccel
      player.isJumping = true
      player.jumpRel = false
      player.jumpTimer = 0.065
    end
  elseif player.isJumping and player.jumpRel == false then
    if player.jumpTimer > 0 then
      player.vY = player.vY + player.jumpAccel * dt
    end
  end

  if love.keyboard.isDown('left') then
    player.l = player.l - player.speed *dt
    player.animation = playerWalkLeft
    player.dir = -1
  elseif love.keyboard.isDown('right') then
    player.l = player.l + player.speed *dt
    player.animation = playerWalkRight
    player.dir = 1
  else
    if player.dir > 0 then
      player.animation = playerIdleRight
    else
      player.animation = playerIdleLeft
    end
  end

  player.vY = player.vY + gravity * dt
  player.t = player.t + player.vY * dt

  player.animation:update(dt)
end

function PlayerSpawn(x, y)
  local left = x + playerCollideBoxL
  local right = 32
  local height = 32 - playerCollideBoxY

  player = {
    name = 'player',
    sprite = playerSprite,
    l = x,
    t = y + playerCollideBoxY,
    w = right,
    h = height,
    vY = 0,
    dir = 1,
    onGround = true,
    jumping = false,
    jumpRel = false,
    jumpForce = 0,
    jumpAccel = -200,
    speed = 100,
    animation = playerIdleRight
  }

  world:add(player, player.l, player.t, player.w, player.h)
end

function DrawPlayer()
  player.animation:draw(player.sprite, player.l - playerCollideBoxL, player.t - playerCollideBoxY)
end

function LoadTileMap(levelFile)
  map = loader.load(levelFile)
  FindSolidTiles(map)
  map.drawObjects = false
end

local blocks = {}
function FindSolidTiles(map)
  local layer = map.layers['platform']
  for tileX = 1, map.width do
    for tileY = 1, map.height do
      local tile = layer(tileX - 1, tileY - 1)
      if tile then
        local block = {l = (tileX - 1) * 16, t = (tileY - 1) * 16, w = tWidth, h = tHeight}
        blocks[#blocks + 1] = block
        world:add(block, block.l, block.t, block.w, block.h)
      end
    end
  end
end

function love.keypressed(k)
  if k == 'up' or k == 'x' then
    player.jumpRel = true
  end
end

function love.load()
  LoadTileMap('res/map.tmx')
  PlayerSpawn(50, 40)
end

function love.draw()
  love.graphics.draw(bg)
  map:draw()
  DrawPlayer()
end

function love.update(dt)
  PlayerMovement(dt)
end
