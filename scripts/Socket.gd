extends Node
class_name Socket

enum State { OFF, OUTGOING_CALL, CONNECTED }

var plug_occupied: Plug = null
var currentState = State.OFF

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func plug_in(plug: Plug):
	if plug_occupied == null:
		plug_occupied = plug

func get_occupier() -> Plug:
	return plug_occupied

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
