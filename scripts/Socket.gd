extends Spatial
class_name Socket

enum State { OFF, OUTGOING_CALL, CONNECTED }

var plug_occupied = null
var currentState = State.OFF
var hovered := false
var light_material: SpatialMaterial

onready var socketLightMesh = get_node("SocketLight")

func _ready():
	socketLightMesh.set_surface_material(0, socketLightMesh.get_surface_material(0).duplicate())
	light_material = socketLightMesh.get_surface_material(0)

func set_hovered(inhovered):
	hovered = inhovered
	if hovered:
		light_material.emission = Color(1.0, 0.0, 0.0, 1.0)
	else:
		light_material.emission = Color(0.0, 1.0, 0.0, 1.0)

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
