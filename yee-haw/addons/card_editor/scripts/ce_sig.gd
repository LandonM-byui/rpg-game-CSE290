@tool
extends Resource
class_name CESig

static func new_bool_container(data: Resource, param: String) -> Control:
	const bool_container_prefab : PackedScene = preload("uid://c5trq5ucuii0s")
	var cont := bool_container_prefab.instantiate() as BoolContainer
	cont.initialize(data, param)
	return cont

static func new_enum_container(data: Resource, param: String) -> Control:
	const enum_container_prefab : PackedScene = preload("uid://uv4yrfsj1d78")
	var cont := enum_container_prefab.instantiate() as EnumContainer
	cont.initialize(data, param)
	return cont

static func new_float_container(data: Resource, param: String) -> Control:
	const float_container_prefab : PackedScene = preload("uid://drx4n4slrq7su")
	var cont := float_container_prefab.instantiate() as FloatContainer
	cont.initialize(data, param)
	return cont

static func new_int_container(data: Resource, param: String) -> Control:
	const int_container_prefab : PackedScene = preload("uid://b0pqhmn5148k7")
	var cont := int_container_prefab.instantiate() as IntContainer
	cont.initialize(data, param)
	return cont

static func new_resource_container(data: Resource, param: String) -> Control:
	const resource_container_prefab : PackedScene = preload("uid://dwnsveq5fwrp4")
	var cont := resource_container_prefab.instantiate() as ResourceContainer
	cont.initialize(data, param)
	return cont

static func _update_param( \
data: Resource, \
param: String, \
val: Variant, \
callbacks: Array[Callable] \
) -> void:
	if param != "":
		data.set(param, val)
		data.emit_changed()
	for callback in callbacks:
		callback.call(val)

## Connects a [LineEdit] as an [String] input for the [Resource] [param data]
static func connect_text( \
## Base [LineEdit] to get text from
le: LineEdit, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional Callbacks
callbacks: Array[Callable] = [] \
) -> void:
	if param != "":
		var iv : String = data.get(param)
		le.text = iv
	le.text_submitted.connect(func(nv):
		_update_param(data, param, nv, callbacks)
	)

## Connects a [LineEdit] as an [int] input for the [Resource] [param data]
static func connect_int( \
## Base [LineEdit] to get [int] from
le: LineEdit, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = []
) -> void:
	if param != "":
		var iv : int = data.get(param)
		le.text = str(iv)
	le.text_submitted.connect(func(nv): 
		_update_param(data, param, int(nv), callbacks)
	)

## Connects a [LineEdit] as a [float] input for the [Resource] [param data]
static func connect_float( \
## Base [LineEdit] to get [int] from
le: LineEdit, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = []
) -> void:
	if param != "":
		var iv : float = data.get(param)
		le.text = str(iv)
	le.text_submitted.connect(
		func(nv): _update_param(data, param, float(nv), callbacks)
	)

## Connects a [BaseButton] as a [bool] input for the [Resource] [param data]
static func connect_toggle( \
## [BaseButton] boolean toggle
bb: BaseButton, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = [] \
) -> void:
	if param != "":
		var iv : bool = data.get(param)
		bb.set_pressed_no_signal(iv)
	bb.toggled.connect(
		func(nv): _update_param(data, param, nv, callbacks)
	)

static func connect_enum( \
## [MenuButton] to apply the enum to
mb: MenuButton, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = [] \
) -> void:
	# pull enum options from cache or property hint
	var prop := _get_property_dict(param, data)
	var options : Dictionary
	if not prop.class_name in CECache.enum_cache.keys():
		options = _convert_hint_string_to_enum_dict(prop.hint_string)
	else:
		options = CECache.enum_cache[prop.class_name].duplicate()
	
	# initial value
	var iv = data.get(param)
	
	# initialize the popup
	var popup := mb.get_popup()
	var enum_relation := {}
	popup.clear()
	var item_set := false
	
	# generate options
	for option in options:
		var c_op : String = option.capitalize()
		var id : int = options[option]
		enum_relation[c_op] = id
	
		popup.add_radio_check_item(c_op, id)
		
		if iv == id:
			popup.set_item_checked(popup.get_item_index(id), true)
			mb.text = c_op
			item_set = true
	
	# enforce at least one item selected
	if not item_set and popup.get_item_count() > 0:
		popup.set_item_checked(0, true)
		mb.text = popup.get_item_text(0)
	
	# connect change
	popup.index_pressed.connect(func(idx):
		_enum_changed(idx, popup, mb, param, data, enum_relation, callbacks)
	)

