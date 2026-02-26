
extends VBoxContainer

var quotes = [
	"Failure is just practice.",
	"Try again, hero.",
	"Even legends fall.",
    "You’ll get it next time."
]

func _ready():
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))

func _on_visibility_changed():
	if visible:
		$QuoteLabel.text = quotes.pick_random()
