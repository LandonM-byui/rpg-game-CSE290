extends Resource
class_name Modifier

enum Method {
	Set,
	Add,
	Remove,
}

@export var context : String
@export var parameter : String
@export var method : Method
@export var value : Variant

func apply(ctxts: Dictionary[String, IContext]) -> void:
	if not context in ctxts: return
	
	var ctxt := ctxts[context]
	var new_val = ctxt.get(parameter)
	match method:
		Method.Add: new_val += value
		Method.Set: new_val = value
	
	ctxt.set(parameter, new_val)
	
static func method_string(m: Method) -> String:
	match m:
		Method.Set: return "Set"
		Method.Add: return "Add"
		Method.Remove: return "Remove"
	
	return "ERROR"

static func string_to_method(ms: String) -> Method:
	match ms:
		"Add": return Method.Add
		"Set": return Method.Set
		"Remove": return Method.Remove
	
	push_error("INVALID STRING")
	return Method.Add