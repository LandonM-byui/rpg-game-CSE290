extends Resource

## Defines data for a queued attack. Can be passed through filtering methods to alter the attack conditions and output.
class_name AttackData

## Conditions to apply bonus damage on
enum BonusOption {
	## First attack played during the turn
	FirstAttack,
	## Enemy is the front-most in its lane
	FrontEnemy,
	## Per attack used during the current turn
	AttacksUsedDuringTurn,
}

## Sources a created card can be added to
enum CardSource {
	## Added to the deck of cards
	Deck,
	## Added to the top of the deck
	DeckTop,
	## Added straight into the player hand
	Hand,
	## Added to the discard pile
	Discard
}

## Conditions that must be met to create a card
enum CardAddCondition {
	## Card is always added
	Always,
	## Card added only on a critical hit
	Crit,
	
}

## Special conditions to add triggers to an attack
enum TriggerModifier {
	## No modification
	None,
	## Adds the count of a card type in hand
	CountCardTypeInHand
}

## All card types
enum CardType {
	## Special single-use cards
	Special,
	## Junk cards
	Junk,
	## Attack and damaging cards
	Attack,
	## Defense cards
	Defense
}


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
