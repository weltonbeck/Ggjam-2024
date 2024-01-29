extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player") && body.has_method("take_damage"):
		body.take_damage()
