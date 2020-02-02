extends LevelBase

func create_level_setup() -> LevelSetup:
	var setup: = LevelSetup.new()
	
	setup.sockets[0] = true
	setup.sockets[1] = true
	
	setup.cables[0] = true
	
	return setup
	

func _ready() -> void:
	main_scene.sockets[0].ring(main_scene.sockets[1])
		
	
