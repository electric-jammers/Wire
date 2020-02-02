extends Node
class_name LevelSetup

const MAX_SOCKETS = 36
const MAX_CABLES = 12

var sockets: = Array()
var cables: = Array()

func _init() -> void:
	sockets.resize(MAX_SOCKETS)
	for i in range(MAX_SOCKETS):
		sockets[i] = false
	
	cables.resize(MAX_CABLES)
	for i in range(MAX_CABLES):
		cables[i] = false
