extends Spatial
class_name Socket


enum State { 
	OFF, 
	OUTGOING_CALL,
	WITH_OPERATOR,
	ON_HOLD,
	CONNECTED,
	ERROR
	}

var calling_to: Socket = null
var plug_occupied: Plug = null
var state setget set_state
var hovered := false
var call_duration := 0.0

var time_connected := 0.0

onready var socketLightMesh = $module/Module2
onready var light_material_resource = preload("res://materials/BlinkingLight.tres")
onready var light_material: ShaderMaterial = light_material_resource.duplicate()

signal call_complete(socket)
signal call_with_operator(calling_socket, called_socket)

func _ready():
	socketLightMesh.set_surface_material(2, light_material)
	set_state(State.OFF)

func _process(delta: float):
	if state == State.CONNECTED and call_duration > 0.0:
		var now = OS.get_ticks_msec()
		if ((now - time_connected) / 1000.0) > call_duration:
			var other_plug := plug_occupied.get_other_plug()
			if other_plug.plugged_socket:
				other_plug.plugged_socket.set_state(State.OFF)
			set_state(State.OFF)
			# Call complete
			emit_signal("call_complete", self)
	
func plug_in(plug: Plug):
	if not plug_occupied:
		plug_occupied = plug
		plug_occupied.plugged_socket = self
		
		match state:
			State.OFF:
				var other_plug: = plug.get_other_plug()
				if other_plug and other_plug.plugged_socket:
					if other_plug.plugged_socket.calling_to == self:
						set_state(State.CONNECTED)
						other_plug.plugged_socket.set_state(State.CONNECTED)
						
			State.OUTGOING_CALL:
				if plug.is_operator:
					set_state(State.WITH_OPERATOR)
				else:
					var other_plug: = plug.get_other_plug()
					if other_plug and other_plug.plugged_socket:
						set_state(State.CONNECTED)
						other_plug.plugged_socket.set_state(State.CONNECTED)
					
			State.ON_HOLD:
				var other_plug: = plug.get_other_plug()
				if other_plug and other_plug.plugged_socket:
					if other_plug.plugged_socket == calling_to:
						set_state(State.CONNECTED)
						other_plug.plugged_socket.set_state(State.CONNECTED)
	
	plug_occupied.set_position(global_transform.origin)
	plug_occupied.rotation = Vector3(0, 0, 0)
	plug_occupied.translate(Vector3(0.0, 0.0, 0.1))
	$Sounds/PluggedIn.play()


func unplug():
	if plug_occupied != null:	
		match state:
			State.WITH_OPERATOR:
				set_state(State.ON_HOLD)
			
			State.CONNECTED:
				set_state(State.ERROR)
		
		plug_occupied.plugged_socket = null
		plug_occupied = null
		
		$Sounds/Unplugged.play()

func get_occupier():
	return plug_occupied


func ring(target_socket: Socket, call_duration_seconds := 3.0):
	if calling_to == null:
		calling_to = target_socket
		call_duration = call_duration_seconds
		set_state(State.OUTGOING_CALL)

	
func set_state(new_state) -> void:
	if state == new_state:
		return
	
	state = new_state
	var cable = null
	if plug_occupied and plug_occupied.cable_ref:
		cable = plug_occupied.cable_ref.get_ref()
	
	match state:
		State.OFF:
			light_material.set_shader_param("colour", Color(1.0, 1.0, 1.0, 0.01))
			light_material.set_shader_param("flash_speed", 0.0)
			calling_to = null
			
			if cable: cable.talking_state = Cable.TalkingState.NONE
			
		State.OUTGOING_CALL:
			light_material.set_shader_param("colour", Color.orangered)
			light_material.set_shader_param("flash_speed", 10.0)
			if cable: cable.talking_state = Cable.TalkingState.TALKING_DOWN
		State.WITH_OPERATOR:
			light_material.set_shader_param("colour", Color.orange)
			light_material.set_shader_param("flash_speed", 0.0)
			if cable: cable.talking_state = Cable.TalkingState.TALKING_FLIP_FLOP
			emit_signal("call_with_operator", self, calling_to)
		State.ON_HOLD:
			light_material.set_shader_param("colour", Color.orange)
			light_material.set_shader_param("flash_speed", 10.0)
			if cable: cable.talking_state = Cable.TalkingState.NONE
		State.CONNECTED:
			light_material.set_shader_param("colour", Color.green)
			light_material.set_shader_param("flash_speed", 0.0)
			if cable: cable.talking_state = Cable.TalkingState.TALKING_FLIP_FLOP
			time_connected = OS.get_ticks_msec()
		State.ERROR:
			light_material.set_shader_param("colour", Color.red)
			light_material.set_shader_param("flash_speed", 20.0)
			if cable: cable.talking_state = Cable.TalkingState.NONE
