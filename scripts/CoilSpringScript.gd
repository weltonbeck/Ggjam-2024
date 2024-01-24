extends Area2D

@export var jump_height = 16 * 4.5
@export var max_time_to_peak = 0.3

func _on_body_entered(body):
	if body.has_method("forceJump"):
		var jump_strength = -((jump_height * 2) / max_time_to_peak)
		body.forceJump(jump_strength)
