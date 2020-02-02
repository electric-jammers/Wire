extends Node
class_name LevelBase

signal level_complete

var main_scene: Node = null
var complete: = false

func initialize(main_scene_ref) -> void:
	main_scene = main_scene_ref
	

func create_level_setup() -> LevelSetup:
	print_debug("Calling LevelBase function:")
	return LevelSetup.new()
