extends Resource
class_name ProjectData

# --------------------------------------------------------
# Data
# --------------------------------------------------------

## Deck preset
var deck_preset : DeckPreset
## Full remaining deck of cards
var deck : Array[IndexedCard] = []

## Tracks current card id to assign unique ids to all added cards
var _card_id_counter : int = 0

# --------------------------------------------------------
# Helpers
# --------------------------------------------------------

## Clears all cards
func clear_all_cards() -> void:
	deck = []

# Gets the next card id, and auto-increments the id counter
func _next_card_id() -> int:
	var val := _card_id_counter
	_card_id_counter += 1
	return val

## Adds a card to the deck as an [IndexedCard]
func add_card_to_deck(cd: CardData) -> void:
	deck.append(IndexedCard.Create(_next_card_id(), cd))