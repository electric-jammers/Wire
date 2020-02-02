extends Spatial
class_name MainScene

var sockets: = Array()
var cables: = Array()

onready var headphone_cable = get_node("HeadphoneFloppyCable")

var level_index := 0
var level: Node = null

onready var sockets_root = $Sockets
onready var cables_root = $Cables
onready var wire_system = $WireSystem

func _ready() -> void:
	sockets = sockets_root.get_children()
	cables = cables_root.get_children()
	
	headphone_cable.set_start_attached(true)
	
	_load_level(Levels.get_level_path(level_index))


func _load_level(path : String):
	var new_level: = load(path).instance() as LevelBase
	var level_setup: = new_level.create_level_setup()
	
	_setup_level(level_setup)
	new_level.initialize(self)
	wire_system.initialize()
	
	
	if level:
		level.queue_free()
		remove_child(level)
	level = new_level
	add_child(new_level)
	
	
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
