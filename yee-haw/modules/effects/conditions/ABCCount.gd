extends ABCondition
class_name ABCCount

## Countable types
enum Countable {
	Uses,
	AttacksUsedTurn,
	AttacksUsedRound,
	DestroyedCards
}

@export var counter : Countable

func met(ctxt: AttackContext, battle: BattleContext) -> bool:
	match counter:
		Countable.Uses: return ctxt.card_uses_left > 0
		Countable.AttacksUsedTurn: return battle.attacks_used_turn > 0
		Countable.AttacksUsedRound: return battle.attacks_used_total > 0
		Countable.DestroyedCards: return battle.destroyed_cards > 0
	
	return false

func alter_value(ctxt: AttackContext, battle: BattleContext, value: float) -> float:
	match counter:
		Countable.Uses: return ctxt.card_uses_left * value
		Countable.AttacksUsedTurn: return battle.attacks_used_turn * value
		Countable.AttacksUsedRound: return battle.attacks_used_total * value
		Countable.DestroyedCards: return battle.destroyed_cards * value
	
	return value