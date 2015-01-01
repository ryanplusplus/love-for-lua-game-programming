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

local map

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
  end
end

function update_gravity(scene, dt)
  for entity in pairs(scene:entities_with('has_mass', 'velocity')) do
    entity.velocity.y = entity.velocity.y + gravity * dt
  end
end

function spawn_player(scene, x, y, controls)
  local sprite = love.graphics.newImage('res/sprite.png')

  local a8 = anim8.newGrid(32, 32, sprite:getWidth(), sprite:getHeight())
  local walk_right = anim8.newAnimation(a8('1-8', 1), 0.1)
  local walk_left = anim8.newAnimation(a8('8-1', 1), 0.1); walk_left:flipH()
  local jump_right = anim8.newAnimation(a8(4, 1), 0.1)
  local jump_left = anim8.newAnimation(a8(4, 1), 0.1); jump_left:flipH()
  local idle_right = anim8.newAnimation(a8(1, 1), 0.1)
  local idle_left = anim8.newAnimation(a8(1, 1), 0.1); idle_left:flipH()

  local entity = scene:new_entity({
    dies_when_off_stage = true,
    position = {
      x = x,
      y = y
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
    has_mass = true,
    on_ground = true,
    jump = {
      jumping = false,
      jump_rel = false,
      jump_acceleration = -350,
      jump_timer = 0,
      key = controls.jump
    },
    size = {
      width = 16,
      height = 28
    },
    animation = {
      current = idle_right,
      sprite = sprite,
      offset = {
        x = -8,
        y = -4
      }
    },
    animated_movement = {
      walk_right = walk_right,
      walk_left = walk_left,
      air_right = jump_right,
      air_left = jump_left,
      idle_right = idle_right,
      idle_left = idle_left
    }
  })

  world:add(entity, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
end

function check_collisions(entity, dx, dy)
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

function render_animation(scene)
  for entity in pairs(scene:entities_with('animation', 'position')) do
    local animation = entity.animation
    animation.current:draw(animation.sprite, entity.position.x + animation.offset.x, entity.position.y + animation.offset.y)
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
    entity.animation.current:update(dt)
  end
end

function update_position(scene, dt)
  for entity in pairs(scene:entities_with('velocity', 'position', 'size')) do
    local dy = entity.velocity.y * dt
    local dx = entity.velocity.x * dt

    dx, dy = check_collisions(entity, dx, dy)

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
  for entity in pairs(scene:entities_with('animation', 'position', 'left_right', 'jump', 'direction')) do
    if love.keyboard.isDown(entity.left_right.left_key) then
      entity.velocity.x = -entity.left_right.speed
      entity.direction = -1
    elseif love.keyboard.isDown(entity.left_right.right_key) then
      entity.velocity.x = entity.left_right.speed
      entity.direction = 1
    else
      entity.velocity.x = 0
    end
  end
end

function select_movement_animation(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'velocity', 'on_ground', 'direction', 'animated_movement')) do
    if entity.velocity.x < 0 then
      if entity.on_ground then
        entity.animation.current = entity.animated_movement.walk_left
      else
        entity.animation.current = entity.animated_movement.air_left
      end
    elseif entity.velocity.x > 0 then
      if entity.on_ground then
        entity.animation.current = entity.animated_movement.walk_right
      else
        entity.animation.current = entity.animated_movement.air_right
      end
    else
      if entity.direction > 0 then
        entity.animation.current = entity.animated_movement.idle_right
      else
        entity.animation.current = entity.animated_movement.idle_left
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
  scene:add_render_system(render_animation)

  scene:add_update_system(update_jump)
  scene:add_update_system(update_left_right)
  scene:add_update_system(select_movement_animation)
  scene:add_update_system(update_gravity)
  scene:add_update_system(update_position)
  scene:add_update_system(die_when_off_stage)
  scene:add_update_system(update_animations)
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = true,
    drawable = love.graphics.newImage('res/background.png')
  })

  load_tile_map('res/map.tmx')
  spawn_player(scene, 20, 10, { left = 'left', right = 'right', jump = 'up' })
  spawn_player(scene, 50, 10, { left = 'z', right = 'x', jump = 's' })
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
