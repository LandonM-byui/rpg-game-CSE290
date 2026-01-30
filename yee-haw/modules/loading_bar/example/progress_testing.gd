extends Control

@onready var button : Button = $Button
@onready var progress : LevelProgressController = $LevelProgressBox
@onready var timer : Timer = $Timer
@onready var timer2 : Timer = $Timer2

func _ready():
	progress.visible = false
	button.pressed.connect(_show_progress)
	timer.timeout.connect(_update_progress_window)
	progress.bar_updated.connect(_disable_progress_window)
	timer2.timeout.connect(_apply_disable_progress_window)

func _show_progress():
	if not progress.can_increase():
		return
	
	timer.start()

func _update_progress_window():
	progress.visible = true
	progress.increase_value()

func _disable_progress_window():
	timer2.start()

func _apply_disable_progress_window():
	progress.visible = false
	
	if not progress.can_increase():
		button.disabled = true
