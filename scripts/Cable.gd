extends FloppyCable
class_name Cable

enum TalkingState { NONE, TALKING_DOWN, TALKING_UP, TALKING_FLIP_FLOP }

# State
var talking_fx_speed := 1.5
var _talking_fx_distance := 0.0
var _talking_fx_flop := false
var _talking_state = TalkingState.NONE

# References
var _first_plug: Plug
var _second_plug: Plug

func get_first_plug() -> Plug:
	return _first_plug

func get_second_plug() -> Plug:
	return _second_plug

# Exports
export(NodePath) var first_plug_name: String
export(NodePath) var second_plug_name: String


func _ready():
	if first_plug_name and second_plug_name:
		_bind(get_node(first_plug_name), get_node(second_plug_name))

func rotate_plug_based_on_cable(delta: float, plug: Plug):
	var pos1 := get_position_on_cable(0.1)
	var pos2 := get_position_on_cable(0.01)
	if pos1 != pos2:
		var dir = (pos2 - pos1).normalized()
		if dir != Vector3.UP:
			print(dir)
			var right = dir.cross(Vector3.UP).normalized()
			var forward = dir
			var up = right.cross(forward)
			plug.global_transform.basis = plug.global_transform.basis.slerp(Basis(right, up, forward), clamp(delta*10.0, 0, 1))

func _process(delta: float):
	if _first_plug.is_attached():
		set_start_attached(true)
		start_location = _first_plug.translation
	else:
		set_start_attached(false)
		_first_plug.global_transform.origin = to_global(get_start_location())
		rotate_plug_based_on_cable(delta, _first_plug)
	
	if _second_plug.is_attached():
		set_end_attached(true)
		end_location = _second_plug.translation
	else:
		set_end_attached(false)
		_second_plug.global_transform.origin = to_global(get_end_location())
		rotate_plug_based_on_cable(delta, _second_plug)
	
	_process_talking_fx(delta)

func _process_talking_fx(delta: float):
	match _talking_state:
		TalkingState.TALKING_DOWN: 
			_talking_fx_distance += delta * talking_fx_speed
			if _talking_fx_distance > 1.0:
				_talking_fx_distance -= 1.0
				
		TalkingState.TALKING_UP:
			_talking_fx_distance -= delta * talking_fx_speed
			if _talking_fx_distance < 0.0:
				_talking_fx_distance += 1.0
			
		TalkingState.TALKING_FLIP_FLOP:
			if _talking_fx_flop:
				_talking_fx_distance -= delta * talking_fx_speed
				if _talking_fx_distance < 0.0:
					_talking_fx_flop = false
			else:
				_talking_fx_distance += delta * talking_fx_speed
				if _talking_fx_distance > 1.0:
					_talking_fx_flop = true
					
		_ : pass
			

	$TalkyBall.translation = to_local(get_position_on_cable(_talking_fx_distance))
	$TalkyBall.visible = _talking_state != TalkingState.NONE
	
	var second_distance = _talking_fx_distance - 0.4
	if second_distance < 0.0: second_distance += 1.0
	$TalkyBall2.translation = to_local(get_position_on_cable(second_distance))
	$TalkyBall2.visible = _talking_state != TalkingState.NONE

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
