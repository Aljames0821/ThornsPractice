extends Node3D

@export var speed_boost: float = 10.0  # Extra speed to add
@export var boost_duration: float = 5.0  # How long the boost lasts

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)  # Connect signal

func _on_body_entered(body):
	if body.has_method("activate_speed_boost"):
		body.activate_speed_boost(10.0, 5.0)  # You can adjust values
		queue_free()
