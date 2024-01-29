extends Area2D

@export var levelFile : PackedScene


func _on_body_entered(body):
	if body.is_in_group("Player") && levelFile:
		body.die()
		await get_tree().create_timer(0.2).timeout
		GameControler.change_scene(levelFile.resource_path)
