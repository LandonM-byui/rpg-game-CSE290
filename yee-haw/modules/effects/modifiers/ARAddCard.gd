extends ARModifier

class_name ARAddCard

enum CardSource {
	Hand,
	Discard,
	Deck,
	TopDeck,
}

@export var source : CardSource
@export var card : CardData
@export var count : int

func build_context(ctxt: AttackResultContext, _battle: BattleContext) -> void:
	if count <= 0: return
	
	match source:
		CardSource.Hand:
			for _i in range(count):
				ctxt.cards_to_hand.append(card)
		CardSource.Deck:
			for _i in range(count):
				ctxt.cards_to_deck.append(card)
		CardSource.Discard:
			for _i in range(count):
				ctxt.cards_to_discard.append(card)
		CardSource.TopDeck:
			for _i in range(count):
				ctxt.cards_to_top_deck.append(card)