return function(scene, dt)
  local interactions = {}

  for event in pairs(scene:entities_with('event', 'ran_into')) do
    local entity = event.ran_into.entity
    local other = event.ran_into.other

    interactions[entity] = interactions[entity] or {}
    interactions[entity][other] = true
  end

  for primary in pairs(interactions) do
    for other in pairs(interactions[primary]) do

      if primary.damaged_when_run_into and other.damage_dealt_when_run_into then
        if primary.life then
          primary.life = primary.life - other.damage_dealt_when_run_into
        end

        if primary.life == nil or primary.life <=0 then
          primary.dead = true

          scene:new_entity({
            event = true,
            death = {
              entity = primary
            }
          })
        else
          scene:new_entity({
            event = true,
            damaged = {
              entity = primary
            }
          })
        end
      end

    end
  end
end
