extends ABModifier

## Changes the value of an [AttackContext] parameter on condition met
class_name ABChangeValue

enum ChangeType {
	Change,
	Set
}

@export var parameter : AttackContext.Parameter
@export var value : int
@export var method : ChangeType

func build_context(ctxt: AttackContext, battle: BattleContext) -> void:
	var in_val := roundi(condition_value(ctxt, battle, value))
	match parameter:
		AttackContext.Parameter.Damage:
			if method == ChangeType.Change: in_val += ctxt.damage
			ctxt.damage = in_val
		AttackContext.Parameter.DamageMax:
			if method == ChangeType.Change: in_val += ctxt.damage_max
			ctxt.damage_max = in_val
		AttackContext.Parameter.CritChance:
			if method == ChangeType.Change: in_val += ctxt.crit_chance
			ctxt.crit_chance = in_val
		AttackContext.Parameter.Triggers:
			if method == ChangeType.Change: in_val += ctxt.triggers
			ctxt.triggers = in_val