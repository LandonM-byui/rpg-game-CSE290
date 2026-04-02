extends BaseButton
class_name CardSourceInteraction

enum Source {
	Deck,
	Discard
}

@onready var battle_controller : BattleSceneController = %GAME_CONTROLLER.get_parent()

@export var source : Source

func _ready() -> void:
	pressed.connect(_show_source)
	
func _show_source() -> void:
	if source == Source.Deck:
		print("Deck: %s card(s)" % [battle_controller._bc.deck.size()])
	else:
		print("Discard: %s card(s)" % [battle_controller._bc.discard.size()])