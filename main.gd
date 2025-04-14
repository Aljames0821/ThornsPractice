extends Node3D

@onready var player = $Player

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "target_position", player.global_transform.origin)
