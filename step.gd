class_name Step
extends CollisionShape3D

@export var radius := 0.45
@onready var raycast: RayCast3D = $RayCast3D

func _ready() -> void:
	disabled = true
	raycast.hit_from_inside = false
	raycast.hit_back_faces = false

func try_enable(collision: KinematicCollision3D, floor_max_angle: float) -> void:
	if player_collided(collision, floor_max_angle) \
			and not is_above_knee(collision) \
			and step_rotated(collision) \
			and not has_barrier_between() \
			and raycast.is_colliding() \
			and not is_floor_too_steep(floor_max_angle):
		print("enabling step")
		disabled = false
	else:
		disabled = true


func player_collided(collision: KinematicCollision3D, floor_max_angle: float) -> bool:
	return collision.get_collision_count() != 0 and collision.get_angle() > floor_max_angle


func is_above_knee(collision) -> bool:
	return collision.get_position().y > raycast.global_position.y


func step_rotated(collision: KinematicCollision3D) -> bool: # notice side-effect
	var parent_space_collision := (transform * global_transform.inverse() * collision.get_position()).slide(Vector3.UP)
	if parent_space_collision.is_zero_approx():
		return false

	position = parent_space_collision.normalized() * radius + position.y * Vector3.UP
	return true


func is_floor_too_steep(floor_max_angle: float) -> bool:
	return raycast.get_collision_normal().angle_to(Vector3.UP) > floor_max_angle


func has_barrier_between() -> bool:
	var params := PhysicsRayQueryParameters3D.new()
	params.from = to_global(transform.inverse() * Vector3.ZERO).slide(Vector3.UP) + global_position.y * Vector3.UP # hip
	params.to = raycast.global_position # knee

	var query := get_world_3d().direct_space_state.intersect_ray(params)
	return not query.is_empty()
