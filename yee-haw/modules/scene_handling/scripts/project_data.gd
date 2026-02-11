extends Resource
class_name ProjectData

## Deck preset
var deck_preset : DeckPreset

## Full remaining deck of cards
var full_deck : Array[IndexedCard] = []
## Top deck: cards are drawn from top deck before drawing from the full deck
var top_deck : Array[IndexedCard] = []
## Discard pile
var discard : Array[IndexedCard] = []
## All cards temporarily removed
var removed : Array[IndexedCard] = []

## Tracks current card id to assign unique ids to all added cards
var _card_id_counter : int = 0
## Gets the next unique id (auto-increments)
func _next_card_id() -> int:
	var val := _card_id_counter
	_card_id_counter += 1
	return val

## Clears all cards
func clear_all_cards() -> void:
	full_deck = []
	top_deck = []
	discard = []
	removed = []

## Adds a card to the deck as an [IndexedCard]
func add_card_to_deck(cd: CardData) -> void:
	full_deck.append(IndexedCard.Create(_next_card_id(), cd))

## Returns a random hand of cards from the draw pile equal to [param count]
func draw_cards(count: int) -> Array[IndexedCard]:
	var left := count
	var pile : Array[IndexedCard] = []
	
	# top-deck is drawn in order of last to first
	while len(top_deck) > 0 and left > 0:
		var ic = top_deck.pop_at(len(top_deck) - 1)
		pile.append(ic)
		left -= 1
	
	while left > 0:
		# can't add more cards if there are no more in deck or discard
		if len(full_deck) + len(discard) == 0:
			break
		
		# discard becomes deck if deck is empty
		if len(full_deck) == 0:
			_shuffle_discard_into_deck()
		
		# get random items from deck into hand
		var idx := randi_range(0, len(full_deck) - 1)
		var ic = full_deck.pop_at(idx)
		pile.append(ic)
		
		left -= 1
	
	return pile

## Returns all temporarily removed cards back into the deck
func return_removed_cards_to_deck() -> void:
	for ic in removed:
		full_deck.append(ic)
	removed = []
	shuffle_deck()

## Shuffles the deck into a random order
func shuffle_deck() -> void:
	full_deck.shuffle()

## Shuffles the discard pile into the deck
func _shuffle_discard_into_deck() -> void:
	for _i in range(len(discard)):
		full_deck.append(discard.pop_at(0))
	
	full_deck.shuffle()
	discard = []