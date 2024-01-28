extends Area2D

var collected = false

func _on_body_entered(_body):
	if collected == false:
		collected = true
		visible = false
		GameControler.hudGetLife()
		queue_free()
