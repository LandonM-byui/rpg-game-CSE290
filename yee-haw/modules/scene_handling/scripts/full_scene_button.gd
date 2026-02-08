extends BaseButton

## An UI button that redirects to a new scene, chosen from [GameSceneReference]
class_name FullSceneButton

## Allowed scene transitions
enum GameSceneReference {
	MainMenu,
	DeckChoice,
	Game
}

## Scene transition linked to button
@export var scene_link : GameSceneReference

## Signals the scene needs to be switched to the reference
signal switch_scene(ref: GameSceneReference)

## Propogates the button press signal to a receiver
func _prop_switch_scene() -> void:
	switch_scene.emit(scene_link)

func _ready() -> void:
	# connect button press to propogation
	pressed.connect(_prop_switch_scene)