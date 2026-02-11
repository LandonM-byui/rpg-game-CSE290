extends ABModifier

## Assigns random targeting to the attack
class_name ABTargetRandom

@export var random : bool

func build_context(ctxt: AttackContext, _battle: BattleContext) -> void:
	ctxt.random = random
		