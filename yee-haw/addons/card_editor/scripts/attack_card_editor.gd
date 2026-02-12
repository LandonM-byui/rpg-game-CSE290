@tool
extends Control
class_name AttackCardEditor

var _sel_targeting : int
var _sel_onplay_class : String
var _sel_inhand_class : String

func initialize(card: AttackCard) -> void:
	## connect all fields to resource
	CESig.connect_int(%DAMAGE.get_line_edit(), "damage", card)
	CESig.connect_int(%"DAMAGE MAX".get_line_edit(), "damage_max", card)
	CESig.connect_toggle(%"USE RANGE", "", card, [
	func(nv): _hide_max_on_no_range(nv, card)
	])
	_hide_max_on_no_range(card.damage_max > card.damage, card)
	
	CESig.connect_enum(%"ATTACK TYPE", "attack_type", card)
	CESig.connect_enum(%"ATTACK TARGET", "target", card, [
	func(val): _update_sel_targeting(val)
	])
	_update_sel_targeting(card.get("target"))
	
	CESig.connect_toggle(%"IS RANDOM", "", card, [
	func(nv): _update_random_subtype(nv)
	])
	_update_random_subtype(card.random)
	
	CESig.connect_int(%USES.get_line_edit(), "uses", card)
	CESig.connect_int(%"TRIGGERS".get_line_edit(), "trigger_count", card)
	CESig.connect_int(%"CRIT CHANCE".get_line_edit(), "crit_chance", card)
	CESig.connect_float(%"CRIT MULTIPLIER".get_line_edit(), "crit_multiplier", card)
	
	CESig.connect_class_option(%"HOOK OPTION ONPLAY", "play_effects", card, [
	func(sel): _sel_onplay_class = sel
	])
	CESig.menu_button_size_consistency(%"HOOK OPTION ONPLAY", 20.0)
	%"ADD EVENT HOOK ONPLAY".pressed.connect(func():
		_create_effect(card, _sel_onplay_class, "play_effects", %"ONPLAY EFFECTS")
	)
	_generate_effects(card, "play_effects", %"ONPLAY EFFECTS")
	
	CESig.connect_class_option(%"HOOK OPTION INHAND", "hand_effects", card, [
	func(sel): _sel_inhand_class = sel
	])
	CESig.menu_button_size_consistency(%"HOOK OPTION INHAND", 20.0)
	%"ADD EVENT HOOK INHAND".pressed.connect(func():
		_create_effect(card, _sel_inhand_class, "hand_effects", %"INHAND EFFECTS")
	)
	_generate_effects(card, "hand_effects", %"INHAND EFFECTS")

func _hide_max_on_no_range(val: bool, data: Resource) -> void:
	%to.visible = val
	%"DAMAGE MAX".visible = val
	
	if not val:
		%"DAMAGE MAX".get_line_edit().text = "0"
		data.set("damage_max", 0)
		data.emit_changed()

func _update_random_subtype(nv: bool) -> void:
	%"RANDOM SUBTYPE".get_parent_control().visible = nv

func _create_effect(res: Resource, new_class: String, param: String, container: Control) -> void:
	var cls = load(CECache.class_cache[new_class]).new()
	var fxs = res.get(param)
	if fxs == [] or fxs == null:
		fxs = []
	fxs.append(cls)
	res.set(param, fxs)
	res.emit_changed()
	_generate_effects(res, param, container)

func _generate_effects(res: Resource, param: String, container: Control) -> void:
	for child in container.get_children():
		child.queue_free()
		
	var id := 0
	for fx in res.get(param):
		_add_effect(res, fx, id, param, container)
		id += 1

func _add_effect(res: Resource, fx: Resource, id: int, param: String, container: Control) -> void:
	var fx_editor := load("uid://ccksyr4vb7r4y").instantiate() as EffectEditor
	fx_editor.initialize( \
		fx, \
		id, \
		func(del_id): _delete_fx(res, del_id, param, container), \
		func(move_id, dir): _move_fx(res, move_id, dir, param, container) \
	)
	container.add_child(fx_editor)
	fx_editor.owner = container.owner

func _delete_fx(res: Resource, id: int, param: String, container: Control) -> void:
	var fxs = res.get(param)
	fxs.remove_at(id)
	res.set(param, fxs)
	res.emit_changed()
	_generate_effects(res, param, container)

func _move_fx(res: Resource, id: int, dir: int, param: String, container: Control) -> void:
	var fxs = res.get(param)
	dir = clamp(dir, -1, 1)
	if dir == 0: return
	if clamp(id + dir, 0, len(fxs) - 1) != id + dir: return
	var first = fxs[id]
	fxs[id] = fxs[id + dir]
	fxs[id + dir] = first
	res.set(param, fxs)
	res.emit_changed()
	_generate_effects(res, param, container)

func _update_sel_targeting(val: int) -> void:
	_sel_targeting = val
	var sel_rand_tgt : int = AttackContext.get_random_type(val)
	var str_val := "NOT FOUND"
	var edict = CECache.enum_cache["AttackContext.RandomTarget"]
	for key in edict.keys():
		if edict[key] == sel_rand_tgt:
			str_val = key.capitalize()
			break
	
	%"RANDOM SUBTYPE".text = str_val
	
