extends LevelBase

func create_level_setup() -> LevelSetup:
	var setup: = LevelSetup.new()
	
	setup.sockets[0] = true
	setup.sockets[1] = true
	
	setup.cables[0] = true
	
	return setup
