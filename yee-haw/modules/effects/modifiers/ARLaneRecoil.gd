extends ARModifier

class_name ARLaneRecoil

@export var recoil_damage : int

func build_context(ctxt: AttackResultContext, _battle: BattleContext) -> void:
	var rc := RecoilContext.new()
	rc.damage = recoil_damage
	rc.target = RecoilContext.RecoilTarget.Inlane
	
	ctxt.recoils.append(rc)