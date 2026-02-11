extends Resource

## All context used in-battle
class_name BattleContext


# Counters
# ----- ----- ----- ----- ----- ----- ----- 
## Total attacks used
var attacks_used_total : int = 0
## Attacks used this turn
var attacks_used_turn : int = 0
## All destroyed cards this round
var destroyed_cards : int = 0


# Game State
# ----- ----- ----- ----- ----- ----- ----- 
## All cards in hand
var hand : Array[IndexedCard] = []
## IDs of all cards considered on the top of the deck
var top_deck : Array[int] = []
## All cards in the deck
var deck : Array[IndexedCard] = []
## All cards discarded
var discard : Array[IndexedCard] = []
## All cards removed temporarily
var removed_cards : Array[IndexedCard] = []


# Modifier access
# ----- ----- ----- ----- ----- ----- -----

enum CardSource {
	Hand,
	Deck,
	Discard,
	Removed,
}

## Counts how many cards can be found in the source
func count_cards(card: CardData, source: CardSource) -> int:
	match source:
		CardSource.Hand : return _count_cards_in_array(hand, card)
		CardSource.Deck : return _count_cards_in_array(deck, card)
		CardSource.Discard : return _count_cards_in_array(discard, card)
		CardSource.Removed : return _count_cards_in_array(removed_cards, card)
	
	return 0

func _count_cards_in_array(arr: Array[IndexedCard], find: CardData) -> int:
	var count := 0
	for card in arr:
		if card.data == find:
			count += 1
	
	return count

## Counts how many cards of type can be found in the source
func count_card_type(type: CardData.CardType, source: CardSource) -> int:
	match source:
		CardSource.Hand : return _count_card_type_in_array(hand, type)
		CardSource.Deck : return _count_card_type_in_array(deck, type)
		CardSource.Discard : return _count_card_type_in_array(discard, type)
		CardSource.Removed : return _count_card_type_in_array(removed_cards, type)
	
	return 0

func _count_card_type_in_array(arr: Array[IndexedCard], find: CardData.CardType) -> int:
	var count := 0
	
	for card in arr:
		if card.data.type == find:
			count += 1
	
	return count

## Moves all cards between sources
func move_cards(card: CardData, from_source: CardSource, to_source: CardSource) -> void:
	var idxs : Array[int]
	
	match from_source:
		CardSource.Hand : idxs = _get_card_indexes(hand, card)
		CardSource.Deck : idxs = _get_card_indexes(deck, card)
		CardSource.Discard : idxs = _get_card_indexes(discard, card)
		CardSource.Removed : idxs = _get_card_indexes(removed_cards, card)
	
	if idxs == null or len(idxs) == 0: return
	
	# since we are popping indexes, we need to work from back to front to avoid screwing
	# up later indexes (they will offset)
	idxs.sort() # small > large
	idxs.reverse() # large > small
	
	for index in idxs:
		var ic := _pop_card_from_source(from_source, index)
		_add_card_to_source(to_source, ic)

## Gets card indexes from an [IndexedCard] [Array] without modifying it
func _get_card_indexes(arr: Array[IndexedCard], card: CardData) -> Array[int]:
	var idxs : Array[int] = []
	
	for i in range(len(arr)):
		if arr[i].data == card:
			idxs.append(i)
	
	return idxs

## Pops a card from a card source at specified index
func _pop_card_from_source(source: CardSource, index: int) -> IndexedCard:
	match source:
		CardSource.Hand: return hand.pop_at(index)
		CardSource.Deck: return deck.pop_at(index)
		CardSource.Discard: return discard.pop_at(index)
		CardSource.Removed: return removed_cards.pop_at(index)
	
	return null

## Appends card to a source
func _add_card_to_source(source: CardSource, card: IndexedCard) -> void:
	match source:
		CardSource.Hand: return hand.append(card)
		CardSource.Deck: return deck.append(card)
		CardSource.Discard: return discard.append(card)
		CardSource.Removed: return removed_cards.append(card)
