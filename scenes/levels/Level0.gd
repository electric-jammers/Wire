extends LevelBase

onready var timer: = $Timer as Timer

func create_level_setup() -> LevelSetup:
	var setup: = LevelSetup.new()
	
	setup.sockets[0] = true
	setup.sockets[1] = true
	
	setup.cables[0] = true
	
	return setup


func _process(_delta) -> void:
	if not complete:
		if main_scene.sockets[0].state == Socket.State.CONNECTED: 
			if main_scene.sockets[1].state == Socket.State.CONNECTED:
				emit_signal("level_complete")
				complete = true
				print("Done!")

func _ready() -> void:
	timer.start(1.5)
	timer.connect("timeout", self, "_timer_finished")


func _timer_finished() -> void:
	main_scene.sockets[0].ring(main_scene.sockets[1])
