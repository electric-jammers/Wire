extends Spatial
class_name MainScene

var sockets: = Array()
var cables: = Array()

onready var headphone_cable = get_node("HeadphoneFloppyCable")

var level_index := 0
var level: Node = null

var active_call_map: = Dictionary()

onready var sockets_root = $Sockets
onready var cables_root = $Cables
onready var wire_system = $WireSystem
onready var checklist = $Checklist

func _ready() -> void:
	sockets = sockets_root.get_children()
	for i in range(sockets.size()):
		sockets[i].connect("call_with_operator", self, "_on_call_with_operator")
		sockets[i].connect("call_complete", self, "_on_call_complete")
	
	cables = cables_root.get_children()
	
	headphone_cable.set_start_attached(true)
	
	_load_level(Levels.get_level_path(level_index))


func _on_level_complete():
	var finished_ui_scene = load("res://scenes/ui/RoundComplete.tscn") as PackedScene
	var finished_ui = finished_ui_scene.instance()
	finished_ui.main_scene = self
	get_tree().root.add_child(finished_ui)
	

func _on_call_with_operator(from: Socket, to: Socket):
	var call_idx = checklist.add_call(from.name, to.name)
	active_call_map[from.name] = call_idx
	active_call_map[to.name] = call_idx


func _on_call_complete(socket: Socket):
	if active_call_map.has(socket.name):
		var call_idx = active_call_map[socket.name]
		active_call_map.erase(call_idx)
		checklist.call_complete(call_idx)


func _load_level(path : String):
	var new_level: = load(path).instance() as LevelBase
	var level_setup: = new_level.create_level_setup()
	
	_setup_level(level_setup)
	new_level.initialize(self)
	wire_system.initialize()
	checklist.initialize()
	active_call_map.clear()
	
	if level:
		level.queue_free()
		remove_child(level)
	level = new_level
	level.connect("level_complete", self, "_on_level_complete")
	add_child(new_level)
	
func reload_level():
	_load_level(Levels.get_level_path(level_index))
	
func load_next_level():
	level_index += 1
	_load_level(Levels.get_level_path(level_index))
	
func _setup_level(level_setup : LevelSetup) -> void:
	for i in range(level_setup.MAX_SOCKETS):
		if level_setup.sockets[i]:
			if not sockets[i].get_parent():
				sockets_root.add_child(sockets[i])
		else:
			if sockets[i].get_parent():
				sockets_root.remove_child(sockets[i])
		
	for i in range(level_setup.MAX_CABLES):
		cables[i].visible = level_setup.cables[i]
