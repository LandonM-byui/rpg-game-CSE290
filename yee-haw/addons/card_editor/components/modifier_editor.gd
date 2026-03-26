extends Node
class_name ModifierEditor

var _registered_params : Dictionary[String, Variant]

func initialize(id: int, mod: Modifier, valid_contexts: Array[String], delete_callback: Callable) -> void:
	%DELETE.button_down.connect(func(): delete_callback.call(id))
	
	_connect_context(mod, valid_contexts)
	_connect_parameters(mod, true)
	_connect_set_options(mod)
	
	CardSig.connect_menu_button_change(%CONTEXT, [ \
		func(i): mod.context = %CONTEXT.get_popup().get_item_text(i), \
		func(_i): mod.emit_changed(), \
		func(_i): _connect_parameters(mod), \
	])
	
	CardSig.connect_menu_button_change(%PARAMETER, [ \
		func(i): mod.parameter = %PARAMETER.get_popup().get_item_text(i), \
		func(_i): mod.emit_changed(), \
		func(_i): _connect_set_options(mod), \
	])
	
	CardSig.connect_menu_button_change(%METHOD, [ \
		func(i): mod.method = Modifier.string_to_method(%METHOD.get_popup().get_item_text(i)), \
		func(_i): mod.emit_changed(), \
	])
	
	%INT.get_line_edit().text_submitted.connect(func(val): _set_value(mod, int(val), CardSig.ParamType.Int))
	%FLOAT.get_line_edit().text_submitted.connect(func(val): _set_value(mod, float(val), CardSig.ParamType.Float))
	%BOOL.toggled.connect(func(val): _set_value(mod, val, CardSig.ParamType.Bool))
	CardSig.connect_menu_button_change(%ENUM, [ \
		func(index): _set_value(mod, index, CardSig.ParamType.Enum), \
	])

func _connect_context(mod: Modifier, valid_contexts) -> void:
	if not CardSig.connect_menu_button_options(%CONTEXT, mod.context, valid_contexts):
		mod.context = %CONTEXT.text
		mod.emit_changed()

func _connect_parameters(mod: Modifier, skip:=false) -> void:
	_registered_params = CardSig.get_script_parameters(mod.context)
	if not CardSig.connect_menu_button_options(%PARAMETER, mod.parameter, _registered_params.keys()):
		mod.parameter = %PARAMETER.text
		mod.emit_changed()
	
	if not skip:
		_connect_set_options(mod)
		

func _connect_set_options(mod: Modifier) -> void:
	if not _registered_params.has(mod.parameter):
		mod.parameter = _registered_params.keys()[0]
		mod.emit_changed()
	
	var param_desc = _registered_params[mod.parameter]
	var param_type = param_desc[0]
	var param_methods := ModifierEditor._type_methods(param_type)
	var mod_method := Modifier.method_string(mod.method) 
	if not mod_method in param_methods:
		mod.method = Modifier.string_to_method(param_methods[0])
		mod.emit_changed()
	
	CardSig.connect_menu_button_options(%METHOD, Modifier.method_string(mod.method), param_methods)
	
	%INT.set_visible(param_type == CardSig.ParamType.Int)
	%FLOAT.set_visible(param_type == CardSig.ParamType.Float)
	%BOOL.set_visible(param_type == CardSig.ParamType.Bool)
	%ENUM.set_visible(param_type in [CardSig.ParamType.Enum, CardSig.ParamType.EnumArray])
	
	match param_type:
		CardSig.ParamType.Int:
			if typeof(mod.value) != TYPE_INT:
				mod.value = int(0)
				mod.emit_changed()
			%INT.value = mod.value 
		CardSig.ParamType.Float:
			if typeof(mod.value) != TYPE_FLOAT:
				mod.value = float(0.0)
				mod.emit_changed()
			%FLOAT.value = mod.value
		CardSig.ParamType.Bool:
			if typeof(mod.value) != TYPE_BOOL:
				mod.value = false
				mod.emit_changed()
			%BOOL.set_pressed_no_signal(mod.value)
		CardSig.ParamType.Enum:
			var enum_options = CECache.enum_cache[param_desc[1]]
			if typeof(mod.value) != TYPE_INT or int(mod.value) >= enum_options.size():
				mod.value = int(0)
				mod.emit_changed()
			CardSig.connect_menu_button_options(%ENUM, enum_options.keys()[mod.value], enum_options)
		CardSig.ParamType.EnumArray:
			var enum_options = CECache.enum_cache[param_desc[1]]
			if typeof(mod.value) != TYPE_INT or int(mod.value) >= enum_options.size():
				mod.value = int(0)
				mod.emit_changed()
			CardSig.connect_menu_button_options(%ENUM, enum_options.keys()[mod.value], enum_options)

func _set_value(mod: Modifier, value: Variant, setter: CardSig.ParamType) -> void:
	var param_type = _registered_params[mod.parameter][0]
	if setter == CardSig.ParamType.Enum and param_type in [CardSig.ParamType.Enum, CardSig.ParamType.EnumArray]:
		pass
	elif setter != param_type: 
		return
	mod.value = value

static func _type_methods(type: CardSig.ParamType) -> Array[String]:
	match type:
		CardSig.ParamType.Int: return ["Set", "Add"]
		CardSig.ParamType.Float: return ["Set", "Add"]
		CardSig.ParamType.Bool: return ["Set"]
		CardSig.ParamType.Enum: return ["Set"]
		CardSig.ParamType.EnumArray: return ["Add", "Remove"]
	
	return []
