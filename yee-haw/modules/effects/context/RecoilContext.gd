extends Resource
class_name RecoilContext

enum RecoilTarget {
	## Attacking hero takes recoil
	Attacker,
	## All heroes inline with attack take damage
	Inlane,
	## All heroes take damage
	All,
	## A random hero takes damage
	Random
}

var damage : int = 0
var target := RecoilTarget.Attacker