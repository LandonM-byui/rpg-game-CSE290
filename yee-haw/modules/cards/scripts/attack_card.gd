extends CardData

## A card sub-type that attacks and deals damage
class_name AttackCard

enum AttackType {
	Firearm,
	Tool,
}

## Raw damage dealt by the attack
@export var damage : int = 1
## When greater than [member damage], dealt damage is a range between [member damage] and [member damage_max]
@export var damage_max : int = 0
## Type of attack card this is
@export var attack_type : AttackType
## How many times the card can be used before it is considered junk
@export var uses: int = 1
## Crit chance for the attack (/100 chance)
@export var crit_chance : int = 0
## Damage multiplier on a critical hit
@export var crit_multiplier : float = 2.0
## Target of the attack
@export var target : AttackContext.AttackTarget
## If true, chooses a random valid target from options
@export var random : bool
## How many times the attack triggers
@export var trigger_count : int = 1
## All effects tied to the play of this card
@export var play_effects : Array[Effect]
## All passive effects tied to this card when in hand
@export var hand_effects : Array[Effect]

## Declare this card as an attack type
func get_type() -> CardType:
	return CardType.Attack

## Returns the selection conditions for the attack when hovering a card
## TODO not a complete system, bust account for Target choices and Random
func get_selection_layer() -> int:
	match target:
		AttackContext.AttackTarget.Single: return CRef.SINGLE_ENEMY_CAST_LAYER
		AttackContext.AttackTarget.Lane: return CRef.LANE_ENEMY_CAST_LAYER
		AttackContext.AttackTarget.Column: return CRef.COLUMN_ENEMY_CAST_LAYER
		AttackContext.AttackTarget.All: return CRef.ALL_ENEMY_CAST_LAYER
	
	## default case, no layers
	return 0