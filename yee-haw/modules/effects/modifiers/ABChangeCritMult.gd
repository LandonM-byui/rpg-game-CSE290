extends ABModifier

## Alters the crit multiplier of the attack
class_name ABChangeCritMult

enum ChangeType {
	Set,
	Increase,
	Multiply
}

@export var crit_mult : float
@export var change : ChangeType

func build_context(ctxt: AttackContext, battle: BattleContext) -> void:
	var in_val := condition_value(ctxt, battle, crit_mult)
	
	match change:
		ChangeType.Set: ctxt.crit_multiplier = in_val
		ChangeType.Increase: ctxt.crit_multiplier += in_val
		ChangeType.Multiply: ctxt.crit_multiplier *= in_val
