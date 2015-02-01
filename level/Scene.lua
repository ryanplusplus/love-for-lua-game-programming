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

return function(key_pressed, key_held, controls, background, map, on_game_over, on_win)
  local world = World()
  local scene = Scene()

  for _, render_system in ipairs(RenderPipeline(world, key_pressed, key_held)) do
    scene:add_render_system(render_system)
  end

  for _, update_system in ipairs(UpdatePipeline(world, key_pressed, key_held, on_game_over, on_win)) do
    scene:add_update_system(update_system)
  end

  scene:add_update_system(reset_keys)

  local map, entities = Map(world, map, {
    Player = Player(controls),
    Enemy = Enemy,
    ExtraLife = ExtraLife
  })

  scene:new_entity({
    background = Background(background),
    map = map
  })

  for _, entity in ipairs(entities) do
    scene:new_entity(entity)
  end

  scene:new_entity(Hud({ player_name = 'player1', x = 635, y = 5, justify = 'right' }))
  scene:new_entity(Hud({ player_name = 'player2', x = 635, y = 25, justify = 'right' }))

  return scene
end
