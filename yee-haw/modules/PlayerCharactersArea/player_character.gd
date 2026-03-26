extends Node2D
signal player_clicked(pos)

var player_id = 0
var char_name = ""
var player_position = []
var player_health = 10
var player_max_health = 10
var moved = 0
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
		#if not _get_topmost():
			#return
		player_clicked.emit(player_position)

func _get_topmost():
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = space_state.intersect_point(query)
	
	var best = null
	var highest_z = -INF
	
	for r in results:
		var obj = r.collider
		
		if obj.has_method("_set_player_position"):
			if obj.z_index > highest_z:
				highest_z = obj.z_index
				best = obj
	
	return best

func add_move():
	moved -= 1
	
func toggle_hit_box():
	if $Area2D/CollisionShape2D.disabled == true:
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true

func _select():
	$Area2D/SamsonBase.modulate = Color(0, 1, 0)
func _un_highlight():
	$Area2D/SamsonBase.modulate = Color(1, 1, 1)
