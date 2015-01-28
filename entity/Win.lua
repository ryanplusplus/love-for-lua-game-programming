return function()
  local entity = (require 'entity/FancyMessage')(22, 'Congraturation, You Are Win! Press Entar')
  entity.win = true
  return entity
end
