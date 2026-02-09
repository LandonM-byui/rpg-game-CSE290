extends Effect

## Type safe effect for altering ATTACK_COMPLETED context
class_name AttackResultEffect

@export var modifiers : Array[ARModifier] = []

func applies_to(hook: EventHook) -> bool:
	return hook == EventHook.BUILDING_ATTACK

func alter_context(ctxt: AttackResultContext, battle: BattleContext) -> void:
	for mod in modifiers:
		mod.alter_context(ctxt, battle)