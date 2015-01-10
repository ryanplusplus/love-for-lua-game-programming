local World = (require 'lib/bump/bump').newWorld
local Scene = require 'Scene'
local Map = require 'Map'
local Player = require 'Player'
local Enemy = require 'Enemy'
local Background = require 'Background'

local scene

local key_pressed = {}
local key_held = {}

function love.keypressed(k)
  key_pressed[k] = true
  key_held[k] = true
end

function love.keyreleased(k)
  key_held[k] = nil
end

function reset_keys()
  for key in pairs(key_pressed) do
    key_pressed[key] = nil
  end
end

function love.load()
  local world = World()

  scene = Scene()

  scene:add_render_system((require 'render/Drawable')('background'))
  scene:add_render_system((require 'render/Drawable')('map'))
  scene:add_render_system(require 'render/animation')

  scene:add_update_system((require 'update/AddToWorld')(world))
  scene:add_update_system((require 'update/Jump')(key_pressed))
  scene:add_update_system((require 'update/LeftRight')(key_held))
  scene:add_update_system(require 'update/movement_animation')
  scene:add_update_system((require 'update/Gravity')(900))
  scene:add_update_system(require 'update/basic_enemy_ai')
  scene:add_update_system((require 'update/PlayerPosition')(world))
  scene:add_update_system((require 'update/EnemyPosition')(world))
  scene:add_update_system(require 'update/die_when_off_stage')
  scene:add_update_system(require 'update/respawn')
  scene:add_update_system(require 'update/remove_dead')
  scene:add_update_system(require 'update/animation')
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = Background('res/background.png'),
    map = Map(world, 'res/map.tmx')
  })

  scene:new_entity(Player(world, 20, 10, { left = 'left', right = 'right', jump = 'up' }))
  scene:new_entity(Player(world, 50, 10, { left = 'z', right = 'x', jump = 's' }))
  scene:new_entity(Enemy(world, 400, 10))
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
