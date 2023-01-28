extends KinematicBody

export var cam_path: NodePath
onready var cam: Camera = get_node(cam_path)

export var speed: float = 10.0
var velocity: Vector3 = Vector3.ZERO


func _physics_process(_delta: float) -> void:
	_look()
	_move()
	_animate()


func _look() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = cam.project_ray_normal(mouse_pos)
	
	var plane = Plane(Vector3.UP, global_transform.origin.y)
	var intersection_point = plane.intersects_ray(ray_origin, ray_dir)
	if intersection_point:
		_rotate(intersection_point)


func _move() -> void:
	var vertical: float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var horizontal: float = Input.get_action_strength("right") - Input.get_action_strength("left")

	var forward_dir = Vector3(cam.global_transform.basis.z.x, 0.0, cam.global_transform.basis.z.z)
	var right_dir = Vector3(cam.global_transform.basis.x.x, 0.0, cam.global_transform.basis.x.z)
	velocity = forward_dir * vertical + right_dir * horizontal	
	velocity *= speed

	velocity = move_and_slide(velocity, Vector3.UP)


func _rotate(target: Vector3) -> void:
	var angle: float = Global.get_angle_to_rotate_for_slerp(global_transform.origin, target)
	var new_basis: Basis = Global.rotate_slerp(global_transform, angle, 0.25)
	global_transform.basis = new_basis


func _animate() -> void:
	if velocity.length() == 0:
		$PlayerModel/AnimationPlayer.play("Focus", 0.1, 1.0)
	else:
		$PlayerModel/AnimationPlayer.play("Focus", 0.1, 5.0)
