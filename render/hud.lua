return function(scene)
  for entity in pairs(scene:entities_with('hud')) do
    local hud = entity.hud
    for player in pairs(scene:entities_with('player', 'name', 'lives')) do
      if hud.player_name == player.name then
        love.graphics.print(player.name .. ': ' .. player.lives, hud.x, hud.y)
      end
    end
  end
end
