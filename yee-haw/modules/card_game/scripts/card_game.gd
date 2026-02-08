extends SceneController

## A custom scene controller for the card game scene.
class_name CardGame

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("show_ui"): return
	open_subscene.emit(SubSceneButton.SubSceneReference.GameMenu)