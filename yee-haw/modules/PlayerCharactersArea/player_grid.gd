extends Node2D
signal tile_clicked(row, column)

var row
var column

func initialize(r, c):
	row = r
	column = c

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		tile_clicked.emit(row, column)
		

func _highlight():
	$Sprite2D.modulate = Color(0, 1, 0)
	
func _un_highlight():
	$Sprite2D.modulate = Color(1, 1, 1)
