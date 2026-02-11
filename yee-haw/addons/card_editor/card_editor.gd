@tool
extends EditorPlugin

var editor_window : CardEditRoot

func _enter_tree():
	CECache.build_cache()
	
	editor_window = preload("res://addons/card_editor/scenes/CardEditorRoot.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, editor_window)
	_on_inspector_changed()

	get_editor_interface().get_inspector().edited_object_changed.connect(_on_inspector_changed)

func _exit_tree():
	if editor_window:
		remove_control_from_docks(editor_window)
		editor_window.queue_free()

func _on_inspector_changed():
	if editor_window == null: return
	var obj := get_editor_interface().get_inspector().get_edited_object()
	if not obj is Resource:
		editor_window.load_resource(null)
		return
	editor_window.load_resource(obj)