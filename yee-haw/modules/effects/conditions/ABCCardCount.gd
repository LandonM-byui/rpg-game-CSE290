extends ABCondition

## Counts how many cards are in a source
class_name ABCCardCount

@export var card: CardData
@export var source: BattleContext.CardSource

func met(_ctxt: AttackContext, battle: BattleContext) -> bool:
	return battle.count_cards(card, source) > 0

func alter_value(_ctxt: AttackContext, battle: BattleContext, value: float) -> float:
	return battle.count_cards(card, source) * value