local bump = require 'lib/bump/bump'
local loader = require 'lib/advanced-tiled-loader/Loader'
local anim8 = require 'lib/anim8/anim8'
local Scene = require 'scene'

local scene

local world = bump.newWorld()

local gravity = 900

local tWidth = 16
local tHeight = 16

local playerCollideBoxL = 8
local playerCollideBoxR = 8
local playerCollideBoxY = 4

local map

local blocks = {}

local player
local playerSprite = love.graphics.newImage('res/sprite.png')

local a8 = anim8.newGrid(32, 32, playerSprite:getWidth(), playerSprite:getHeight())
local playerWalkRight = anim8.newAnimation(a8('1-8', 1), 0.1)
local playerWalkLeft = anim8.newAnimation(a8('8-1', 1), 0.1); playerWalkLeft:flipH()
local playerJumpRight = anim8.newAnimation(a8(4, 1), 0.1)
local playerJumpLeft = anim8.newAnimation(a8(4, 1), 0.1); playerJumpLeft:flipH()
local playerIdleRight = anim8.newAnimation(a8(1, 1), 0.1)
local playerIdleLeft = anim8.newAnimation(a8(1, 1), 0.1); playerIdleLeft:flipH()

function PlayerMovement(dt)
  if player.onGround then
    if player.jumpRel then
      player.vY = player.jumpAccel
      player.isJumping = true
      player.jumpRel = false
      player.jumpTimer = 0.065
    end
  elseif player.jumpRel == false and player.jumpTimer > 0 then
    player.vY = player.vY + player.jumpAccel * dt
  else
    player.jumpRel = false
  end

  local dx = 0

  if love.keyboard.isDown('left') then
    dx = -(player.speed * dt)
    if player.isJumping then
      player.animation = playerIdleLeft
    else
      player.animation = playerWalkLeft
    end
    player.dir = -1
  elseif love.keyboard.isDown('right') then
    dx = player.speed * dt
    if player.isJumping then
      player.animation = playerIdleRight
    else
      player.animation = playerWalkRight
    end
    player.dir = 1
  else
    if player.dir > 0 then
      player.animation = playerIdleRight
    else
      player.animation = playerIdleLeft
    end
  end

  if player.jumpTimer > 0 then
    player.jumpTimer = player.jumpTimer - dt
  end

  player.vY = player.vY + gravity * dt

  local dy = player.vY * dt

  dx, dy = CheckPlayerCollisionWithPlatform(dx, dy)

  player.t = player.t + dy
  player.l = player.l + dx

  world:move(player, player.l, player.t, player.w, player.h)

  if player.t > map.height * tHeight then Die() end

  player.animation:update(dt)
end

function PlayerSpawn(x, y)
  local left = x + playerCollideBoxL
  local width = 32 - playerCollideBoxL - playerCollideBoxR
  local height = 32 - playerCollideBoxY

  player = {
    name = 'player',
    sprite = playerSprite,
    l = x,
    t = y + playerCollideBoxY,
    w = width,
    h = height,
    vY = 0,
    dir = 1,
    onGround = true,
    jumping = false,
    jumpRel = false,
    jumpForce = 0,
    jumpAccel = -350,
    jumpTimer = 0,
    speed = 100,
    animation = playerIdleRight
  }

  world:add(player, player.l, player.t, player.w, player.h)
end

function CheckPlayerCollisionWithPlatform(dx, dy)
  player.onGround = false
  for _, collision in pairs(world:check(player, player.l + dx, player.t + dy) or {}) do
    local obj = collision.other
    if (player.t + player.h - 0.5) <= obj.t and (player.t + player.h + dy) > obj.t then
      player.onGround = true
      player.isJumping = false
      player.vY = 0
      dy = -(player.t + player.h - obj.t)
      break
    end
  end

  return dx, dy
end

function Die()
  player.l = 20
  player.t = 10
  player.dir = 1
  player.vY = 0
end

function DrawPlayer()
  player.animation:draw(player.sprite, player.l - playerCollideBoxL, player.t - playerCollideBoxY)
end

function LoadTileMap(levelFile)
  map = loader.load(levelFile)
  FindSolidTiles(map)
  map.drawObjects = false
end

function FindSolidTiles(map)
  local layer = map.layers['platform']
  for tileX = 1, map.width do
    for tileY = 1, map.height do
      local tile = layer(tileX - 1, tileY - 1)
      if tile then
        local block = {l = (tileX - 1) * 16, t = (tileY - 1) * 16, w = tWidth, h = tHeight, coordinates = {tileX, tileY}}
        blocks[block] = true
        world:add(block, block.l, block.t, block.w, block.h)
      end
    end
  end
end

function draw_backgrounds(scene)
  for entity in pairs(scene:entities_with('background', 'drawable')) do
    love.graphics.draw(entity.drawable)
  end
end

function love.keypressed(k)
  if k == 'up' or k == 'x' then
    player.jumpRel = true
  end
end

function love.load()
  scene = Scene()

  scene:add_render_system(draw_backgrounds)
  scene:add_render_system(function() map:draw() end)
  scene:add_render_system(DrawPlayer)

  scene:add_update_system(function(scene, dt) PlayerMovement(dt) end)

  scene:new_entity({
    background = true,
    drawable = love.graphics.newImage('res/background.png')
  })

  LoadTileMap('res/map.tmx')
  PlayerSpawn(20, 10)
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
