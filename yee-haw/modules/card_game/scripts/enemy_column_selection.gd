extends EnemySelectionArea
class_name ColumnSelectionArea

@export var ref_rows : Array[Node2D]
@export var col_id : int

var linked_vfx : Array[Node2D]

func _ready() -> void:
	linked_vfx = []
	
	if col_id < 0:
		return
	
	for ref in ref_rows:
		if ref.get_child_count() <= col_id:
			continue
		linked_vfx.append(ref.get_child(col_id))

func select() -> void:
	for vfx in linked_vfx:
		vfx.modulate = SELECTION_COLOR

func deselect() -> void:
	for vfx in linked_vfx:
		vfx.modulate = NORMAL_COLOR