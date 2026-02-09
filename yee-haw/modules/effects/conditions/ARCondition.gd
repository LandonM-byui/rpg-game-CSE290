@abstract
extends Resource

## Defines a condition that must be met
class_name ARCondition

@abstract
func met(ctxt: AttackResultContext, battle: BattleContext) -> bool

@abstract
func alter_value(ctxt: AttackResultContext, battle: BattleContext, value: float) -> float