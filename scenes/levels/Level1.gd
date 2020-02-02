extends LevelBase

onready var timer: = $Timer as Timer
var complete1 = false
var complete2 = false


func create_level_setup() -> LevelSetup:
	var setup: = LevelSetup.new() # setup the level. WHich sockets and cables are available
	
	setup.sockets[0] = true
	setup.sockets[1] = true
	setup.sockets[6] = true
	setup.sockets[7] = true
	
	setup.cables[0] = true
	setup.cables[3] = true
	
	return setup


func _process(_delta) -> void: #similiar to tick in UE4
	if not complete: #if complete false play level
		if main_scene.sockets[0].state == Socket.State.CONNECTED: 
			if main_scene.sockets[1].state == Socket.State.CONNECTED:
				complete1 = true
				
		if main_scene.sockets[6].state == Socket.State.CONNECTED: 
			if main_scene.sockets[7].state == Socket.State.CONNECTED:
				complete2 = true
				
	if complete1 == true && complete2 == true:
		complete = true  #finish state if both connected
		emit_signal("level_complete")

func _ready() -> void:
	timer.start(4) #seconds until the first call is starting
	timer.connect("timeout", self, "_timer_finished")


func _timer_finished() -> void:
	main_scene.sockets[0].ring(main_scene.sockets[1])  #### Call from socket 0 to socket 1
