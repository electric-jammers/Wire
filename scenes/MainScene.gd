extends Spatial

var sockets: = Array()
var cables: = Array()

onready var headphone_socket = get_node("HeadphoneSocket")
onready var headphone_cable = get_node("HeadphoneFloppyCable")

var level_index := 0
var level: Node = null

onready var sockets_root = $Sockets
onready var cables_root = $Cables

func _ready() -> void:
	sockets = sockets_root.get_children()
	cables = cables_root.get_children()
	
	_load_level(Levels.get_level_path(level_index))


func _load_level(path : String):
	var new_level: = load(path).instance() as LevelBase
	var level_setup: = new_level.create_level_setup()
	
	_setup_level(level_setup)
	
	if level:
		level.queue_free()
		remove_child(level)
	level = new_level
	add_child(new_level)
	
	
func _setup_level(level_setup : LevelSetup) -> void:
	for i in range(level_setup.MAX_SOCKETS):
		sockets[i].visible = level_setup.sockets[i]
		
	for i in range(level_setup.MAX_CABLES):
		cables[i].visible = level_setup.cables[i]
