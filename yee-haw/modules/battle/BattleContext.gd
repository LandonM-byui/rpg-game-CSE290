extends Resource
class_name BattleContext

static func NewContext(pd : ProjectData) -> BattleContext:
	var bc = BattleContext.new()
	
	for card in pd.deck:
		bc.deck.append(card)
		
	bc.counter_id = pd._card_id_counter
	
	return bc
	
func draw_cards(count: int) -> Array[IndexedCard]:
	if count <= 0:
		return []
		
	var cards : Array[IndexedCard] = []
	
	for _i in range(count):
		if len(deck) <= 0:
			if len(discard) <= 0:
				return cards
			
			deck = discard
			deck.shuffle()
			discard = []
		
		var choice := randi_range(0, len(deck) - 1)
		cards.append(deck.pop_at(choice))
	
	return cards
	
var deck : Array[IndexedCard]
var counter_id : int = 0
var discard : Array[IndexedCard]
var block_card_draw: bool = false

func add_to_discard(card: IndexedCard) -> void:
	discard.append(card)
	
func add_to_deck(card: IndexedCard) -> void:
	deck.append(card)
	
func next_card_id() -> int:
	counter_id += 1
	return counter_id
	
func create_in_deck(cards: Array[CardData]) -> void:
	for data in cards:
		var card := IndexedCard.Create(next_card_id(), data)
		deck.append(card)

func create_in_discard(cards: Array[CardData]) -> void:
	for data in cards:
		var card := IndexedCard.Create(next_card_id(), data)
		discard.append(card)