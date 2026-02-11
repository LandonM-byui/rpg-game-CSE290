@tool
extends Resource
class_name CECache

## Cache of EnumName: [Array] of the Enum dicts 
static var enum_cache := {}
## Cache of ClassName: TotalScriptPath
static var class_cache := {}
## Cache of BaseClassName: [Array] of ClassName that inherit BaseClass
static var ancestry_cache := {}

# builds all caches for quick access
static func build_cache() -> void:
	enum_cache = {}
	class_cache = {}
	ancestry_cache = {}

	const _EFFECT_ROOT := "res://modules/"
	_cache_enums(_EFFECT_ROOT)
	_cache_classes(_EFFECT_ROOT)

## Caches all enums references from root as enum_class_string : Dict(enum_string, enum_val)
static func _cache_enums(root: String) -> void:
	var dir := DirAccess.open(root)
	if dir == null: return
	
	dir.list_dir_begin()
	var entry := dir.get_next()
	
	while entry != "":
		if entry.begins_with("."):
			entry = dir.get_next()
			continue
		
		var full_path := root.path_join(entry)
		
		if dir.current_is_dir():
			_cache_enums(full_path)
		elif entry.ends_with(".gd"):
			_extract_enums_from_script(full_path)
		
		entry = dir.get_next()

## Parses a script for cachable enums
static func _extract_enums_from_script(full_path: String) -> void:
	var script := load(full_path)
	if script == null: return
	
	var cn : String = script.get_global_name()
	if cn == "": return
	
	var constants = script.get_script_constant_map()
	
	for constant_name in constants.keys():
		var value = constants[constant_name]
		if _is_enum_dictionary(value):
			var key:= "%s.%s" % [cn, constant_name]
			enum_cache[key] = value

## Verifires that a Variant type is an enum
static func _is_enum_dictionary(val) -> bool:
	if typeof(val) != TYPE_DICTIONARY: return false
	if val.is_empty(): return false
	for v in val.values():
		if typeof(v) != TYPE_INT: return false

	return true

## Caches all classes as class_name : Path, and base_class: array[inheritors]
static func _cache_classes(root: String) -> void:
	var dir := DirAccess.open(root)
	if dir == null: return
	
	dir.list_dir_begin()
	var entry := dir.get_next()
	
	while entry != "":
		if entry.begins_with("."):
			entry = dir.get_next()
			continue
		
		var full_path := root.path_join(entry)
		
		if dir.current_is_dir():
			_cache_classes(full_path)
		elif entry.ends_with(".gd"):
			_extract_script_data(full_path)
		
		entry = dir.get_next()

## Extracts data from a script
static func _extract_script_data(full_path: String) -> void:
	var script := load(full_path)
	if script == null: return
	
	var cn : String = script.get_global_name()
	if cn == "": return
	
	# Cache class paths
	class_cache[cn] = full_path
	
	# Cache class inheritance
	var base = script.get_base_script()
	if base == null: return
	
	_cache_class_inheritance(cn, base.get_global_name())

## Caches cn as an inheritor of base
static func _cache_class_inheritance(cn: String, base: String) -> void:
	if base in ancestry_cache.keys():
		ancestry_cache[base].append(cn)
	else:
		ancestry_cache[base] = [cn]