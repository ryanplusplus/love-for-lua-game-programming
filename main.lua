local bump = require 'lib/bump/bump'
local loader = require 'lib/advanced-tiled-loader/Loader'
local anim8 = require 'lib/anim8/anim8'
local Scene = require 'scene'

local scene

local world = bump.newWorld()

local key_pressed = {}

local gravity = 900

local tile_width = 16
local tile_height = 16

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

function update_jump(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'position', 'size', 'jump')) do
    if entity.on_ground then
      if entity.jump.jump_rel then
        entity.velocity.y = entity.jump.jump_acceleration
        entity.jump.jumping = true
        entity.jump.jump_rel = false
        entity.jump.jump_timer = 0.065
      end
    elseif entity.jump.jump_rel == false and entity.jump.jump_timer > 0 then
      entity.velocity.y = entity.velocity.y + entity.jump.jump_acceleration * dt
    else
      entity.jump.jump_rel = false
    end

    if key_pressed[entity.jump.key] then
      entity.jump.jump_rel = true
    end

    if entity.jump.jump_timer > 0 then
      entity.jump.jump_timer = entity.jump.jump_timer - dt
    end

    entity.velocity.y = entity.velocity.y + gravity * dt
  end
end

function SpawnPlayer(scene, x, y, controls)
  local left = x + playerCollideBoxL
  local width = 32 - playerCollideBoxL - playerCollideBoxR
  local height = 32 - playerCollideBoxY

  local entity = scene:new_entity({
    dies_when_off_stage = true,
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
    name = 'player',
    direction = 1,
    left_right = {
      left_key = controls.left,
      right_key = controls.right,
      speed = 100
    },
    on_ground = true,
    jump = {
      jumping = false,
      jump_rel = false,
      jump_acceleration = -350,
      jump_timer = 0,
      key = controls.jump
    },
    player = {
      sprite = playerSprite,
    },
    animation = playerIdleRight
  })

  world:add(entity, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
end

function CheckPlayerCollisionWithPlatform(entity, dx, dy)
  local player = entity.player
  local size = entity.size
  local position = entity.position
  local velocity = entity.velocity
  entity.on_ground = false
  for _, collision in pairs(world:check(entity, position.x + dx, position.y + dy) or {}) do
    local obj = collision.other
    if (position.y + size.height - 0.5) <= obj.position.y and (position.y + size.height + dy) > obj.position.y then
      entity.on_ground = true
      entity.jump.jumping = false
      velocity.y = 0
      dy = -(position.y + size.height - obj.position.y)
      break
    end
  end

  return dx, dy
end

function render_player(scene)
  for entity in pairs(scene:entities_with('player', 'animation', 'position')) do
    local player = entity.player
    entity.animation:draw(player.sprite, entity.position.x - playerCollideBoxL, entity.position.y - playerCollideBoxY)
  end
end

function load_tile_map(levelFile)
  map = loader.load(levelFile)
  find_solid_tiles(map)
  map.drawObjects = false
end

function find_solid_tiles(map)
  local layer = map.layers['platform']
  for tileX = 1, map.width do
    for tileY = 1, map.height do
      local tile = layer(tileX - 1, tileY - 1)
      if tile then
        local block = {
          position = {
            x = (tileX - 1) * 16,
            y = (tileY - 1) * 16
          },
          size = {
            width = tile_width,
            height = tile_height
          }
        }
        blocks[block] = true
        world:add(block, block.position.x, block.position.y, block.size.width, block.size.height)
      end
    end
  end
end

function render_background(scene)
  for entity in pairs(scene:entities_with('background', 'drawable')) do
    love.graphics.draw(entity.drawable)
  end
end

function render_map(scene)
  map:draw()
end

function update_animations(scene, dt)
  for entity in pairs(scene:entities_with('animation')) do
    entity.animation:update(dt)
  end
end

function update_position(scene, dt)
  for entity in pairs(scene:entities_with('velocity', 'position')) do
    local dy = entity.velocity.y * dt
    local dx = entity.velocity.x * dt

    dx, dy = CheckPlayerCollisionWithPlatform(entity, dx, dy)

    entity.position.y = entity.position.y + dy
    entity.position.x = entity.position.x + dx

    world:move(entity, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
  end
end

function die_when_off_stage(scene, dt)
  for entity in pairs(scene:entities_with('dies_when_off_stage', 'position', 'velocity')) do
    if entity.position.y > map.height * tile_height then
      entity.position.x = 20
      entity.position.y = 10
      entity.direction = 1
      entity.velocity.y = 0
    end
  end
end

function update_left_right(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'position', 'left_right')) do
    entity.velocity.x = 0

    if love.keyboard.isDown(entity.left_right.left_key) then
      entity.velocity.x = -entity.left_right.speed
      if entity.jump.jumping then
        entity.animation = playerIdleLeft
      else
        entity.animation = playerWalkLeft
      end
      entity.direction = -1
    elseif love.keyboard.isDown(entity.left_right.right_key) then
      entity.velocity.x = entity.left_right.speed
      if entity.jump.jumping then
        entity.animation = playerIdleRight
      else
        entity.animation = playerWalkRight
      end
      entity.direction = 1
    else
      if entity.direction > 0 then
        entity.animation = playerIdleRight
      else
        entity.animation = playerIdleLeft
      end
    end
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

  scene:add_render_system(render_background)
  scene:add_render_system(render_map)
  scene:add_render_system(render_player)

  scene:add_update_system(update_jump)
  scene:add_update_system(update_left_right)
  scene:add_update_system(update_position)
  scene:add_update_system(die_when_off_stage)
  scene:add_update_system(update_animations)
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = true,
    drawable = love.graphics.newImage('res/background.png')
  })

  load_tile_map('res/map.tmx')
  SpawnPlayer(scene, 20, 10, { left = 'left', right = 'right', jump = 'up' })
  SpawnPlayer(scene, 50, 10, { left = 'z', right = 'x', jump = 's' })
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
