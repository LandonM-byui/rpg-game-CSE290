extends Object
class_name CardSig

## Processed parameter types
enum ParamType {
	Int,
	Float,
	Bool,
	Enum,
	EnumArray
}

## Sets enumerated menu button options
static func connect_menu_button_options(mb: MenuButton, iv: String, choices) -> bool:
	var popup := mb.get_popup()
	popup.clear()
	
	for choice in choices:
		popup.add_radio_check_item(choice)
	
	var checked :bool = false
	for i in range(popup.get_item_count()):
		var is_iv := popup.get_item_text(i) == iv 
		popup.set_item_checked(i, popup.get_item_text(i) == iv)
		if is_iv: checked = true
	
	if not checked:
		popup.set_item_checked(0, true)
		mb.text = popup.get_item_text(0)
		return false
	else:
		mb.text = iv
	return true
	
# Connects a menu button change to callbacks
static func connect_menu_button_change(mb: MenuButton, callbacks: Array[Callable] = []) -> void:
	mb.get_popup().index_pressed.connect(func(idx):
		_popup_changed(idx, mb, callbacks)
	)

static func _popup_changed(idx: int, mb: MenuButton, callbacks : Array[Callable] = []) -> void:
	var popup := mb.get_popup()
	mb.text = popup.get_item_text(idx)
	for i in range(popup.get_item_count()):
		popup.set_item_checked(i, i == idx)
	for callback in callbacks:
		callback.call(idx)

## Returns all parameters within the script that are valid processed types as a dictionary [param name: [ParamType, ..(hint)..]
static func get_script_parameters(cls_name: String) -> Dictionary[String, Variant]:
	var cls = load(CECache.class_cache[cls_name]).new()
	var registered_params : Dictionary[String, Variant] = {}
	
	for param in cls.get_property_list():
		if param.name == "resource_local_to_scene": continue
	
		if param.type == TYPE_INT:
			if CECache.enum_cache.has(param.class_name):
				registered_params[param.name] = [ParamType.Enum, param.class_name]
				continue
		
			registered_params[param.name] = [ParamType.Int]
			continue
		
		if param.type == TYPE_FLOAT:
			registered_params[param.name] = [ParamType.Float]
			continue
		
		if param.type == TYPE_BOOL:
			registered_params[param.name] = [ParamType.Bool]
			continue
		
		if param.type == TYPE_ARRAY:
			if CECache.enum_cache.has(param.hint_string):
				registered_params[param.name] = [ParamType.EnumArray, param.hint_string]
	
	return registered_params