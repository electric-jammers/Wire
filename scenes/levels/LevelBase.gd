extends Node
class_name LevelBase

var main_scene: Node = null

func initialize(main_scene_ref) -> void:
	main_scene = main_scene_ref
	

func create_level_setup() -> LevelSetup:
	print_debug("Calling LevelBase function:")
	return LevelSetup.new()
