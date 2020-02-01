extends Node
class_name Levels

static func get_level_path(level_index : int) -> String:
	match level_index:
		0:
			return "res://scenes/levels/Level0.tscn"
		_:
			return "res://scenes/levels/LevelBase.tscn"
