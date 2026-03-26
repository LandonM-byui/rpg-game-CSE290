extends Resource

## Defines data for a base card in game.
class_name CardData

## Defines the permenance of a card after use
enum CardPermanance {
	## Card is added back into deck on use
	Deck,
	## Card is discarded on use
	Discard,
	## Card removed from play after use
	Remove
}

## All card types
enum CardType {
	Attack,
	Defense,
	Item,
	Junk
}

enum AttackTarget {
	None,
	Single,
	Column,
	Row,
}

enum CardSource {
	Hand,
	Deck,
	Discard
}

@export var name : String = "Unnamed Card"

@export var color : Color

#@export var icon : Resource

@export var triggers : int = 1

@export var type := CardType.Attack

@export var damage_range := Vector2i(0, 0)

@export var defense : int = 0

@export var targeting := AttackTarget.None

@export var draw_cards : int = 0

@export var card_copies : int = 0

@export var create_cards : Array[CardData]

@export var create_source := CardSource.Hand

@export var destroy_in_deck : int = 0

@export var destroy_in_hand : int = 0

@export var block_card_draw : bool = false

@export var special : bool = false

@export var after_play := CardPermanance.Discard

@export var turn_dmg_change : int = 0

@export var turn_def_change : int = 0

@export var perma_stat_change : int = 0