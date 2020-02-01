extends KinematicBody
class_name Plug

# Private state
var _attached:= false 			setget set_attached,is_attached

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

func get_position() -> Vector3:
	return translation

func query(ray_start: Vector3, ray_dir: Vector3) -> Vector3:
	var ray_end = ray_start + ray_dir * 1000.0
	
	var hit = get_world().get_direct_space_state().intersect_ray(ray_start, ray_end)
	if hit.size() != 0:
		if hit.collider == self:
			return hit.position
	
	return Vector3.INF





