return function(world)
  return function(scene, dt)
    for player in pairs(scene:entities_with('velocity', 'position', 'size', 'player', 'jump')) do
      local collisions
      local resolved_x, resolved_y

      local dx = player.velocity.x * dt
      local dy = player.velocity.y * dt

      local target_x = player.position.x + dx
      local target_y = player.position.y + dy

      _, _, collisions = world:check(player, target_x, target_y,
        function()
          return 'cross'
        end)

      resolved_x = target_x
      resolved_y = target_y

      player.on_ground = false

      for _, collision in pairs(collisions) do
        local other = collision.other

        if collision.normal.y == -1 and other.solid and not collision.overlaps then
          local bounciness = other.bounciness or 0

          if bounciness == 0 then
            player.on_ground = true
            player.velocity.y = 0
          else
            player.velocity.y = -player.velocity.y * bounciness
          end

          scene:new_entity({
            event = true,
            jumped_on = {
              jumper = player,
              jumpee = other
            }
          })

          resolved_y = collision.touch.y
        else
          scene:new_entity({
            event = true,
            ran_into = {
              entity = player,
              other = other
            }
          })
        end
      end

      player.position.x = resolved_x
      player.position.y = resolved_y

      world:update(player, player.position.x, player.position.y)
    end
  end
end
