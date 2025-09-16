extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var step: Step = $Step

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * 0.001
		camera_3d.rotation.x = clampf(camera_3d.rotation.x - event.relative.y * 0.001, deg_to_rad(-70.0), deg_to_rad(70.0))

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var input_movement := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity = 4.0 * (global_basis * Vector3(input_movement.x, 0.0, input_movement.y)) + velocity.y * Vector3.UP + get_gravity() * delta

	var collision := KinematicCollision3D.new()
	test_move(global_transform, velocity * delta, collision)
	step.try_enable(collision, floor_max_angle)

	move_and_slide()
