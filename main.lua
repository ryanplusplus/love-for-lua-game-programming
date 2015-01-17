local World = (require 'lib/bump/bump').newWorld
local Scene = require '/lib/scene/Scene'
local Map = require 'entity/Map'
local Player = require 'entity/Player'
local Enemy = require 'entity/Enemy'
local ExtraLife = require 'entity/ExtraLife'
local Background = require 'entity/Background'
local Hud = require 'entity/Hud'

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
  scene:add_render_system((require 'render/Animation')({ 'player', 'enemy', 'pickup' }))
  scene:add_render_system(require 'render/hud')

  scene:add_update_system((require 'update/AddToWorld')(world))
  scene:add_update_system((require 'update/Jump')(key_pressed))
  scene:add_update_system((require 'update/LeftRight')(key_held))
  scene:add_update_system(require 'update/movement_animation')
  scene:add_update_system((require 'update/Gravity')(900))
  scene:add_update_system((require 'update/basic_enemy_ai')(world))
  scene:add_update_system((require 'update/PlayerPosition')(world))
  scene:add_update_system((require 'update/EnemyPosition')(world))
  scene:add_update_system((require 'update/NonInteractingPosition')(world))
  scene:add_update_system((require 'update/ExtraLife')(world))
  scene:add_update_system(require 'update/die_when_off_stage')
  scene:add_update_system(require 'update/spawn_on_death')
  scene:add_update_system((require 'update/respawn')(world))
  scene:add_update_system((require 'update/remove_dead')(world))
  scene:add_update_system(require 'update/remove_when_animation_complete')
  scene:add_update_system(require 'update/animation')
  scene:add_update_system(reset_keys)

  scene:new_entity({
    background = Background('res/background.png'),
    map = Map(world, 'res/map.tmx')
  })

  scene:new_entity(Hud('player1', 5, 5))
  scene:new_entity(Hud('player2', 5, 25))
  scene:new_entity(Player(20, 10, 'player1', { left = 'left', right = 'right', jump = 'up' }))
  scene:new_entity(Player(50, 10, 'player2', { left = 'z', right = 'x', jump = 's' }))
  scene:new_entity(Enemy(500, 10))
  scene:new_entity(Enemy(100, 200))
  scene:new_entity(Enemy(350, 250))
  scene:new_entity(Enemy(350, 400))
  scene:new_entity(ExtraLife(248, 76))
  scene:new_entity(ExtraLife(416, 300))
  scene:new_entity(ExtraLife(65, 284))
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
end
