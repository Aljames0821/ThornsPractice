extends CharacterBody3D

const JUMP_VELOCITY = 4.5
var base_speed = 5.0
var speed_boost = 0.0
var boost_timer = 5.0
var max_health = 100
var current_health = 100

@onready var health_bar = $HealthBar3D/ProgressBar  # Or ProgressBar if you used that



func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Calculate current speed (base + boost)
	var current_speed = base_speed + speed_boost

	# Movement input
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, base_speed)
		velocity.z = move_toward(velocity.z, 0, base_speed)

	# Apply movement
	move_and_slide()

	# Handle boost timer
	if boost_timer > 0:
		boost_timer -= delta
		if boost_timer <= 0:
			speed_boost = 0  # Reset boost

# Called by Power-Up when collected
func activate_speed_boost(amount: float, duration: float):
	speed_boost = 20
	boost_timer = 10
func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	print("🔥 Damaging player!")
	
	# Update health bar
	if health_bar:
		health_bar.value = current_health

	# Optional: Check for death
	if current_health <= 0:
		get_tree().quit()

func die():
	print("💀 Entity died")
	queue_free()
func heal(amount: int):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	print("❤️ Current health:", current_health)

	if health_bar:
		health_bar.value = current_health
