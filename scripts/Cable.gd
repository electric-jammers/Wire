extends Rope
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

func _process(delta: float):
	if _first_plug.is_attached():
		set_start_attached(true)
		start_location = _first_plug.translation
	else:
		set_start_attached(false)
		_first_plug.global_transform.origin = to_global(get_start_location())

	if _second_plug.is_attached():
		set_end_attached(true)
		end_location = _second_plug.translation
	else:
		set_end_attached(false)
		_second_plug.global_transform.origin = to_global(get_end_location())

func _bind(first_plug: Plug, second_plug: Plug):
	_first_plug = first_plug
	_first_plug.set_attached(is_start_attached)
	_first_plug.cable_ref = weakref(self)
	_first_plug.is_end = false

	_second_plug = second_plug
	_second_plug.set_attached(is_end_attached)
	_second_plug.cable_ref = weakref(self)
	_second_plug.is_end = true

func get_start() -> Plug:
	return _first_plug

func get_end() -> Plug:
	return _second_plug

func set_start_attached(attached: bool):
	_first_plug.set_attached(attached)

func set_end_attached(attached: bool):
	_second_plug.set_attached(attached)
