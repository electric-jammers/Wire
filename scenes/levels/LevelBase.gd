extends Node
class_name LevelBase

func create_level_setup() -> LevelSetup:
	print_debug("Calling LevelBase function:")
	return LevelSetup.new()
