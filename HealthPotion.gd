extends Area3D

@export var heal_amount: int = 100  # Amount to heal when collected

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.has_method("heal"):
		body.heal(heal_amount)
		print("❤️ Player healed by", heal_amount)
		queue_free()  # Remove the potion from the scene
