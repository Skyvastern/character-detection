extends Spatial


onready var enemy = owner

export var look_around_angle: float = 45
export var wait_time: float = 3.0
onready var current_wait_time = wait_time


func _ready() -> void:
	look_around_angle += rad2deg(enemy.target_y_rotation)


func process_look_around(delta: float) -> void:
	if current_wait_time <= 0.0:
		current_wait_time = wait_time
		look_around_angle = -look_around_angle
		enemy.target_y_rotation = deg2rad(look_around_angle)
	else:
		current_wait_time -= delta


func process_look_at_player() -> void:
	var enemy_pos: Vector3 = enemy.global_transform.origin
	var player_pos: Vector3 = Global.player.global_transform.origin
	var angle = Global.get_angle_to_rotate_for_slerp(enemy_pos, player_pos)
	enemy.target_y_rotation = angle
