extends Resource
class_name Condition

@export var context : String
@export var parameter : String
@export var comparison : String
@export var expected : Variant

func met(ctxts: Dictionary[String, Resource]) -> bool:
	if not context in ctxts: return false
	
	var ctxt : Resource = ctxts[context]
	var val = ctxt.get(parameter)

		
	
	return false	