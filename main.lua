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

local function init()
  scene = MenuScene(key_pressed, function()
    scene = LevelScene(key_pressed, key_held, controls, 'res/background.png', 'res/map.tmx', init, init)
  end)
end

function love.load()
  init()
end

function love.draw()
  scene:render()
end

function love.update(dt)
  scene:update(dt)
  reset_keys()
end
