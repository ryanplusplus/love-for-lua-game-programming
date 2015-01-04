local World = (require 'lib/bump/bump').newWorld
local Scene = require 'scene'
local Map = require 'Map'
local Player = require 'Player'

local scene

local world = World()

local key_pressed = {}
local key_held = {}

local gravity = 900

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

function reset_keys()
  for key in pairs(key_pressed) do
    key_pressed[key] = nil
  end
end

function love.keypressed(k)
  key_pressed[k] = true
  key_held[k] = true
end

function love.keyreleased(k)
  key_held[k] = nil
end

function love.load()
  scene = Scene()

  scene:add_render_system(render_background)
  scene:add_render_system(render_map)
  scene:add_render_system(render_animation)

  scene:add_update_system((require 'update_system/AddToWorld')(world))
  scene:add_update_system((require 'update_system/Jump')(key_pressed))
  scene:add_update_system((require 'update_system/LeftRight')(key_held))
  scene:add_update_system(require 'update_system/movement_animation')
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
