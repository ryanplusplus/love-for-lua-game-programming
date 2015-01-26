return function(key_pressed, on_win)
  return function(scene, dt)
    for entity in pairs(scene:entities_with('win')) do
      if key_pressed['return'] then
        on_win()
      end
    end
  end
end
