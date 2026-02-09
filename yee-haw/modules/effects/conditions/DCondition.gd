@abstract
extends Resource

class_name DCondition

@abstract
func met(ctxt: DamageContext, battle: BattleContext) -> bool

@abstract
func alter_value(ctxt: DamageContext, battle: BattleContext, value: float) -> float