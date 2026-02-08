extends BaseButton

## Defines a button that quits the project
class_name QuitButton

## Signals the game needs to be quit
signal quit_game

## Propogates the button press out as a custom signal
func _prop_quit_game() -> void:
	quit_game.emit()
	
func _ready() -> void:
	## Connect button press to propogation
	pressed.connect(_prop_quit_game)
