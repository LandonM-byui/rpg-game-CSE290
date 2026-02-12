extends SceneController

## A custom scene controller for the battle game scene.
class_name BattleSceneController

@export_group("VFX controls")
@export var hand_vfx : HandContainer
@export var discard_vfx : CardBack
@export var discard_vfx_source : Control
@export var deck_vfx : CardBack
@export var deck_vfx_source : Control

var _project_data : ProjectData

## Open menu on "show_ui"
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("show_ui"): return
	open_subscene.emit(SubSceneButton.SubSceneReference.GameMenu)
	
func load_scene(pd: ProjectData) -> void:
	_project_data = pd
	
	hand_vfx.clear_hand_vfx()
	var hand := pd.draw_cards(5)
	hand_vfx.add_to_hand(hand)
	
	discard_vfx.data = pd.deck_preset
	deck_vfx.data = pd.deck_preset
	_update_vfx()

func unload_scene(pd: ProjectData) -> void:
	pd.return_removed_cards_to_deck()
	
func _update_vfx() -> void:
	discard_vfx_source.visible = len(_project_data.discard) > 0
	deck_vfx_source.visible = len(_project_data.full_deck) > 0
