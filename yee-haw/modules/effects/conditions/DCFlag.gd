extends DCondition

## Condition requires a flag to be present in the DamageContext
class_name DCFlag

@export var flag: DamageContext.Flag

func met(ctxt: DamageContext, _battle: BattleContext) -> bool:
	return flag in ctxt.flags

func alter_value(_ctxt: DamageContext, _battle: BattleContext, value: float) -> float:
	return value