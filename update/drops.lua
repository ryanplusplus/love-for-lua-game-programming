return function(scene, dt)
  for event in pairs(scene:entities_with('event', 'death')) do
    local entity = event.death.entity
    if entity.drops and entity.position then
      local drops = entity.drops
      local total_weight = 0
      local probabilities = {}

      for _, weight in pairs(drops) do
        total_weight = total_weight + weight
      end

      for drop, weight in pairs(drops) do
        probabilities[drop] = weight / total_weight
      end

      math.randomseed(os.time())
      local random = math.random()

      local choice
      for drop, probability in pairs(probabilities) do
        random = random - probability
        choice = drop

        if random <= 0 then
          break
        end
      end

      local drop = scene:new_entity(choice)
      if drop.position and entity.position then
        drop.position.x = entity.position.x
        drop.position.y = entity.position.y
      end
    end
  end
end
