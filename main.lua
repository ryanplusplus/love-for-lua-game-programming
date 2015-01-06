local World = (require 'lib/bump/bump').newWorld
local Scene = require 'Scene'
local Map = require 'Map'
local Player = require 'Player'
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

  scene:add_render_system((require 'render_system/Drawable')('background'))
  scene:add_render_system((require 'render_system/Drawable')('map'))
  scene:add_render_system(require 'render_system/animation')

  scene:add_update_system((require 'update_system/AddToWorld')(world))
  scene:add_update_system((require 'update_system/Jump')(key_pressed))
  scene:add_update_system((require 'update_system/LeftRight')(key_held))
  scene:add_update_system(require 'update_system/movement_animation')
  scene:add_update_system((require 'update_system/Gravity')(900))
  scene:add_update_system((require 'update_system/PlayerPosition')(world))
  scene:add_update_system(require 'update_system/die_when_off_stage')
  scene:add_update_system(require 'update_system/respawn')
  scene:add_update_system(require 'update_system/animation')
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = Background('res/background.png'),
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
