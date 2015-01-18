return function(world, key_pressed, key_held)
  return {
    (require 'update/AddToWorld')(world),
    (require 'update/Jump')(key_pressed),
    (require 'update/LeftRight')(key_held),
    (require 'update/Gravity')(900),
    (require 'update/basic_enemy_ai')(world),
    (require 'update/PlayerPosition')(world),
    (require 'update/EnemyPosition')(world),
    (require 'update/NonInteractingPosition')(world),
    (require 'update/extra_life_picked_up_by_player'),
    (require 'update/player_dies_after_running_into_enemy'),
    (require 'update/enemy_dies_when_jumped_on'),
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
