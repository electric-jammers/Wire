extends MeshInstance
class_name Plug

# Private state
var _attached := false 			setget set_attached,is_attached

# References
var cable_ref: WeakRef
var is_end := false

func _ready():
	
	pass # Replace with function body.

func set_attached(attached: bool):
	_attached = attached

	pass

func is_attached() -> bool:
	return _attached
