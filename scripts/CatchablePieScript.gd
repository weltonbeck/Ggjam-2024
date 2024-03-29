extends "res://scripts/CatchableItemScript.gd"

func onHurled(delta):
	var sprite = $Sprite2D
	var tween = sprite.create_tween().set_loops(1)
	tween.tween_property(sprite, "rotation_degrees", direction * 90, 0.2)
	var velocity = 150
	position += transform.x * (direction * velocity) * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if hurled:
		queue_free()
