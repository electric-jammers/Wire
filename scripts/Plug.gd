extends KinematicBody
class_name Plug

export var is_operator: = false

# Private state
var _attached:= false 			setget set_attached,is_attached
var plugged_socket = null

# References
var cable_ref: WeakRef
var is_end := false

var startup_transform: Transform

func _ready():
	startup_transform = global_transform

func set_attached(attached: bool):
	_attached = attached

	if cable_ref:
		var cable: FloppyCable = cable_ref.get_ref() 
		if cable:
			if is_end:
				cable.is_end_attached = attached
			else:
				cable.is_start_attached = attached
	
			if not attached:
				if cable.get_second_plug() != self and not cable.get_second_plug().is_attached() or \
				   cable.get_first_plug() != self and not cable.get_first_plug().is_attached():
					# Neither end is attached, return to start pos
					global_transform = startup_transform
					set_attached(true)
			

func is_attached() -> bool:
	return _attached
	
	
func get_other_plug() -> Plug:
	var cable = cable_ref.get_ref()
	if cable:
		if is_end:
			return cable.get_first_plug()
		else:
			return cable.get_second_plug()
	return null

func get_collision_shape() -> CollisionShape:
	return $CollisionShape as CollisionShape

func set_position(new_pos: Vector3):
	global_transform.origin = new_pos

func get_position() -> Vector3:
	return global_transform.origin

func query(ray_start: Vector3, ray_dir: Vector3) -> Vector3:
	var ray_end = ray_start + ray_dir * 1000.0
	
	var hit = get_world().get_direct_space_state().intersect_ray(ray_start, ray_end)
	if hit.size() != 0:
		if hit.collider == self:
			return hit.position
	
	return Vector3.INF





