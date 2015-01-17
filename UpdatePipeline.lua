return function(world, key_pressed, key_held)
  return {
    (require 'update/AddToWorld')(world),
    (require 'update/Jump')(key_pressed),
    (require 'update/LeftRight')(key_held),
    (require 'update/movement_animation'),
    (require 'update/Gravity')(900),
    (require 'update/basic_enemy_ai')(world),
    (require 'update/PlayerPosition')(world),
    (require 'update/EnemyPosition')(world),
    (require 'update/NonInteractingPosition')(world),
    (require 'update/ExtraLife')(world),
    (require 'update/die_when_off_stage'),
    (require 'update/on_death'),
    (require 'update/respawn')(world),
    (require 'update/remove_dead')(world),
    (require 'update/remove_when_animation_complete'),
    (require 'update/animation')
  }
end
