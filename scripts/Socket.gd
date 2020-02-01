extends Spatial
class_name Socket

enum State { OFF, OUTGOING_CALL, CONNECTED }

var plug_occupied = null
var state setget set_state
var hovered := false
var light_material: ShaderMaterial

onready var socketLightMesh = $module/Module2
onready var light_material_resource = preload("res://materials/BlinkingLight.tres")

func _ready():
	light_material = light_material_resource.duplicate()
	socketLightMesh.set_surface_material(2, light_material)
	set_state(State.OFF)

func plug_in(plug):
	if plug_occupied == null:
		plug_occupied = plug
		plug_occupied.set_position(global_transform.origin)
		plug_occupied.plugged_socket = self

func unplug():
	if plug_occupied != null:
		plug_occupied.plugged_socket = null
		plug_occupied = null

func get_occupier():
	return plug_occupied
	
func set_state(new_state) -> void:
	state = new_state
	
	match state:
		State.OFF:
			light_material.set_shader_param("colour", Color(1.0, 1.0, 1.0, 0.01))
			light_material.set_shader_param("flash_speed", 0.0)
		State.OUTGOING_CALL:
			light_material.set_shader_param("colour", Color.red)
			light_material.set_shader_param("flash_speed", 10.0)
		State.CONNECTED:
			light_material.set_shader_param("colour", Color.green)
			light_material.set_shader_param("flash_speed", 0.0)
