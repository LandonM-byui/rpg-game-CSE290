extends Resource

# TODO incomplete

## Defines data for a queued attack. Can be passed through filtering methods to alter the attack conditions and output.
class_name AttackData

## Damage to be dealt.
var damage : int
## Target option.
var target : AttackCard.AttackTarget
## Targeting choice.
var target_choice : AttackCard.AttackTargetChoice
## If true, attack selects a random valid target within the [member target] and [member target_choice] conditions.
var random : bool

## Overrides [member damage] to use the range from [member damage_range_min] to [member damage_range_max].
var use_damage_range : bool
## Minimum damage range. Requries [codeblock][member use_damage_range] == true[/codeblock] to have an effect.
var damage_range_min : int
## Maximum damage range. Requries [codeblock][member use_damage_range] == true[/codeblock] to have an effect.
var damage_range_max : int

## How many times the attack triggers. Mostly useful for attacks with [codeblock][member random] == true [/codeblock]
## since it will reselect new targets each trigger.
var triggers : int = 0
