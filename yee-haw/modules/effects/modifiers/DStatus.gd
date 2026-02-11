extends DModifier

## Applies a status to the hit enemy
class_name DStatus

@export var status : Status
@export var stack : int = 1
@export var chance : int = 100
@export var individual_stack_chance : bool = true

func build_context(ctxt: DamageContext, battle: BattleContext) -> void:
	var stacks := roundi(condition_value(ctxt, battle, stack))
	ctxt.status.append(StatusApplication.Create(status, stacks, chance, individual_stack_chance))