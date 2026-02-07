extends CardData

## A card sub-type that attacks and deals damage
class_name AttackCard

## Defines targeting for an attack
enum AttackTarget {
	## Single target
	Single,
	## Target whole lane
	Lane,
	## Target whole column
	Column,
	## Target all enemies
	All,
}

## Defines rules for how a target is chosen
enum AttackTargetChoice {
	## Choose from any enemy
	Any,
	## Choose from current lane
	InLane,
	## Chooses from the front-most enemies in each lane
	Front,
	## Chooses the front-most enemy in the current lane
	FontInLane,
	## Chooses from any enemy in the back column
	Back,
	## Chooses the enemy in the back column in the current lane
	BackInLane
}

# Note some targeting+choice combinations result in the same set, don't worry about it

## Raw damage dealt by the attack
@export var damage : int = 1
## Target of the attack
@export var attack_target : AttackTarget
## Target choices
@export var attack_choice : AttackTargetChoice
## If true, chooses a random valid target from options
@export var random : bool
## How many times the attack triggers
@export var trigger_count : int = 1

## Todo Attack modifiers: scale per enemy, scale per hero, etc.

## Returns the selection conditions for the attack when hovering a card
## TODO not a complete system, bust account for Target choices and Random
func get_selection_layer() -> int:
	match attack_target:
		AttackTarget.Single: return 16
		AttackTarget.Lane: return 32
		AttackTarget.Column: return 64
		AttackTarget.All: return 128
	
	## default case, no layers
	return 0