@abstract
extends Resource
class_name Effect

enum EventHook {
	## Attack being built before applying to enemies.
	## [br] Linked to [AttackContext].
	BUILDING_ATTACK,
	## Called per individual enemy being attacked before being damaged.
	## [br] Linked to [DamageContext].
	DAMAGING_ENEMY,
	## Called after all damages are dealt from an attack.
	## [br] Linked to [AttackResultContext].
	ATTACK_COMPLETED,
	
	# only BattleContext?
	PLAYER_TURN_START,
	PLAYER_TURN_END,
	ENEMY_TURN_START,
	ENEMY_TURN_END,
	
	# Keep extending to allow context hooks
}

@abstract
## Return true if this effect applies to the given [EventHook]
func applies_to(hook: EventHook) -> bool

@abstract
## Alters the associated [EventHook] context, and battle context
func alter_context(ctxt, battle: BattleContext) -> void