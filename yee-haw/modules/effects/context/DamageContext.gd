extends Resource

## Provides context for an individual damaging instance (per enemy)
class_name DamageContext

## When true stops the action from happening
var cancel_action : bool = false

# Applied values
# ----- ----- ----- ----- ----- ----- -----
## Damage that will be applied to enemy
var damage : int = 0
## All status to be applied to the enemy
var status : Array[StatusApplication] = []
## All recoil to apply
var recoils : Array[RecoilContext]
## Total enemy defense in use
var calculated_defense : int = 0


# Context values
# ----- ----- ----- ----- ----- ----- -----

## Context flags to mark special conditions
enum Flag {
	## True if the hit was critical
	DidCrit,
	## True if enemy is inline with current hero
	Inline,
	## True if the enemy is inline with any hero
	InlineAny,
	## True if the enemy is at the front of its lane
	Front,
}

## All special condition flags for the attack
var flags : Array[Flag] = []


# Modifier access
# ----- ----- ----- ----- ----- ----- -----
enum Parameter {
	Damage,
	Defense,
}

# Application access
# ----- ----- ----- ----- ----- ----- -----

## Cleans up the context object
func cleanup() -> void:
	damage = max(damage, 0)
	calculated_defense = max(calculated_defense, 0)

func action_blocked() -> bool:
	return damage == 0 or cancel_action