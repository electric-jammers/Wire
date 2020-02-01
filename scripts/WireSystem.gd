extends Node

var all_cables = []
var all_plugs = []
var selected_plug: Plug = null
var plug_query_pos = null
var board_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	all_plugs = get_tree().get_nodes_in_group("plugs")
	board_size = Vector2(2, 2)

func mouse_pos_to_board_pos(mouse_pos) -> Vector3:
	var screen_size = get_viewport().get_rect().size
	return Vector3(mouse_pos.x / screen_size.x * board_size.x, mouse_pos.y / screen_size.y * board_size.y, 0)


func _process(delta):
	if Input.is_action_just_pressed("select"):
		if selected_plug == null:
			plug_query_pos = mouse_pos_to_board_pos(get_viewport().get_mouse_position())
	if Input.is_action_just_released("select"):
		if selected_plug != null:
			print("Released")
#			selected_plug.set_attached(false)
			selected_plug = null
	
	if selected_plug != null:
		var new_plug_pos = mouse_pos_to_board_pos(get_viewport().get_mouse_position())
		selected_plug.set_position(new_plug_pos)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _physics_process(delta):
	if plug_query_pos != null:
		for plug in all_plugs:
			var new_plug_pos = plug.query(plug_query_pos)
			if new_plug_pos != Vector3.INF:
				print("Hit! " + new_plug_pos)
				selected_plug = plug
		plug_query_pos = null

