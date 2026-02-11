extends Resource

## Provides pre-attack context about a planned attack
class_name AttackContext

## If true, prevents the attack from occuring
var action_blocked : bool = false

## All valid attack targeting options
enum AttackTarget {
	## Any single target
	Single,
	## Any single target inline with hero
	InlineSingle,
	## Any single target at the front of its lane
	FrontSingle,
	## The target inline with hero at the front of the lane
	FrontInlineSingle,
	## Any entire lane
	Lane,
	## The entire lane inline with hero
	InlineLane,
	## Any entire column
	Column,
	## All enemies
	All,
	## All enemies inline with all heroes
	AllInline,
	## All enemies at the front of their lanes
	AllFront,
	## All enemies at the front of their lanes inline with all heroes
	AllFrontInline,
}

## All valid random targeting options
enum RandomTarget {
	## A random single target
	Single,
	## A random single target inline with hero
	InlineSingle,
	## A random single target at the front of its lane
	FrontSingle,
	## A random target from enemies inline with all heroes at the front of its lane
	InlineFrontAll,
	## A random entire lane
	Lane,
	## A random lane inline with all heroes
	InlineAll,
	## A random entire column
	Column
}

## Returns the matched random type for an attack type (many to one)
static func get_random_type(tgt: AttackTarget) -> RandomTarget:
	match tgt:
		AttackTarget.Single: return RandomTarget.Single
		AttackTarget.InlineSingle: return RandomTarget.InlineSingle
		AttackTarget.FrontSingle: return RandomTarget.FrontSingle
		AttackTarget.FrontInlineSingle: return RandomTarget.InlineFrontAll
		AttackTarget.Lane: return RandomTarget.Lane
		AttackTarget.InlineLane: return RandomTarget.InlineAll
		AttackTarget.Column: return RandomTarget.Column
		AttackTarget.All: return RandomTarget.Single
		AttackTarget.AllInline: return RandomTarget.InlineAll
		AttackTarget.AllFront: return RandomTarget.FrontSingle
		AttackTarget.AllFrontInline: return RandomTarget.InlineFrontAll
	
	# default, all paths will return correct though
	return RandomTarget.Single

# Applied values
# ----- ----- ----- ----- ----- ----- -----
## Damage to deal per enemy
var damage : int = 0
## When > [member damage], damage is random in range
var damage_max : int = 0
## Chance (/100) of a critical hit
var crit_chance : int = 0
## Damage multiplier on a critical hit
var crit_multiplier : float = 2.0
## How many times the attack triggers
var triggers : int = 0
## Attack target
var target : AttackTarget = AttackTarget.Single
## If true, targeting is random from available targets
var random : bool = false


# Context values
# ----- ----- ----- ----- ----- ----- -----

## Context flags to mark special conditions
enum Flag {
	## First attack played during this turn
	FirstAttack,
}

var flags : Array[Flag] = []

## How many uses are left on the card
var card_uses_left : int = 0


# Modifier access
# ----- ----- ----- ----- ----- ----- -----
enum Parameter {
	Damage,
	DamageMax,
	CritChance,
	Triggers,
}


# Application access
# ----- ----- ----- ----- ----- ----- -----

## Cleans up the context resource
func cleanup() -> void:
	damage = max(0, damage)
	if damage_max < damage: damage_max = 0
	crit_chance = clamp(crit_chance, 0, 100)
	crit_multiplier = max(0, crit_multiplier)
	triggers = max(0, triggers)

func damage_is_range() -> bool:
	return damage_max > damage

func action_is_blocked() -> bool:
	return triggers == 0 or action_blocked