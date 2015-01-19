return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'ran_into')) do
    local interactions = {
      {
        entity = event.ran_into.entity,
        other = event.ran_into.other
      },
      {
        other = event.ran_into.entity,
        entity = event.ran_into.other
      }
    }

    for _, interaction in pairs(interactions) do
      local entity = interaction.entity
      local other = interaction.other

      if entity.damaged_when_run_into and other.damage_dealt_when_run_into then
        if entity.life then
          entity.life = entity.life - other.damage_dealt_when_run_into
        end

        if entity.life == nil or entity.life <=0 then
          entity.dead = true

          scene:new_entity({
            event = true,
            death = {
              entity = entity
            }
          })
        else
          scene:new_entity({
            event = true,
            damaged = {
              entity = entity
            }
          })
        end
      end
    end
  end
end
