extends KinematicBody



var speed: float = 10.0
var rotate_speed: float = 0.1

onready var animation_player = $EnemyModel/AnimationPlayer
onready var detection = $Components/Detection
onready var look_around = $Components/Look

var target_y_rotation: float = PI



func _process(delta: float) -> void:
	if detection.is_detected():
		animation_player.play("Focus", -1.0, 5.0)
		look_around.process_look_at_player()
	else:
		animation_player.play("Focus", -1.0, 1.0)
		look_around.process_look_around(delta)

	_apply_rotation()


func _apply_rotation() -> void:
	var new_basis: Basis = Global.rotate_slerp(global_transform, target_y_rotation, rotate_speed)
	global_transform.basis = new_basis
