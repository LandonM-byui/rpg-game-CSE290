@abstract
extends Resource
class_name ARModifier

@export var condition : ARCondition

func alter_context(ctxt: AttackResultContext, battle: BattleContext) -> void:
	if not _condition_met(ctxt, battle): return
	build_context(ctxt, battle)
	
@abstract
func build_context(ctxt: AttackResultContext, battle: BattleContext) -> void

func _condition_met(ctxt: AttackResultContext, battle: BattleContext) -> bool:
	if condition == null: return true
	return condition.met(ctxt, battle)

func condition_value(ctxt: AttackResultContext, battle: BattleContext, val: float) -> float:
	if condition == null: return val
	return condition.alter_value(ctxt, battle, val)