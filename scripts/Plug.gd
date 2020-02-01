extends RigidBody
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

func get_collision_shape() -> CollisionShape:
	return $CollisionShape as CollisionShape

func is_attached() -> bool:
	return _attached

func set_position(new_pos: Vector3):
	translation = new_pos

func query(ray_start: Vector3, ray_dir: Vector3) -> Vector3:
	var ray_end = ray_start + ray_dir * 1000.0

	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(ray_start, ray_end)
	if hit.size() != 0:
		print("Hit!" + str(hit.position))
		return hit.position
		
	return Vector3.INF





