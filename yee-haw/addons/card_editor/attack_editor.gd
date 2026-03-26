extends Control
class_name AttackEditor

func _ready() -> void:
	CECache.build_cache()
	initialize(AttackCard.new())

func initialize(ac: AttackCard) -> void:
	var type_keys : Array = CECache.enum_cache['AttackCard.AttackType'].keys()
	CardSig.connect_menu_button_options(%TYPE, type_keys[int(ac.attack_type)], type_keys)
	CardSig.connect_menu_button_change(%TYPE, [ \
		func(index: int): ac.attack_type = index, \
		func(_i): ac.emit_changed(), \
	])
	
	%USES.set_value(ac.uses)
	%USES.get_line_edit().text_submitted.connect(func(val): _change_uses(ac, int(val)))
	
	%TRIGGERS.set_value(ac.trigger_count)
	%TRIGGERS.get_line_edit().text_submitted.connect(func(val): _change_triggers(ac, int(val)))
	
	var target_keys : Array = CECache.enum_cache['AttackContext.AttackTarget'].keys()
	CardSig.connect_menu_button_options(%TARGET, target_keys[int(ac.target)], target_keys)
	CardSig.connect_menu_button_change(%TARGET, [ \
		func(index): ac.target = index, \
		func(_i): ac.emit_changed(), \
	])
	
	%DAMAGE_MIN.set_value(ac.damage)
	%DAMAGE_MIN.get_line_edit().text_submitted.connect(func(val): _change_damage(ac, int(val)))
	
	%DAMAGE_MAX.set_value(ac.damage_max)
	%DAMAGE_MAX.get_line_edit().text_submitted.connect(func(val): _change_damage_max(ac, int(val)))
	
	_include_range(ac, ac.damage_max > ac.damage)
	%USE_RANGE.toggled.connect(func(use): _include_range(ac, use))
	
	%CRIT_CHANCE.set_value(ac.crit_chance)
	%CRIT_CHANCE.get_line_edit().text_submitted.connect(func(val): _change_crit_chance(ac, int(val)))
	
	%CRIT_MULT.set_value(ac.crit_multiplier)
	%CRIT_MULT.get_line_edit().text_submitted.connect(func(val): _change_crit_mult(ac, float(val)))
	
	%RANDOM_TARGETING.set_pressed_no_signal(ac.random)
	%RANDOM_TARGETING.toggled.connect(func(toggle): _change_random_toggle(ac, toggle))
	
	var context_options : Array = CECache.ancestry_cache["IContext"]
	CardSig.connect_menu_button_options(%PLAY_FX_CHOICE, "", context_options)
	CardSig.connect_menu_button_change(%PLAY_FX_CHOICE)
	CardSig.connect_menu_button_options(%HAND_FX_CHOICE, "", context_options)
	CardSig.connect_menu_button_change(%HAND_FX_CHOICE)
	
	_clear_children(%PLAY_EFFECTS)
	_refresh_play_fx(ac)
	%ADD_PLAY_EFFECT.button_down.connect(func(): _add_new_play_fx(ac))
	
	_clear_children(%HAND_EFFECTS)
	_refresh_hand_fx(ac)
	%ADD_HAND_EFFECT.button_down.connect(func(): _add_new_hand_fx(ac))
	
func _change_uses(ac: AttackCard, val: int) -> void:
	if ac.uses == max(0, val): return
	ac.uses = max(0, val)
	ac.emit_changed()

func _change_triggers(ac: AttackCard, val: int) -> void:
	if ac.trigger_count == max(0, val): return
	ac.trigger_count = max(0, val)
	ac.emit_changed()
	
func _change_damage(ac: AttackCard, val: int) -> void:
	if ac.damage == max(0, val): return
	ac.damage = max(0, val)
	
	if ac.damage_max != 0 and ac.damage_max < ac.damage:
		ac.damage_max = ac.damage + 1
		%DAMAGE_MAX.value = ac.damage_max
	
	ac.emit_changed()

func _change_damage_max(ac: AttackCard, val: int) -> void:
	if val <= ac.damage: return
	ac.damage_max = val
	ac.emit_changed()

func _include_range(ac: AttackCard, use_range: bool) -> void:
	%DAMAGE_MAX.set_visible(use_range)
	%TO_LABEL.set_visible(use_range)
	
	if use_range:
		if ac.damage_max <= ac.damage:
			ac.damage_max = ac.damage + 1
			ac.emit_changed()
	else:
		ac.damage_max = 0
		ac.emit_changed()
	
	%DAMAGE_MAX.set_value(ac.damage_max)
	
func _change_crit_chance(ac: AttackCard, val: int) -> void:
	if ac.crit_chance == val: return
	ac.crit_chance = val
	ac.emit_changed()

func _change_crit_mult(ac: AttackCard, val: float) -> void:
	if ac.crit_multiplier == val: return
	ac.crit_multiplier = val
	ac.emit_changed()
	
func _clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func _refresh_play_fx(ac: AttackCard) -> void:
	for fx in ac.play_effects:
		_add_play_fx(ac, fx)

func _add_play_fx(ac: AttackCard, fx: Effect) -> void:
	const fx_prefab : PackedScene = preload("res://addons/card_editor/components/effect_editor.tscn")
	var fx_line := fx_prefab.instantiate() as EffectEditor
	var id := %PLAY_EFFECTS.get_child_count()
	fx_line.initialize(fx, id, func(fxid): _delete_play_fx(ac, fxid))
	%PLAY_EFFECTS.add_child(fx_line)
	fx_line.owner = %PLAY_EFFECTS.owner

func _add_new_play_fx(ac: AttackCard) -> void:
	var fx := Effect.new()
	fx.hook = %PLAY_FX_CHOICE.text
	ac.play_effects.append(fx)
	ac.emit_changed()
	_add_play_fx(ac, fx)

func _delete_play_fx(ac: AttackCard, id: int) -> void:
	ac.play_effects.pop_at(id)
	ac.emit_changed()
	_clear_children(%PLAY_EFFECTS)
	_refresh_play_fx(ac)

func _refresh_hand_fx(ac: AttackCard) -> void:
	for fx in ac.play_effects:
		_add_hand_fx(ac, fx)

func _add_hand_fx(ac: AttackCard, fx: Effect) -> void:
	const fx_prefab : PackedScene = preload("res://addons/card_editor/components/effect_editor.tscn")
	var fx_line := fx_prefab.instantiate() as EffectEditor
	var id := %HAND_EFFECTS.get_child_count()
	fx_line.initialize(fx, id, func(fxid): _delete_hand_fx(ac, fxid))
	%HAND_EFFECTS.add_child(fx_line)
	fx_line.owner = %HAND_EFFECTS.owner

func _add_new_hand_fx(ac: AttackCard) -> void:
	var fx := Effect.new()
	fx.hook = %HAND_FX_CHOICE.text
	ac.hand_effects.append(fx)
	ac.emit_changed()
	_add_hand_fx(ac, fx)
	
func _delete_hand_fx(ac: AttackCard, id: int) -> void:
	ac.hand_effects.pop_at(id)
	ac.emit_changed()
	_clear_children(%HAND_EFFECTS)
	_refresh_hand_fx(ac)

func _change_random_toggle(ac: AttackCard, toggle: bool) -> void:
	ac.random = toggle
	ac.emit_changed()
	
