extends Spatial



var los_length: float = 15.0
onready var los_angle: float = deg2rad($"SpotLight".spot_angle)
var los_accuracy: int = 25
onready var collision_layer: int = Global.get_layers_bitmask([3]) # Collision layer - "World"



func is_detected() -> bool:
	if _is_player_in_detection_area():
		if _is_player_inside_los_angle():
			var origin: Vector3 = $SpotLight.global_transform.origin
			var target: Vector3 = Global.player.global_transform.origin
			var result: Dictionary = create_ray(origin, target)
				
			if result.empty():
				$AnimationPlayer.play("Red")
				return true
			
	$AnimationPlayer.play("White")
	return false



func _is_player_in_detection_area() -> bool:
	var spotlight_pos = $SpotLight.global_transform.origin
	var player_pos: Vector3 = Global.player.global_transform.origin
	var distance_to_player: float = spotlight_pos.distance_to(player_pos)

	return distance_to_player < los_length


func _is_player_inside_los_angle() -> bool:
	var spotlight_pos = $SpotLight.global_transform.origin
	var player_pos: Vector3 = Global.player.global_transform.origin	
	var dir_towards_player: Vector3 = spotlight_pos.direction_to(player_pos)

	var forward: Vector3 = -$SpotLight.global_transform.basis.z
	var angle = forward.angle_to(dir_towards_player)

	return angle < los_angle


func create_ray(origin: Vector3, target: Vector3) -> Dictionary:
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(origin, target, [], collision_layer)
	return result
