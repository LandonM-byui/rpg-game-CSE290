extends Resource

## Provides context for the end result of all enemies damaged by an attack
class_name AttackResultContext


# Applied values
# ----- ----- ----- ----- ----- ----- -----
## Damage to be applied to the attacking hero
var recoils : Array[RecoilContext] = []
## All cards to be added to the discard
var cards_to_discard : Array = []
## All cards to be added to hand
var cards_to_hand : Array = []
## All cards to be added to deck
var cards_to_deck : Array = []
## All cards to be added to top-deck
var cards_to_top_deck : Array = []
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
