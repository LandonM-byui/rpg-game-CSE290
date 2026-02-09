extends Effect

## Type safe effect for altering DAMAGING_ENEMY context
class_name DamageEffect

@export var modifiers : Array[DModifier] = []

func applies_to(hook: EventHook) -> bool:
	return hook == EventHook.DAMAGING_ENEMY

func alter_context(ctxt: DamageContext, battle: BattleContext) -> void:
	for mod in modifiers:
		mod.alter_context(ctxt, battle)