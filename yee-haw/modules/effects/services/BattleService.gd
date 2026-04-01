extends Object
## A Service [Object] that alters and retrieves data from [BattleContext]
class_name BattleService


## Creates new BattleContext from current ProjectData
static func CreateContext(pd: ProjectData) -> BattleContext:
	var bc = BattleContext.new()
	
	bc.deck = pd.deck.duplicate()
	
	return bc

## Draws the specified number of cards from the deck into hand. Re-shuffles the discard as the new deck when empty.
static func draw_cards(ctxt: BattleContext, count: int) -> void:
	if count <= 0: return
	
	var drawn := 0
	while drawn < count:
		if not _draw_card(ctxt):
			break
		drawn += 1

## Attempts to draw a single card into hand. Returns if a card was able to be drawn or not
static func _draw_card(ctxt: BattleContext) -> bool:
	if ctxt.top_deck.size() > 0:
		ctxt.hand.append(ctxt.top_deck.pop_front())
		return true
	
	## check for no cards remaining
	if ctxt.deck.size() == 0:
		if ctxt.discard.size() == 0:
			return false
		
		ctxt.deck = ctxt.discard
		ctxt.discard = []
		shuffle_deck(ctxt)
	
	var index := randi_range(0, ctxt.deck.size() - 1)
	ctxt.hand.append(ctxt.deck.pop_at(index))
	return true

## Shuffles the battle deck
static func shuffle_deck(ctxt: BattleContext) -> void:
	ctxt.deck.shuffle()

## Pulls all hand data out of the context object to be altered externally
static func pull_hand(ctxt: BattleContext) -> Array[IndexedCard]:
	var out := ctxt.hand
	ctxt.hand = []
	return out

## Returns all cards from [BattleContext] and externally-edited cards back to the [ProjectData]
static func return_cards_to_project(pd: ProjectData, ctxt: BattleContext, other_cards: Array[IndexedCard]) -> void:
	var cards := ctxt.deck + ctxt.hand + ctxt.discard + ctxt.top_deck + other_cards
	pd.deck = cards

## Counts how many cards can be found in the source
static func count_cards( \
## Context
ctxt: BattleContext, \
## Card to count
card: CardData, \
## Where to count cards from
source: BattleContext.CardSource \
) -> int:
	match source:
		BattleContext.CardSource.Hand : return _count_cards_in_array(ctxt.hand, card)
		BattleContext.CardSource.Deck : return _count_cards_in_array(ctxt.deck, card)
		BattleContext.CardSource.Discard : return _count_cards_in_array(ctxt.discard, card)
		BattleContext.CardSource.Removed : return _count_cards_in_array(ctxt.removed_cards, card)
	
	return 0

## Counts cards in the given array
static func _count_cards_in_array( \
## Array to count in
arr: Array[IndexedCard], \
## What to count
find: CardData \
) -> int:
	var count := 0
	for card in arr:
		if card.data == find:
			count += 1
	
	return count

## Counts how many cards of type can be found in the source
static func count_card_type( \
## Context
ctxt: BattleContext, \
## Type to count
type: CardData.CardType, \
## Where to count
source: BattleContext.CardSource \
) -> int:
	match source:
		BattleContext.CardSource.Hand : return _count_card_type_in_array(ctxt.hand, type)
		BattleContext.CardSource.Deck : return _count_card_type_in_array(ctxt.deck, type)
		BattleContext.CardSource.Discard : return _count_card_type_in_array(ctxt.discard, type)
		BattleContext.CardSource.Removed : return _count_card_type_in_array(ctxt.removed_cards, type)
	
	return 0

## Counts card type found in array
static func _count_card_type_in_array( \
## Where to count
arr: Array[IndexedCard], \
## What to count
find: CardData.CardType \
) -> int:
	var count := 0
	
	for card in arr:
		if card.data.type == find:
			count += 1
	
	return count

## Moves all cards between sources
static func move_cards( \
## Context
ctxt: BattleContext, \
## Card to move
card: CardData, \
## Where to pull cards from
from_source: BattleContext.CardSource, \
## Where to put the new cards
to_source: BattleContext.CardSource \
) -> void:
	var idxs : Array[int]
	
	match from_source:
		BattleContext.CardSource.Hand : idxs = _get_card_indexes(ctxt.hand, card)
		BattleContext.CardSource.Deck : idxs = _get_card_indexes(ctxt.deck, card)
		BattleContext.CardSource.Discard : idxs = _get_card_indexes(ctxt.discard, card)
		BattleContext.CardSource.Removed : idxs = _get_card_indexes(ctxt.removed_cards, card)
	
	if idxs == null or len(idxs) == 0: return
	
	# since we are popping indexes, we need to work from back to front to avoid screwing
	# up later indexes (they will offset)
	idxs.sort() # small > large
	idxs.reverse() # large > small
	
	for index in idxs:
		var ic := _pop_card_from_source(ctxt, from_source, index)
		_add_card_to_source(ctxt, to_source, ic)

## Gets card indexes from an [IndexedCard] [Array] without modifying it
static func _get_card_indexes( \
## Where to get indexes from
arr: Array[IndexedCard], \
## Card to find idexes of
card: CardData \
) -> Array[int]:
	var idxs : Array[int] = []
	
	for i in range(len(arr)):
		if arr[i].data == card:
			idxs.append(i)
	
	return idxs

## Pops a card from a card source at specified index
static func _pop_card_from_source( \
## Context
ctxt: BattleContext, \
## Where to pop cards from
source: BattleContext.CardSource, \
## Index to pop at
index: int \
) -> IndexedCard:
	match source:
		BattleContext.CardSource.Hand: return ctxt.hand.pop_at(index)
		BattleContext.CardSource.Deck: return ctxt.deck.pop_at(index)
		BattleContext.CardSource.Discard: return ctxt.discard.pop_at(index)
		BattleContext.CardSource.Removed: return ctxt.removed_cards.pop_at(index)
	
	return null

## Appends card to a source
static func _add_card_to_source( \
## Context
ctxt: BattleContext, \
## Where to add the card
source: BattleContext.CardSource, \
## Card to add
card: IndexedCard \
) -> void:
	match source:
		BattleContext.CardSource.Hand: return ctxt.hand.append(card)
		BattleContext.CardSource.Deck: return ctxt.deck.append(card)
		BattleContext.CardSource.Discard: return ctxt.discard.append(card)
		BattleContext.CardSource.Removed: return ctxt.removed_cards.append(card)
