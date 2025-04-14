# Trap.gd (for 3D)
extends Area3D

@export var damage_per_second : float = 10.0  # Damage dealt per second to enemies in the trap
@export var slow_amount : float = 0.5  # How much to slow enemies in the trap (0 = no slow)
@export var trap_duration : float = 5.0  # How long the trap lasts before being removed
@export var radius : float = 3.0  # Radius of the trap's effect area

var affected_enemies : Array = []  # List of enemies affected by the trap
var timer : Timer

func _ready():
	# Create and configure a timer to remove the trap after the duration
	timer = Timer.new()
	timer.wait_time = trap_duration
	timer.one_shot = true
	add_child(timer)
	timer.start()

	# Connect the body_entered signal to detect enemies


# Called when another body enters the area of the trap
func _on_Trap_body_entered(body: Node):
	if body.is_in_group("enemy"):  # Check if the body is in the "enemy" group
		if not affected_enemies.has(body):
			affected_enemies.append(body)
			apply_slow_and_damage(body)

# Apply damage and slow effect to the enemy
func apply_slow_and_damage(enemy: Node):
	# Damage logic: Apply damage over time
	if enemy.has_method("apply_damage"):
		enemy.apply_damage(damage_per_second * timer.wait_time)

	# Apply slow to enemy's movement (assuming enemy has velocity)
	if enemy.has_method("set_velocity"):
		var enemy_velocity = enemy.get("velocity")
		enemy_velocity *= (1.0 - slow_amount)  # Apply slow effect to the enemy's velocity
		enemy.set("velocity", enemy_velocity)

# Optionally, you can remove the trap after it expires
func _on_timer_timeout():
	queue_free()  # Remove the trap after its duration
