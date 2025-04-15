extends Node3D

@onready var camera = get_viewport().get_camera_3d()

func _process(delta):
	if camera:
		look_at(camera.global_transform.origin, Vector3.UP)
