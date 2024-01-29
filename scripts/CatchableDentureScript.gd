extends "res://scripts/CatchableItemScript.gd"

@onready var animated_sprite_2d = $AnimatedSprite2D

func onHurled(delta):
	animated_sprite_2d.play("walk")
	if direction == -1:
		animated_sprite_2d.flip_h = true
	var velocity = 150
	position += transform.x * (direction * velocity) * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if hurled:
		queue_free()
