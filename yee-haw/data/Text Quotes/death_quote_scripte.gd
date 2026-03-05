
extends VBoxContainer
class_name DeathQuoteScript
var quotes = [
	"We wouldn't be here if Hard Light was easy to eradicate.",
	"Well, I didn't get my money's worth.",
	"The Core still lives. We can't give up.",
    "The Chemists can't be right...they can't."
]

func _ready():
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))

func _on_visibility_changed():
	if visible:
		$QuoteLabel.text = quotes.pick_random()
