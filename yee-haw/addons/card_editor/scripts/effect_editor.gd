@tool
extends Control
class_name EffectEditor

var _selected_mod : String

func initialize(res: Resource, callback_id: int, delete_callback: Callable, change_index_callback: Callable) -> void:
	%"EFFECT HOOK".text = res.get_script().get_global_name().capitalize()

	%"DELETE BUTTON".button_down.connect(func():
		delete_callback.call(callback_id)
	)
	
	%"UP BUTTON".button_down.connect(func():
		change_index_callback.call(callback_id, -1)
	)
	
	%"DOWN BUTTON".button_down.connect(func():
		change_index_callback.call(callback_id, 1)
	)
	
	CESig.connect_class_option(%"MODIFIER OPTIONS", "modifiers", res, [
	func(val): _selected_mod = val
	])
	CESig.menu_button_size_consistency(%"MODIFIER OPTIONS", 20)
	
	%"ADD MODIFIER".pressed.connect(func():
		_add_selected_modifier(res)
	)
	
	_generate_modifiers(res)

## Adds the selected modifier option as a registered modifier
func _add_selected_modifier(res: Resource) -> void:
	var cls = load(CECache.class_cache[_selected_mod]).new()
	var mods = res.get("modifiers")
	mods.append(cls)
	res.set("modifiers", mods)
	res.emit_changed()
	_generate_modifiers(res)

func _generate_modifiers(res: Resource) -> void:
	for child in %"MODIFIER CONTAINER".get_children():
		child.queue_free()

	var id := 0
	for mod in res.get("modifiers"):
		_add_mod(res, mod, id)
		id += 1

## Connects a modifier resource to a mod_editor
func _add_mod(res: Resource, mod: Resource, id: int) -> void:
	var mod_editor := load("uid://c4y2ls50eerqu").instantiate() as EffectModController
	mod_editor.initialize( \
		mod, \
		id, \
		func(move_id, dir): _move_modifier(res, move_id, dir), \
		func(del_id): _delete_modifier(res, del_id) \
	)
	%"MODIFIER CONTAINER".add_child(mod_editor)
	mod_editor.owner = %"MODIFIER CONTAINER".owner

func _delete_modifier(res: Resource, id: int) -> void:
	var mods = res.get("modifiers")
	mods.remove_at(id)
	res.set("modifiers", mods)
	res.emit_changed()
	_generate_modifiers(res)

func _move_modifier(res: Resource, id: int, dir: int) -> void:
	var mods = res.get("modifiers")
	dir = clamp(dir, -1, 1)
	if dir == 0: return
	if clamp(id + dir, 0, len(mods)) != id + dir: return
	var first = mods[id]
	mods[id] = mods[id + dir]
	mods[id + dir] = first
	res.set("modifiers", mods)
	res.emit_changed()
	_generate_modifiers(res)
