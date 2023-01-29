extends Node


onready var main = get_tree().root.get_node("Main")
onready var player = get_tree().root.get_node("Main/Player")
onready var camera = get_tree().root.get_node("Main/Camera")



func get_angle_to_rotate_for_slerp(origin: Vector3, target: Vector3) -> float:
	var towards = origin.direction_to(target)
	return Vector3.FORWARD.signed_angle_to(towards, Vector3.UP)


func rotate_slerp(t: Transform, angle: float, slerp_amount: float) -> Basis:
	# Current Quat
	var basis: Basis = t.basis.orthonormalized()
	var start_quat: Quat = basis.get_rotation_quat()

	# Target Quat
	var target_quat = Quat(Vector3.UP, angle)

	# Interpolate
	var result_quat = start_quat.slerp(target_quat, slerp_amount)
	return Basis(result_quat)


func get_layers_bitmask(layers: Array) -> int:
	var bitmask: int = 0

	for l in layers:
		bitmask += int(pow(2, l-1))
	
	return bitmask
