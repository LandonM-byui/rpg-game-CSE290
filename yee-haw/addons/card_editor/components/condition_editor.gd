extends Node
class_name ConditionEditor

var _registered_parameters : Dictionary[String, Variant] = {}
var _last_loaded : CardSig.ParamType

func initialize(id: int, cond: Condition, valid_contexts: Array[String], delete_callback: Callable) -> void:
	%DELETE.button_down.connect(func(): delete_callback.call(id))
	
	_connect_context(cond, valid_contexts)
	_connect_parameter(cond, true)
	_connect_comparison(cond)
	
	CardSig.connect_menu_button_change(%CONTEXT, [ \
		func(index): cond.context = %CONTEXT.get_popup().get_item_text(index), \
		func(_i): cond.emit_changed(), \
		func(_i): _connect_parameter(cond), \
	])
	
	CardSig.connect_menu_button_change(%PARAMETER, [ \
		func(index): cond.parameter = %PARAMETER.get_popup().get_item_text(index), \
		func(_i): cond.emit_changed(), \
		func(_i): _connect_comparison(cond), \
	])
	
	CardSig.connect_menu_button_change(%COMPARISON, [\
		func(_i): cond.comparison = %COMPARISON.text, \
	])
	
	CardSig.connect_menu_button_change(%FLAG_BOOL, [ \
		func(index): _set_value(cond, index), \
	])
	%INT.get_line_edit().text_submitted.connect(func(val): _set_value(cond, int(val)))
	%FLOAT.get_line_edit().text_submitted.connect(func(val): _set_value(cond, float(val)))

func _connect_context(cond: Condition, valid_contexts: Array[String]) -> void:
	if not CardSig.connect_menu_button_options(%CONTEXT, cond.context, valid_contexts):
		cond.context = %CONTEXT.text
		cond.emit_changed()

func _connect_parameter(cond: Condition, skip:=false) -> void:
	_registered_parameters = CardSig.get_script_parameters(cond.context)
	if not CardSig.connect_menu_button_options(%PARAMETER, cond.parameter, _registered_parameters.keys()):
		cond.parameter = %PARAMETER.text
		cond.emit_changed()

func _connect_comparison(cond: Condition) -> void:
	var param := cond.parameter
	var param_type : CardSig.ParamType = _registered_parameters[param][0]
	
	if param_type == _last_loaded: return
	
	%FLAG_BOOL.hide()
	%INT.hide()
	%FLOAT.hide()
	
	match param_type:
		CardSig.ParamType.Int:
			%INT.show()
			%INT.get_line_edit().text = str(int(0))
			cond.expected = int(0)
			if not CardSig.connect_menu_button_options(%COMPARISON, cond.comparison, ["is", ">=", ">", "<", "<=", "not"]):
				cond.comparison = %COMPARISON.text
				cond.emit_changed()
		
		CardSig.ParamType.Float:
			%FLOAT.show()
			%FLOAT.get_line_edit().text = str(float(0.0))
			cond.expected = float(0.0)
			if not CardSig.connect_menu_button_options(%COMPARISON, cond.comparison, ["is", ">=", ">", "<", "<=", "not"]):
				cond.comparison = %COMPARISON.text
				cond.emit_changed()
		
		CardSig.ParamType.Bool:
			%FLAG_BOOL.show()
			if not CardSig.connect_menu_button_options(%FLAG_BOOL, str(cond.expected), ["False", "True"]):
				cond.expected = %FLAG_BOOL.text == "True"
				cond.emit_changed()
			if not CardSig.connect_menu_button_options(%COMPARISON, cond.comparison, ["is", "not"]):
				cond.comparison = %COMPARISON.text
				cond.emit_changed()
	
		CardSig.ParamType.Enum:
			%FLAG_BOOL.show()
			var options = CECache.enum_cache[_registered_parameters[param][1]]
			if not CardSig.connect_menu_button_options(%FLAG_BOOL, str(cond.expected), options.keys()):
				cond.expected = options[%FLAG_BOOL.text]
				cond.emit_changed()
			if not CardSig.connect_menu_button_options(%COMPARISON, cond.comparison, ["is", "not"]):
				cond.comparison = %COMPARISON.text
				cond.emit_changed()
		
		CardSig.ParamType.EnumArray:
			%FLAG_BOOL.show()
			var options = CECache.enum_cache[_registered_parameters[param][1]]
			if not CardSig.connect_menu_button_options(%FLAG_BOOL, str(cond.expected), options.keys()):
				cond.expected = options[%FLAG_BOOL.text]
				cond.emit_changed()
			cond.expected = str("has")
			if not CardSig.connect_menu_button_options(%COMPARISON, "has", ["has", "without"]):
				cond.comparison = %COMPARISON.text
				cond.emit_changed()
	
	_last_loaded = param_type

func _set_value(cond: Condition, val: Variant) -> void:
	match _last_loaded:
		CardSig.ParamType.Int:
			cond.expected = int(val)
		CardSig.ParamType.Float:
			cond.expected = float(val)
		CardSig.ParamType.Bool:
			cond.expected = bool(val)
		CardSig.ParamType.Enum:
			cond.expected = int(val)
		CardSig.ParamType.EnumArray:
			cond.expected = int(val)
