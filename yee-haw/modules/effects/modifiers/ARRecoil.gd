extends ARModifier
class_name ARRecoil

@export var recoil_damage : int
@export var target: RecoilContext.RecoilTarget

func build_context(ctxt: AttackResultContext, _battle: BattleContext) -> void:
	var rc := RecoilContext.new()
	rc.damage = recoil_damage
	rc.target = target
	
	ctxt.recoils.append(rc)