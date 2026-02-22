extends EnemySelectionArea
## Defines an entire enemy column as a selection area.
class_name ColumnSelectionArea

## Rows to pull enemy nodes from.
@export var ref_rows : Array[Node2D]
## Column index. (Gets children at this index from each row)
@export var col_id : int

## Tracked nodes that are referenced by this column.
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
