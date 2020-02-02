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
				if not complete1:
					timer.start(1) #seconds until the first call is starting
					complete1 = true
				
		if main_scene.sockets[6].state == Socket.State.CONNECTED: 
			if main_scene.sockets[7].state == Socket.State.CONNECTED:
				complete2 = true
				
	if !complete && complete1 == true && complete2 == true:
		complete = true  #finish state if both connected
		emit_signal("level_complete")

func _ready() -> void:
	timer.start(4) #seconds until the first call is starting


func _timer_finished() -> void:
	if complete1:
		main_scene.sockets[6].ring(main_scene.sockets[7])
	else:
		main_scene.sockets[0].ring(main_scene.sockets[1])  #### Call from socket 0 to socket 1
