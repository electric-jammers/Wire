extends Spatial

var sockets: = Array()
var wires: = Array()

var level_index := 0

func _ready() -> void:
	_load_level(Levels.get_level_path(level_index))

func _load_level(path : String):
	var level = load(path).instance()
	var level_setup = level.create_level_setup()
	
	# Place setup logic here
	#
	####
	
	add_child(level)
	
