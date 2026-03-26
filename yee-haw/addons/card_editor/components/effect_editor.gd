extends Control
class_name EffectEditor

var _registered_params : Array[String]

func initialize(effect: Effect, id: int, delete_callback: Callable) -> void:
	%DELETE.button_down.connect(func(): delete_callback.call(id))

	%USE_SUSTAIN.toggled.connect(func(is_on): _set_sustain(effect, is_on))
	_set_sustain(effect, effect.sustain != null)
	CardSig.connect_menu_button_change(%CONTEXT, [ \
		func(_i): _change_sustain_context(effect, %CONTEXT.text), \
	])
	CardSig.connect_menu_button_change(%COUNTER, [ \
		func(_i): _change_sustain_counter(effect, %COUNTER.text), \
	])
	%DURATION.get_line_edit().text_submitted.connect(func(text): _change_sustain_duration(effect, int(text)))
	
	_refresh_sustain_exit_conditions(effect)
	%ADD_SUSTAIN_COND.button_down.connect(func(): _add_exit_condition(effect, Condition.new(), true))
	
	_refresh_conditions(effect)
	%ADD_CONDITION.button_down.connect(func(): _add_condition(effect, Condition.new(), true))
	
	_refresh_modifiers(effect)
	%ADD_MODIFIER.button_down.connect(func(): _add_modifier(effect, Modifier.new(), true))
	
	_update_title(effect)

func _update_title(effect: Effect) -> void:
	var new_title : String = ""
	
	if effect.sustain != null:
		new_title = "[SUSTAINED]  "
	
	new_title += "%s Effect" % [effect.hook.capitalize()]
	
	if effect.conditions.size() > 0:
		new_title += "  |  %s Condition" % [effect.conditions.size()]
		if effect.conditions.size() > 1:
			new_title += "s"
	
	if effect.modifiers.size() > 0:
		new_title += "  |  %s Modifier" % [effect.modifiers.size()]
		if effect.modifiers.size() > 1:
			new_title += "s"
	
	%CONTAINER.title = new_title

func _set_sustain(effect: Effect, is_on: bool) -> void:
	%SUSTAIN_CONTAINER.set_visible(is_on)
	if not is_on:
		if effect.sustain != null:
			effect.sustain = null
			effect.emit_changed()
		_update_title(effect)
		return
	
	if effect.sustain == null:
		effect.sustain = Sustain.new()
		effect.emit_changed()
	
	var options = CECache.ancestry_cache["IContext"]
	var countable_options := []
	for cls_name in options:
		var cls := (load(CECache.class_cache[cls_name]).new() as IContext)
		var counters := cls.counters()
		if counters.size() == 0: continue
		countable_options.append(cls_name)
	
	if not CardSig.connect_menu_button_options(%CONTEXT, effect.sustain.duration_context, countable_options):
		effect.sustain.duration_context = %CONTEXT.text
		effect.sustain.emit_changed()
	
	_register_context_params(effect)
	
	%DURATION.get_line_edit().text = str(effect.sustain.duration_count)
	
	_refresh_sustain_exit_conditions(effect)

func _register_context_params(effect: Effect) -> void:
	var cls := (load(CECache.class_cache[effect.sustain.duration_context]).new() as IContext)
	_registered_params = cls.counters()
	
	if not CardSig.connect_menu_button_options(%COUNTER, effect.sustain.duration_counter, _registered_params):
		effect.sustain.duration_counter = %COUNTER.text
		effect.sustain.emit_changed()

func _change_sustain_context(effect: Effect, new: String) -> void:
	if effect.sustain == null: return
	effect.sustain.duration_context = new
	effect.sustain.emit_changed()
	
	_register_context_params(effect)

func _change_sustain_counter(effect: Effect, new: String) -> void:
	if effect.sustain == null: return
	if not new in _registered_params: return
	effect.sustain.duration_counter = new
	effect.sustain.emit_changed()

func _change_sustain_duration(effect: Effect, val: int) -> void:
	if effect.sustain == null: return
	effect.sustain.duration_count = val
	effect.sustain.emit_changed()

func _refresh_sustain_exit_conditions(effect: Effect) -> void:
	for child in %EXIT_CONDITIONS.get_children():
		%EXIT_CONDITIONS.remove_child(child)
		child.queue_free()
	
	if effect.sustain == null: return
	
	for cond in effect.sustain.exit_conditions:
		_add_exit_condition(effect, cond)
		
func _add_exit_condition(effect: Effect, cond: Condition, is_new:bool=false) -> void:
	const cond_prefab : PackedScene = preload("res://addons/card_editor/components/condition_editor.tscn")
	var cond_line := cond_prefab.instantiate() as ConditionEditor 
	
	var related_context = CECache.related_icontext[effect.hook]
	
	var id := %EXIT_CONDITIONS.get_child_count()
	cond_line.initialize(id, cond, related_context, func(id): _remove_exit_condition(effect, id))
	
	%EXIT_CONDITIONS.add_child(cond_line)
	cond_line.owner = %EXIT_CONDITIONS.owner
	
	if is_new:
		effect.sustain.exit_conditions.append(cond)
		effect.sustain.emit_changed()

func _remove_exit_condition(effect: Effect, id: int) -> void:
	if effect.sustain == null: return
	effect.sustain.exit_conditions.pop_at(id)
	effect.sustain.emit_changed()
	_refresh_sustain_exit_conditions(effect)

func _refresh_conditions(effect: Effect) -> void:
	for child in %CONDITIONS.get_children():
		%CONDITIONS.remove_child(child)
		child.queue_free()
	
	for cond in effect.conditions:
		_add_condition(effect, cond)

func _add_condition(effect: Effect, cond: Condition, is_new:bool=false) -> void:
	const cond_prefab : PackedScene = preload("res://addons/card_editor/components/condition_editor.tscn")
	var cond_line := cond_prefab.instantiate() as ConditionEditor 
	
	var related_context = CECache.related_icontext[effect.hook]
	
	var id := %CONDITIONS.get_child_count()
	cond_line.initialize(id, cond, related_context, func(id): _remove_condition(effect, id))
	
	%CONDITIONS.add_child(cond_line)
	cond_line.owner = %CONDITIONS.owner
	
	if is_new:
		effect.conditions.append(cond)
		effect.emit_changed()
	
	_update_title(effect)
	
func _remove_condition(effect: Effect, id: int) -> void:
	effect.conditions.pop_at(id)
	effect.emit_changed()
	_refresh_conditions(effect)
	_update_title(effect)

func _refresh_modifiers(effect: Effect) -> void:
	for child in %MODIFIERS.get_children():
		%MODIFIERS.remove_child(child)
		child.queue_free()
	for mod in effect.modifiers:
		_add_modifier(effect, mod)

func _add_modifier(effect: Effect, mod: Modifier, is_new:bool=false) -> void:
	const mod_prefab : PackedScene = preload("res://addons/card_editor/components/modifier_editor.tscn")
	var mod_line := mod_prefab.instantiate() as ModifierEditor 
	
	var related_context = CECache.related_icontext[effect.hook]
	
	var id := %MODIFIERS.get_child_count()
	mod_line.initialize(id, mod, related_context, func(id): _remove_modifier(effect, id))
	
	%MODIFIERS.add_child(mod_line)
	mod_line.owner = %MODIFIERS.owner
	
	if is_new:
		effect.modifiers.append(mod)
		effect.emit_changed()
	
	_update_title(effect)
	
func _remove_modifier(effect: Effect, id: int) -> void:
	effect.modifiers.pop_at(id)
	effect.emit_changed()
	_refresh_modifiers(effect)
	_update_title(effect)
