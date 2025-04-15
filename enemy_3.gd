extends Node3D

@onready var detection_area = $DetectionArea
@onready var explosion_timer = $ExplosionTimer
var touched_player = false

func _ready():
	detection_area.body_entered.connect(on_body_entered)
	explosion_timer.timeout.connect(_on_explosion_timer_timeout)

func on_body_entered(body):
	if body.name == "Player" and not touched_player:
		print("Player touched enemy! Starting countdown...")
		touched_player = true
		explosion_timer.start(3.0)

func _on_explosion_timer_timeout():
	print("💥 Boom! Exploding with force!")

	# Push everyone away
	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("apply_central_impulse"): # For RigidBody3D
			var dir = (body.global_transform.origin - global_transform.origin).normalized()
			body.apply_central_impulse(dir * 100)
		elif body is CharacterBody3D:
			var dir = (body.global_transform.origin - global_transform.origin).normalized()
			body.velocity = dir * 100 # You can adjust the speed or add .y += 5 for a jump effect

	# Optional: Add particle/sound here
	queue_free()
