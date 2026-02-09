@abstract
extends Resource

## Defines a condition that must be met
class_name ABCondition

@abstract
func met(ctxt: AttackContext, battle: BattleContext) -> bool

@abstract
func alter_value(ctxt: AttackContext, battle: BattleContext, value: float) -> float