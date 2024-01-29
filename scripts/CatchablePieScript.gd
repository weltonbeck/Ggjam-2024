extends "res://scripts/CatchableItemScript.gd"

@onready var sprite_2d = $Sprite2D

func onHurled(delta):

	var tween = sprite_2d.create_tween().set_loops(1)
	tween.tween_property(sprite_2d, "rotation_degrees", direction * 90, 0.2)
	var velocity = 150
	position += transform.x * (direction * velocity) * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if hurled:
		queue_free()
