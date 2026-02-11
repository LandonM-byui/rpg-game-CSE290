@tool
extends Control
class_name EffectModController

var _initial_condition_set : bool
var _curr_condition : String
var _id : int

func initialize(res: Resource, id: int, move_callback: Callable, delete_callback: Callable) -> void:
	_id = id

	%"EFFECT MODIFIER LABEL".text = res.get_script().get_global_name().capitalize()
	
	%"DELETE BUTTON".button_down.connect(func():
		delete_callback.call(_id)
	)
	
	%"UP BUTTON".button_down.connect(func():
		move_callback.call(_id, -1)
	)
	
	%"DOWN BUTTON".button_down.connect(func():
		move_callback.call(_id, 1)
	)
	
	_initial_condition_set = false
	CESig.connect_class_option(%"SELECTED CONDITION", "condition", res, [
	func(val): _load_condition(val, "condition", res)
	], true)
	
	var par := %"PARAM CONTAINER"
	for prop in res.get_property_list():
		if prop.name in ["condition", "resource_local_to_scene"]: continue
		var container := _get_container(prop, res)
		if container == null: continue
		par.add_child(container)
		container.owner = par.owner
		

func _get_container(prop: Dictionary, data: Resource) -> Control:
	match prop.type:
		TYPE_INT:
			if prop.hint == PROPERTY_HINT_ENUM:
				return CESig.new_enum_container(data, prop.name)
			else:
				return CESig.new_int_container(data, prop.name)

		TYPE_FLOAT:
			return CESig.new_float_container(data, prop.name)

		TYPE_BOOL:
			return CESig.new_bool_container(data, prop.name)

	if prop.type == TYPE_OBJECT and prop.class_name != "Script":
		return CESig.new_resource_container(data, prop.name)
	
	return null

func _load_condition(cls_name: String, param: String, res: Resource) -> void:
	if not _initial_condition_set:
		_initial_condition_set = true
	else:
		if cls_name == _curr_condition:
			return
	_curr_condition = cls_name
	
	var par := %"CONDITION OPTIONS"
	for child in par.get_children():
		child.queue_free()
	
	if cls_name.to_lower() == "none":
		res.set(param, null)
		res.emit_changed()
		return
	
	var cls = load(CECache.class_cache[cls_name]).new()
	res.set(param, cls)
	for prop in cls.get_property_list():
		if prop.name in ["resource_local_to_scene"]: continue
		var container := _get_container(prop, cls)
		if container == null: continue
		par.add_child(container)
		container.owner = par.owner

func change_id(new_id: int) -> void:
	_id = new_id
