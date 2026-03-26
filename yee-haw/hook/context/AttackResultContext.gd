extends IContext

## Provides context for the end result of all enemies damaged by an attack
class_name AttackResultContext


func related_context() -> Array[String]:
	return ["AttackResultContext", "BattleContext"]


# Applied values
# ----- ----- ----- ----- ----- ----- -----
## Damage to be applied to the attacking hero
var recoils : Array[RecoilContext] = []
## Total enemy defense in use
var calulated_defense : int = 0
## What happens to the card after use
var card_result := CardData.CardPermanance.Discard


# Context values
# ----- ----- ----- ----- ----- ----- -----

## Context flags to mark special conditions
enum Flag {
	## True if any damage dealt was critical
	DidCrit,
	## True if attack occured over more than one lane
	NotSingleLane,
}

## All special condition flags for the attack
var flags : Array[Flag] = []
## The lane the attack occured on. Only set if Flag.NotSingleLane is not a present flag
var lane : int = 0
## Number of critical hits applied
var crit_count : int = 0
