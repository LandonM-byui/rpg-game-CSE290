extends Resource

## Defines data for a base card in game.
class_name CardData

## Defines the permenance of a card after use
enum CardPermanance {
	## Card is added back into deck on use
	Deck,
	## Card is discarded on use
	Discard,
	## Card is temporarily removed on use
	Remove,
	## Card is destroyed on use
	Destroy,
}

## All card types
enum CardType {
	Attack,
	Defense,
	Item,
	Junk
}

## Card name
@export var name : String = "Unnamed Card"
## Color of the card : TODO temoporary until vfx are added
@export var color : Color

## Type of the card
var type : CardType:
	get: return get_type()

func get_type() -> CardType:
	return CardType.Item