extends Spatial

onready var label = $Viewport/Control/RichTextLabel

export var text := ""

func _ready() -> void:
	label.bbcode_text = "[color=black]" + text + "[/color]"
