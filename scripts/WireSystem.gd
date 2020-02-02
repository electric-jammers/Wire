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

var hover_threshold = 0.1

func _ready():
	initialize()


func initialize():
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
	var board = Plane(Vector3(0, 0, 1), 0.1)
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
			if selected_plug.plugged_socket and hovered_socket != selected_plug.plugged_socket:
				selected_plug.set_attached(false)
				selected_plug.rotation = selected_plug.startup_transform.basis.get_euler()
				selected_plug.plugged_socket.unplug()
			if hovered_socket != null:
				selected_plug.set_attached(true)
				hovered_socket.plug_in(selected_plug)
			else:
				selected_plug.set_attached(false)
			selected_plug = null
	
	hovered_socket = null
	
	if selected_plug != null:
		var new_plug_pos = project_mouse_ray_onto_plane()
		if new_plug_pos != null:
			selected_plug.set_position(Vector3(new_plug_pos.x, new_plug_pos.y, 0.17))
			for socket in all_sockets:
				var socket_xy := Vector2(socket.global_transform.origin.x, socket.global_transform.origin.y)
				var plug_xy := Vector2(selected_plug.get_position().x, selected_plug.get_position().y)
				var dist = socket_xy.distance_to(plug_xy)
				if dist < hover_threshold and not socket.plug_occupied:
					hovered_socket = socket
					selected_plug.global_transform = selected_plug.global_transform.looking_at(hovered_socket.global_transform.origin, Vector3.UP)
					break
				else:
					selected_plug.rotation = Vector3(0, 0, 0)


func _physics_process(delta):
	if plug_query_pos != null:
		for plug in all_plugs:
			var new_plug_pos = plug.query(plug_query_pos, plug_query_dir)
			if new_plug_pos != Vector3.INF:
				selected_plug = plug
				if selected_plug.plugged_socket:
					selected_plug.plugged_socket.unplug()
				selected_plug.set_attached(true)
				var plane_intersection = project_mouse_ray_onto_plane()
				if plane_intersection != null:
					plug_mouse_offset = plug.translation - plane_intersection
		plug_query_pos = null


