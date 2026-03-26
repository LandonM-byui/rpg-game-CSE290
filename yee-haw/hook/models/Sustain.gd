extends Resource
class_name Sustain

@export var duration_context : String
@export var duration_counter : String
@export var duration_count : int = 1

@export var exit_conditions : Array[Condition]

func exit_sustain(start_val: int, ctxts: Dictionary[String, Resource]) -> bool:
	if duration_context == "": return false
	
	var ctxt := ctxts[duration_context]
	var val : Variant = ctxt.get(duration_counter)
	if val - start_val >= duration_count: return true
	
	for cond in exit_conditions:
		if cond.met(ctxts): return true
	
	return false