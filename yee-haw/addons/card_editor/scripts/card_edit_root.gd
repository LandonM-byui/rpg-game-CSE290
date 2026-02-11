@tool
extends Control
class_name CardEditRoot

var _card_editor : BaseCardEditor

func load_resource(res: Resource) -> void:
	if _card_editor: 
		_card_editor.queue_free()
		_card_editor = null
	
	if not res is CardData:
		%NO_RES_MESSAGE.show()
		return
	
	%NO_RES_MESSAGE.hide()
	_card_editor = preload("res://addons/card_editor/scenes/CardEditor.tscn").instantiate() as BaseCardEditor
	add_child(_card_editor)
#	_card_editor.owner = owner
	_card_editor.initialize(res as CardData)
