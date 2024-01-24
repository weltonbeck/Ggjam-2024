extends Area2D

var collected = false

func _on_body_entered(_body):
	if collected == false:
		collected = true
		GameControler.hudGetTicket()
		#await get_tree().create_timer(0.5).timeout
		queue_free()	
