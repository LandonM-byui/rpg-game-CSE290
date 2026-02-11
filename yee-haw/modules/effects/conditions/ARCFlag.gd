extends ARCondition

class_name ARCFlag

@export var flag : AttackResultContext.Flag

func met(ctxt: AttackResultContext, _battle: BattleContext) -> bool:
	return flag in ctxt.flags

func alter_value(_ctxt: AttackResultContext, _battle: BattleContext, value: float) -> float:
	return value