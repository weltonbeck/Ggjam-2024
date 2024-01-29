extends Area2D

@export var jump_height = 16 * 4.5
@export var max_time_to_peak = 0.3
@onready var sound = $Sound
@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_body_entered(body):
	if body.has_method("force_jump"):
		sound.play()
		animated_sprite_2d.play("active")
		await get_tree().create_timer(0.05).timeout
		var jump_strength = -((jump_height * 2) / max_time_to_peak)
		body.force_jump(jump_strength)
