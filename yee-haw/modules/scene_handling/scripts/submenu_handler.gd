extends Control

## Handles a sub-menu scene
class_name SubmenuHandler

## The button that closes the sub-menu window
@export var close_button : BaseButton
## All buttons that change the scene
@export var scene_buttons : Array[FullSceneButton]
## All buttons that open another sub-scene
@export var subscene_buttons : Array[SubSceneButton]

## Signals the menu to be closed
signal close_menu

## Propogates the signal up
func _propogate_close_menu() -> void:
	close_menu.emit()

func _ready() -> void:
	# connects the button press to signal propogation
	close_button.pressed.connect(_propogate_close_menu)
