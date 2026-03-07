extends Node2D
signal player_clicked(pos)

var player_id = 0
var char_name = ""
var player_position = []
var player_health = 10
var current = false

func initialize(id: int, name: String, in_party: bool, row: int, column: int) -> void:
	player_id = id;
	current = in_party;
	char_name = name;
	player_position.append(row)
	player_position.append(column)
	
func _set_player_position(row: int, column: int) -> void:
	player_position.clear()
	player_position.append(row)
	player_position.append(column)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		player_clicked.emit(player_position)
