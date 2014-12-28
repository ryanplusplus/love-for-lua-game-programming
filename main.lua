local bump = require 'lib/bump/bump'
local loader = require 'lib/advanced-tiled-loader/Loader'
local anim8 = require 'lib/anim8/anim8'
local Scene = require 'scene'

local scene

local world = bump.newWorld()

local key_pressed = {}

local gravity = 900

local tWidth = 16
local tHeight = 16

local playerCollideBoxL = 8
local playerCollideBoxR = 8
local playerCollideBoxY = 4

local map

local blocks = {}

local playerSprite = love.graphics.newImage('res/sprite.png')

local a8 = anim8.newGrid(32, 32, playerSprite:getWidth(), playerSprite:getHeight())
local playerWalkRight = anim8.newAnimation(a8('1-8', 1), 0.1)
local playerWalkLeft = anim8.newAnimation(a8('8-1', 1), 0.1); playerWalkLeft:flipH()
local playerJumpRight = anim8.newAnimation(a8(4, 1), 0.1)
local playerJumpLeft = anim8.newAnimation(a8(4, 1), 0.1); playerJumpLeft:flipH()
local playerIdleRight = anim8.newAnimation(a8(1, 1), 0.1)
local playerIdleLeft = anim8.newAnimation(a8(1, 1), 0.1); playerIdleLeft:flipH()

function player_movement(scene, dt)
  for entity in pairs(scene:entities_with('player', 'animation', 'position', 'size')) do
    local player = entity.player

    if player.onGround then
      if player.jumpRel then
        entity.velocity.y = player.jumpAccel
        player.isJumping = true
        player.jumpRel = false
        player.jumpTimer = 0.065
      end
    elseif player.jumpRel == false and player.jumpTimer > 0 then
      entity.velocity.y = entity.velocity.y + player.jumpAccel * dt
    else
      player.jumpRel = false
    end

    if key_pressed['up'] or key_pressed['x'] then
      player.jumpRel = true
    end

    entity.velocity.x = 0

    if love.keyboard.isDown('left') then
      entity.velocity.x = -player.speed
      if player.isJumping then
        entity.animation = playerIdleLeft
      else
        entity.animation = playerWalkLeft
      end
      player.dir = -1
    elseif love.keyboard.isDown('right') then
      entity.velocity.x = player.speed
      if player.isJumping then
        entity.animation = playerIdleRight
      else
        entity.animation = playerWalkRight
      end
      player.dir = 1
    else
      if player.dir > 0 then
        entity.animation = playerIdleRight
      else
        entity.animation = playerIdleLeft
      end
    end

    if player.jumpTimer > 0 then
      player.jumpTimer = player.jumpTimer - dt
    end

    entity.velocity.y = entity.velocity.y + gravity * dt

    local dy = entity.velocity.y * dt
    local dx = entity.velocity.x * dt

    dx, dy = CheckPlayerCollisionWithPlatform(entity, dx, dy)

    entity.position.y = entity.position.y + dy
    entity.position.x = entity.position.x + dx

    world:move(player, entity.position.x, entity.position.y, player.w, player.h)

    if entity.position.y > map.height * tHeight then Die(entity) end
  end
end

function SpawnPlayer(scene, x, y)
  local left = x + playerCollideBoxL
  local width = 32 - playerCollideBoxL - playerCollideBoxR
  local height = 32 - playerCollideBoxY

  local entity = scene:new_entity({
    position = {
      x = x,
      y = y + playerCollideBoxY
    },
    size = {
      width = width,
      height = height
    },
    velocity = {
      x = 0,
      y = 0
    },
    acceleration = {
      x = 0,
      y = 0
    },
    player = {
      name = 'player',
      sprite = playerSprite,
      dir = 1,
      onGround = true,
      jumping = false,
      jumpRel = false,
      jumpForce = 0,
      jumpAccel = -350,
      jumpTimer = 0,
      speed = 100,
    },
    animation = playerIdleRight
  })

  world:add(entity.player, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
end

function CheckPlayerCollisionWithPlatform(entity, dx, dy)
  local player = entity.player
  local size = entity.size
  local position = entity.position
  local velocity = entity.velocity
  player.onGround = false
  for _, collision in pairs(world:check(player, position.x + dx, position.y + dy) or {}) do
    local obj = collision.other
    if (position.y + size.height - 0.5) <= obj.t and (position.y + size.height + dy) > obj.t then
      player.onGround = true
      player.isJumping = false
      velocity.y = 0
      dy = -(position.y + size.height - obj.t)
      break
    end
  end

  return dx, dy
end

function Die(entity)
  entity.position.x = 20
  entity.position.y = 10
  entity.player.dir = 1
  entity.velocity.y = 0
end

function DrawPlayer(scene)
  for entity in pairs(scene:entities_with('player', 'animation', 'position')) do
    local player = entity.player
    entity.animation:draw(player.sprite, entity.position.x - playerCollideBoxL, entity.position.y - playerCollideBoxY)
  end
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

function update_animations(scene, dt)
  for entity in pairs(scene:entities_with('animation')) do
    entity.animation:update(dt)
  end
end

function reset_keys()
  key_pressed = {}
end

function love.keypressed(k)
  key_pressed[k] = true
end

function love.load()
  scene = Scene()

  scene:add_render_system(draw_backgrounds)
  scene:add_render_system(function() map:draw() end)
  scene:add_render_system(DrawPlayer)

  scene:add_update_system(player_movement)
  scene:add_update_system(update_animations)
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = true,
    drawable = love.graphics.newImage('res/background.png')
  })

  LoadTileMap('res/map.tmx')
  SpawnPlayer(scene, 20, 10)
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
