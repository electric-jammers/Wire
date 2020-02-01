extends KinematicBody
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

	if cable_ref:
		var cable: FloppyCable = cable_ref.get_ref() 
		if cable:
			if is_end:
				cable.is_end_attached = attached
			else:
				cable.is_start_attached = attached

func is_attached() -> bool:
	return _attached

func get_collision_shape() -> CollisionShape:
	return $CollisionShape as CollisionShape


func set_position(new_pos: Vector3):
	translation = new_pos

func query(plug_query: Vector2) -> Vector3:
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(Vector2(0, 0), Vector2(50, 100))
	if result:
		print("Hit!" + result.position)
		return result.position
	return Vector3.INF



