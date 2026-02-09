extends ARModifier

class_name ARMoveCards

@export var card : CardData
@export var from_source : BattleContext.CardSource
@export var to_source : BattleContext.CardSource

func build_context(_ctxt: AttackResultContext, battle: BattleContext) -> void:
	if from_source == to_source: return
	battle.move_cards(card, from_source, to_source)