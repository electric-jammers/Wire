extends FloppyCable
class_name Cable

# References
var _first_plug: Plug
var _second_plug: Plug

# Exports
export(NodePath) var first_plug_name: String
export(NodePath) var second_plug_name: String


func _ready():
	if first_plug_name and second_plug_name:
		_bind(get_node(first_plug_name), get_node(second_plug_name))

func _bind(first_plug: Plug, second_plug: Plug):
	_first_plug = first_plug
	_first_plug.cable_ref = weakref(self)
	_first_plug.is_end = true

	_second_plug = second_plug
	_second_plug.cable_ref = weakref(self)
	_second_plug.is_end = false

func get_start() -> Plug:
	return _first_plug

func get_end() -> Plug:
	return _second_plug

func set_start_attached(attached: bool):
	_first_plug.set_attached(attached)

func set_end_attached(attached: bool):
	_second_plug.set_attached(attached)