## Applies an enum parameter change to VFX and [Resource]
static func _enum_changed( \
idx: int, \
popup: PopupMenu, \
mb: MenuButton, \
param: String, \
data: Resource, \
enum_relation: Dictionary, \
callbacks: Array[Callable] \
) -> void:
	var sel := popup.get_item_text(idx)
	mb.text = sel
	for i in range(popup.item_count):
		popup.set_item_checked(i, i == idx)
	_update_param(data, param, enum_relation[sel], callbacks)

static func connect_class_option( \
## [MenuButton] to apply the enum to
mb: MenuButton, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = [], \
## When true includes a none/null option
include_none: bool = false
) -> void:
	# pull enum options from cache or property hint
	var prop := _get_property_dict(param, data)
	var cls_name
	var no_iv := false
	if prop.hint_string.contains(":"):
		cls_name = prop.hint_string.split(':')[1]
		no_iv = true
	else:
		cls_name = prop.hint_string
	var options: Array = CECache.ancestry_cache[cls_name]

	# initialize the popup
	var popup := mb.get_popup()
	popup.clear()
	var initial_index := 0
	var iv: String
	if data.get(prop.name) == null:
		iv = "NULL VALUE"
	elif no_iv:
		iv = "NONE"	
	else:
		iv = data.get(prop.name).get_script().get_global_name()
	
	# include null option
	if include_none:
		options = options.duplicate()
		options.insert(0, "None")
		
	# generate options
	for id in range(len(options)):
		var c_op : String = options[id].capitalize()
		popup.add_radio_check_item(c_op, id)
		if iv == options[id]:
			initial_index = popup.get_item_index(id)

	# connect change
	popup.index_pressed.connect(func(idx):
		_class_op_changed(mb, popup, idx, options, callbacks)
	)

	# first call for initial callback value and menu intial selection
	_class_op_changed(mb, popup, initial_index, options, callbacks)

static func _class_op_changed( \
mb: MenuButton, \
popup: PopupMenu, \
idx: int, \
options, \
callbacks: Array[Callable], \
) -> void:
	var sel := popup.get_item_text(idx)
	mb.text = sel
	for i in range(popup.item_count):
		popup.set_item_checked(i, i == idx)
	var real_op = options[idx]
	for callback in callbacks:
		callback.call(real_op)

## Adjust the minimum size to stay consistent to the max item length size
static func menu_button_size_consistency(mb: MenuButton, adjustment: float = 0) -> void:
	var iv := mb.text
	var popup := mb.get_popup()
	var max_size: float = mb.size.x
	for i in range(popup.item_count):
		mb.text = popup.get_item_text(i)
		max_size = max(max_size, mb.size.x)
	mb.text = iv
	var min_size := mb.get_custom_minimum_size()
	min_size.x = max(min_size.x, max_size + adjustment)
	mb.set_custom_minimum_size(min_size)

static func _get_property_dict(param: String, data: Resource) -> Dictionary:
	for prop in data.get_property_list():
		if prop.name != param: continue
		return prop
	push_error("PROPERTY NOT FOUND '%s'" % [param])
	return {}

static func _convert_hint_string_to_enum_dict(hint_string:String) -> Dictionary:
	var ed : Dictionary = {}
	for split in hint_string.split(","):
		var kvp := split.split(":")
		ed[kvp[0]] = int(kvp[1])
	return ed

static func connect_resource( \
## Base [LineEdit] to get [int] from
rp: EditorResourcePicker, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = []
) -> void:
	var prop := _get_property_dict(param, data)
	var base_type : String = prop.class_name

	rp.base_type = base_type
	rp.edited_resource = data.get(param)
	rp.resource_changed.connect(func(val):
		_update_param(data, param, val, callbacks)
	)

static func connect_color( \
## Color picker
col: ColorPickerButton, \
## Parameter name in [param data]
param: String, \
## Data resource to connect and update
data: Resource, \
## Additional callbacks
callbacks: Array[Callable] = [], \
) -> void:
	if param != "":
		var iv = data.get(param)
		col.color = iv
	col.color_changed.connect(func(new_color):
		_update_param(data, param, new_color, callbacks)
	)
