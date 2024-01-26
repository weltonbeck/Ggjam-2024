extends Area2D

var collected = false

func _on_body_entered(_body):
	if collected == false:
		collected = true
		GameControler.hudGetTicket()
		queue_free()
