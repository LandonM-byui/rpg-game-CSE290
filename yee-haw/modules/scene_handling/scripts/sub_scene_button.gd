extends BaseButton

## Defines a button that opens up a sub menu.
class_name SubSceneButton

## Valid submenus to open
enum SubSceneReference {
	Settings,
	GameMenu,
}

## Subscene the button will open
@export var sub_scene_link : SubSceneReference

## Signals which sub scene to open
signal open_subscene(ref: SubSceneReference)

## Propogates the button press signal up
func _prop_open_subscene() -> void:
	open_subscene.emit(sub_scene_link)

func _ready() -> void:
	## Connects the button press to signal propogation
	pressed.connect(_prop_open_subscene)