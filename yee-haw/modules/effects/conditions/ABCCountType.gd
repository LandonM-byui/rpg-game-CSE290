extends ABCondition

## Counts cards of a specific type from a source
class_name ABCCountType

@export var type : CardData.CardType
@export var source : BattleContext.CardSource

func met(_ctxt: AttackContext, battle: BattleContext) -> bool:
	return battle.count_card_type(type, source) > 0

func alter_value(_ctxt: AttackContext, battle: BattleContext, value: float) -> float:
	return battle.count_card_type(type, source) * value