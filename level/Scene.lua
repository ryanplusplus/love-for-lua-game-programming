local World = (require 'lib/bump/bump').newWorld
local Scene = require '/lib/scene/Scene'
local Map = require 'utility/Map'
local Player = require 'entity/Player'
local Enemy = require 'entity/Enemy'
local ExtraLife = require 'entity/ExtraLife'
local Background = require 'entity/Background'
local Hud = require 'entity/Hud'

local UpdatePipeline = require 'level/UpdatePipeline'
local RenderPipeline = require 'level/RenderPipeline'

return function(key_pressed, key_held, background, map, on_game_over, on_win)
  local world = World()
  local scene = Scene()

  for _, render_system in ipairs(RenderPipeline(world, key_pressed, key_held)) do
    scene:add_render_system(render_system)
  end

  for _, update_system in ipairs(UpdatePipeline(world, key_pressed, key_held, on_game_over, on_win)) do
    scene:add_update_system(update_system)
  end

  scene:add_update_system(reset_keys)

  local map, entities = Map(world, map)

  scene:new_entity({
    background = Background(background),
    map = map
  })

  for _, entity in ipairs(entities) do
    scene:new_entity(entity)
  end

  scene:new_entity(Hud({ player_name = 'player1', x = 635, y = 5, justify = 'right' }))
  scene:new_entity(Hud({ player_name = 'player2', x = 635, y = 25, justify = 'right' }))
  -- scene:new_entity(Player(20, 10, 'player1', { left = 'left', right = 'right', jump = 'up' }))
  -- scene:new_entity(Player(50, 10, 'player2', { left = 'z', right = 'x', jump = 's' }))
  scene:new_entity(Enemy(500, 10))
  scene:new_entity(Enemy(100, 200))
  scene:new_entity(Enemy(350, 250))
  scene:new_entity(Enemy(350, 400))
  scene:new_entity(ExtraLife(248, 76))
  scene:new_entity(ExtraLife(416, 300))
  scene:new_entity(ExtraLife(65, 284))

  return scene
end
