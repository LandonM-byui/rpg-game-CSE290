extends ABModifier

## Changes the attack target
class_name ABChangeTarget

@export var target : AttackContext.AttackTarget

func build_context(ctxt: AttackContext, _battle: BattleContext) -> void:
	ctxt.target = target