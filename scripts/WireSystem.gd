extends Node

var all_cables = []
var all_plugs = []
var all_sockets = []
var selected_plug: Plug = null
var hovered_socket: Socket = null
var plug_query_pos = null
var plug_query_dir = null
var board_size: Vector2
var plug_mouse_offset := Vector3.ZERO

var hover_threshold = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	all_plugs = get_tree().get_nodes_in_group("plugs")
	all_sockets = get_tree().get_nodes_in_group("sockets")
	board_size = Vector2(2, 2)

func mouse_pos_to_board_pos(mouse_pos) -> Vector3:
	var screen_size = OS.get_screen_size()
	return Vector3(mouse_pos.x / screen_size.x * board_size.x, mouse_pos.y / screen_size.y * board_size.y, 0)

func project_mouse_ray_onto_plane() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_parent().get_node("Camera")
	var query_pos = camera.project_ray_origin(mouse_pos)
	var query_dir = camera.project_ray_normal(mouse_pos)
	var board = Plane(Vector3(0, 0, 1), 0.0)
	var new_plug_pos = board.intersects_ray(query_pos, query_dir)
	
	return new_plug_pos



func _process(delta):
	if Input.is_action_just_pressed("select"):
		if selected_plug == null:
			var mouse_pos = get_viewport().get_mouse_position()
			var camera = get_parent().get_node("Camera")
			plug_query_pos = camera.project_ray_origin(mouse_pos)
			plug_query_dir = camera.project_ray_normal(mouse_pos)

	if Input.is_action_just_released("select"):
		if selected_plug != null:
			if hovered_socket != null:
				selected_plug.set_attached(true)
				hovered_socket.plug_in(selected_plug)
				selected_plug.rotation = Vector3(PI/2, 0, 0)
			else:
				selected_plug.set_attached(false)
				selected_plug.rotation = Vector3.ZERO
			selected_plug = null
	
	if selected_plug != null:	
		if hovered_socket != null:
			hovered_socket.set_state(0)
			hovered_socket.unplug()
			hovered_socket = null
		var new_plug_pos = project_mouse_ray_onto_plane()
		if new_plug_pos != null:
			
			selected_plug.set_position(Vector3(new_plug_pos.x, new_plug_pos.y, selected_plug.get_position().z))
			for socket in all_sockets:
				var dist = socket.global_transform.origin.distance_to(selected_plug.get_position())
				#print(dist)
				if dist < hover_threshold:
					hovered_socket = socket
					hovered_socket.set_state(1)
					
					selected_plug.global_transform = selected_plug.global_transform.looking_at(hovered_socket.global_transform.origin, Vector3.UP)
					
					var z_rot: = 90.0
					if (hovered_socket.global_transform.origin - selected_plug.global_transform.origin).x < 0.0:
						z_rot = -90.0
					
					selected_plug.rotate_z(z_rot)
					break
			#print()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _physics_process(delta):
	if plug_query_pos != null:
		for plug in all_plugs:
			var new_plug_pos = plug.query(plug_query_pos, plug_query_dir)
			if new_plug_pos != Vector3.INF:
				selected_plug = plug
				selected_plug.set_attached(true)
				var plane_intersection = project_mouse_ray_onto_plane()
				if plane_intersection != null:
					plug_mouse_offset = plug.translation - plane_intersection
					#print(plug_mouse_offset)
					break
				if selected_plug.plugged_socket != null:
					hovered_socket.unplug()
		plug_query_pos = null


