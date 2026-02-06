extends CardData
class_name AttackCard

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

enum AttackTargetChoice {
	## Free target choice
	Any,
	## Choose from current lane
	InLane,
	## Targets the front-most in-lane
	Front,
}

@export var damage : int = 1
@export var attack_target : AttackTarget
@export var attack_choice : AttackTargetChoice
@export var random : bool
@export var trigger_count : int = 1

## Todo Attack modifiers: scale per enemy, scale per hero, etc.

func get_selection_layer() -> int:
	match attack_target:
		AttackTarget.Single: return 16
		AttackTarget.Lane: return 32
		AttackTarget.Column: return 64
		AttackTarget.All: return 128
	
	## default case, no layers
	return 0