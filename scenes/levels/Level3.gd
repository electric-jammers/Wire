extends LevelBase

onready var timer: = $Timer as Timer
var complete1 = false
var complete2 = false


func create_level_setup() -> LevelSetup:
	var setup: = LevelSetup.new() # setup the level. WHich sockets and cables are available
	
	setup.sockets[11] = true
	setup.sockets[2] = true
	setup.sockets[4] = true
	setup.sockets[16] = true
	
	setup.cables[2] = true
	
	
	return setup


func _process(_delta) -> void: #similiar to tick in UE4
	if not complete: #if complete false play level
		if main_scene.sockets[11].state == Socket.State.CONNECTED: 
			if main_scene.sockets[2].state == Socket.State.CONNECTED:
				if not complete1:
					timer.start(1) #seconds until the first call is starting
					timer.connect("timeout", self, "_timer_finished")	
					complete1 = true
				
		if main_scene.sockets[4].state == Socket.State.CONNECTED: 
			if main_scene.sockets[16].state == Socket.State.CONNECTED:
				complete2 = true
				
	if complete1 == true && complete2 == true:
		complete = true  #finish state if both connected
		emit_signal("level_complete")

func _ready() -> void:
	timer.start(4) #seconds until the first call is starting
	timer.connect("timeout", self, "_timer_finished")


func _timer_finished() -> void:
	if complete1:
		main_scene.sockets[4].ring(main_scene.sockets[16])
	else:
		main_scene.sockets[11].ring(main_scene.sockets[2])  #### Call from socket 0 to socket 1
