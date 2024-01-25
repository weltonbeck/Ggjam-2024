extends "res://scripts/CatchableItemScript.gd"


func onHurled(delta):
	$AnimatedSprite2D.play("walk")
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	var velocity = 150
	position += transform.x * (direction * velocity) * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if hurled:
		queue_free()
