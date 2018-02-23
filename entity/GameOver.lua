return function()
  local entity = require 'entity/FancyMessage'(22, 'Game Over - Press Enter to Continue')
  entity.game_over = true
  return entity
end
