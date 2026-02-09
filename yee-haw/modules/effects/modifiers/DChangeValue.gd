extends DModifier

## Changes the value of a [DamageContext] parameter
class_name DChangeValue

enum ChangeType {
	Change,
	Set
}

@export var parameter : DamageContext.Parameter
@export var value : int
@export var method : ChangeType

func build_context(ctxt: DamageContext, battle: BattleContext) -> void:
	var in_val := roundi(condition_value(ctxt, battle, value))
	
	match parameter:
		DamageContext.Parameter.Damage:
			if method == ChangeType.Set: in_val += ctxt.damage
			ctxt.damage = in_val
		DamageContext.Parameter.Defense:
			if method == ChangeType.Set: in_val += ctxt.calculated_defense
			ctxt.calculated_defense = in_val