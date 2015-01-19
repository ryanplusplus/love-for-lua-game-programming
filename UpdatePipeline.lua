return function(world, key_pressed, key_held)
  return {
    (require 'update/AddToWorld')(world),
    (require 'update/Jump')(key_pressed),
    (require 'update/LeftRight')(key_held),
    (require 'update/Gravity')(900),
    (require 'update/patrol_ai')(world),
    (require 'update/OneWayPlatformPosition')(world),
    (require 'update/NonInteractingPosition')(world),
    (require 'update/extra_life_picked_up'),
    (require 'update/damaged_when_run_into'),
    (require 'update/damaged_when_jumped_on'),
    (require 'update/player_score_for_kill'),
    (require 'update/cannot_leave_map'),
    (require 'update/die_when_off_stage'),
    (require 'update/movement_animation'),
    (require 'update/directional_death_animation'),
    (require 'update/death_animation'),
    (require 'update/respawn')(world),
    (require 'update/remove_dead')(world),
    (require 'update/remove_when_animation_complete'),
    (require 'update/animation'),
    (require 'update/game_over'),
    (require 'update/remove_events')
  }
end
