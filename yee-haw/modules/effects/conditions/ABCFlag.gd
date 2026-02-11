extends ABCondition

class_name ABCFlag

@export var flag : AttackContext.Flag

func met(ctxt: AttackContext, _battle: BattleContext) -> bool:
	return flag in ctxt.flags
	
func alter_value(_ctxt: AttackContext, _battle: BattleContext, value: float) -> float:
	return value
