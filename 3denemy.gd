extends CharacterBody3D

@onready var nav_agent =$NavigationAgent3D  # Declare the NavigationAgent3D

var SPEED = 3.0
var gravity = 9.8

func _process(delta):
	# Handle gravity if the character is not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 2  # Reset vertical velocity when on the floor
	
	# Get the next position in the navigation path
	var next_location = nav_agent.get_next_path_position()  # Corrected to use nav_agent
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized()* SPEED
	
	
	# Smoothly transition the velocity towards the target
	velocity = velocity.move_toward(new_velocity, 0.25)
	
	# Apply movement using move_and_slide
	move_and_slide()

# Set a new target for the NavigationAgent
func target_position(target):
	nav_agent.target_location = target
