extends Effect

## Type safe effect for altering BUILDING_ATTACK context
class_name AttackBuilderEffect

@export var modifiers : Array[ABModifier] = []

func applies_to(hook: EventHook) -> bool:
	return hook == EventHook.BUILDING_ATTACK

func alter_context(ctxt: AttackContext, battle: BattleContext) -> void:
	for mod in modifiers:
		mod.alter_context(ctxt, battle)