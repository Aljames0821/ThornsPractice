extends CharacterBody3D
const JUMP_VELOCITY = 4.5
var base_speed = 5.0
var speed_boost = 0.0
var boost_timer = 5.0
var max_health = 100
var current_health = 100

@onready var health_bar = $HealthCanvas/Billboard/HealthBar  # Adjust the path


@onready var nav_agent =$NavigationAgent3D  # Declare the NavigationAgent3D
@onready var detection_area: Area3D = $DetectionArea
@onready var explosion_timer: Timer = $ExplosionTimer
var touched_player = false


func _ready():
	if detection_area:
		detection_area.body_entered.connect(on_body_entered)
	else:
		push_error("❌ DetectionArea not found!")

func on_body_entered(body):
	if body.name == "Player" and not touched_player:
		print("Player touched enemy! Starting countdown...")
		touched_player = true
		explosion_timer.start(0.1)
		

func _on_explosion_timer_timeout():
	explode()

func explode():
	print("💥 Boom! Enemy exploded.")
	queue_free()
	
	
	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(90)  # 💥 Deal damage to player or others
		if body.has_method("apply_central_impulse"): # For RigidBody3D
			var dir = (body.global_transform.origin - global_transform.origin).normalized()
			body.apply_central_impulse(dir * 1000)
		elif body is CharacterBody3D:
			var dir = (body.global_transform.origin - global_transform.origin).normalized()
			body.velocity = dir * 1000 # You can adjust the speed or add .y += 5 for a jump effect
var SPEED = 3.0
var gravity = 9.8

func _process(delta):
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 2

	# Boosted movement speed
	var next_location = nav_agent.get_next_path_position()
	var current_location = global_transform.origin
	var current_speed = base_speed + speed_boost
	var new_velocity = (next_location - current_location).normalized() * current_speed

	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()

	# Handle boost timer
	if boost_timer > 0:
		boost_timer -= delta
		if boost_timer <= 0:
			speed_boost = 0


# Set a new target for the NavigationAgent
func target_position(target):
	nav_agent.target_location = target
	
func activate_speed_boost(amount: float, duration: float):
	speed_boost = 20
	boost_timer = 20
func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)

	# Update health bar
	if health_bar:
		health_bar.value = current_health

	# Optional: Check for death
	if current_health <= 0:
		die()

func die():
	print("💀 Entity died")
	queue_free()
