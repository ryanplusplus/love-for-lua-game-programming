local World = (require 'lib/bump/bump').newWorld
local Scene = require 'scene'
local Map = require 'Map'
local Player = require 'Player'

local scene

local world = World()

local key_pressed = {}

local gravity = 900

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

function render_animation(scene)
  for entity in pairs(scene:entities_with('animation', 'position')) do
    entity.animation:render(entity.position.x, entity.position.y)
  end
end

function render_background(scene)
  for entity in pairs(scene:entities_with('background')) do
    love.graphics.draw(entity.background)
  end
end

function render_map(scene)
  for entity in pairs(scene:entities_with('map')) do
    entity.map:draw()
  end
end

function update_animations(scene, dt)
  for entity in pairs(scene:entities_with('animation')) do
    entity.animation:update(dt)
  end
end

function update_player_position(scene, dt)
  for entity in pairs(scene:entities_with('velocity', 'position', 'size', 'player')) do
    local collisions
    local resolved_x, resolved_y

    local dx = entity.velocity.x * dt
    local dy = entity.velocity.y * dt

    local target_x = entity.position.x + dx
    local target_y = entity.position.y + dy

    _, _, collisions = world:check(entity, target_x, target_y, function() return 'cross' end)

    resolved_x = target_x
    resolved_y = target_y

    entity.on_ground = false

    for _, collision in pairs(collisions) do
      if collision.normal.y == -1 and not collision.overlaps then
        entity.on_ground = true
        entity.jump.jumping = false
        entity.velocity.y = 0
        resolved_y = collision.touch.y
      end
    end

    entity.position.x = resolved_x
    entity.position.y = resolved_y

    world:update(entity, entity.position.x, entity.position.y)
  end
end

function die_when_off_stage(scene, dt)
  local map_height
  local tile_height

  for entity in pairs(scene:entities_with('map')) do
    map_height = entity.map.height
    tile_height = entity.map.tileHeight
  end

  for entity in pairs(scene:entities_with('dies_when_off_stage', 'position', 'velocity')) do
    if entity.position.y > map_height * tile_height then
      entity.position.x = 20
      entity.position.y = 10
      entity.direction = 'right'
      entity.velocity.y = 0
    end
  end
end

function update_left_right(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'position', 'left_right', 'jump', 'direction')) do
    if love.keyboard.isDown(entity.left_right.left_key) then
      entity.velocity.x = -entity.left_right.speed
      entity.direction = 'left'
    elseif love.keyboard.isDown(entity.left_right.right_key) then
      entity.velocity.x = entity.left_right.speed
      entity.direction = 'right'
    else
      entity.velocity.x = 0
    end
  end
end

function update_movement_animation(scene, dt)
  for entity in pairs(scene:entities_with('animation', 'velocity', 'on_ground', 'direction', 'movement_animations')) do
    if entity.velocity.x < 0 then
      if entity.on_ground then
        entity.animation:select(entity.movement_animations.walk_left)
      else
        entity.animation:select(entity.movement_animations.air_left)
      end
    elseif entity.velocity.x > 0 then
      if entity.on_ground then
        entity.animation:select(entity.movement_animations.walk_right)
      else
        entity.animation:select(entity.movement_animations.air_right)
      end
    else
      if entity.direction == 'right' then
        entity.animation:select(entity.movement_animations.idle_right)
      else
        entity.animation:select(entity.movement_animations.idle_left)
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

  scene:add_update_system((require 'update_system/AddToWorld')(world))
  scene:add_update_system(update_jump)
  scene:add_update_system(update_left_right)
  scene:add_update_system(update_movement_animation)
  scene:add_update_system(update_gravity)
  scene:add_update_system(update_player_position)
  scene:add_update_system(die_when_off_stage)
  scene:add_update_system(update_animations)
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = love.graphics.newImage('res/background.png'),
    map = Map(world, 'res/map.tmx')
  })

  scene:new_entity(Player(world, 20, 10, { left = 'left', right = 'right', jump = 'up' }))
  scene:new_entity(Player(world, 50, 10, { left = 'z', right = 'x', jump = 's' }))
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
