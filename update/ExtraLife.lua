return function(world)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('extra_life', 'position')) do
      _, _, collisions = world:check(entity, entity.position.x, entity.position.y,
        function(_, other) if other.player then return 'cross' end end
      )

      if #collisions > 0 then
        local player = collisions[1].other
        if player.lives then
          player.lives = player.lives + 1
        end
        entity.dead = true
      end
    end
  end
end
