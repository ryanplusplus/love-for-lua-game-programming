local LevelScene = require 'level/Scene'
local MenuScene = require 'menu/Scene'

local scene

local key_pressed = {}
local key_held = {}

local controls = {
  player1 = { left = 'left', right = 'right', jump = 'up' },
  player2 = { left = 'z', right = 'x', jump = 's' }
}

function love.keypressed(k)
  key_pressed[k] = true
  key_held[k] = true
end

function love.keyreleased(k)
  key_held[k] = nil
end

local function reset_keys()
  for key in pairs(key_pressed) do
    key_pressed[key] = nil
  end
end

local load_level_1
local load_level_2

local function load_menu()
  scene = MenuScene(key_pressed, load_level_1)
end

function load_level_1()
  scene = LevelScene(key_pressed, key_held, controls, 'res/background.png', 'res/level1.tmx', load_menu, load_level_2)
end

function load_level_2()
  scene = LevelScene(key_pressed, key_held, controls, 'res/background.png', 'res/level2.tmx', load_menu, load_menu)
end

function love.load()
  load_menu()
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
  reset_keys()
end
