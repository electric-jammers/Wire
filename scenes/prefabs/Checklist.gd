extends Spatial

var calls: = Array()

onready var rtlabel = $Viewport/Control/MarginContainer/RichTextLabel

func initialize():
	calls.clear()
	_reconstruct_text()


func add_call(from: String, to: String) -> int:
	var new_entry: = "{0} calling {1}".format([from, to])
	calls.append(new_entry)
	_reconstruct_text()

	return calls.size() - 1


func call_complete(idx: int):
	if idx >= 0 and idx < calls.size():
		calls[idx] = "[s]%s[/s]" % calls[idx]
		_reconstruct_text()


func _ready() -> void:
	_reconstruct_text()


func _reconstruct_text():
	var bbtex: = ""
	for i in range(calls.size()):
		bbtex = bbtex + calls[i] + "\n"
	rtlabel.bbcode_text = bbtex
	rtlabel.bbcode_text
