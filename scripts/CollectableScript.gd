extends Area2D

var collected = false
@onready var audio_collected = $AudioCollected

func _on_body_entered(_body):
	if collected == false:
		audio_collected.play()
		collected = true
		visible = false
		GameControler.hudGetTicket()
		await audio_collected.finished
		queue_free()
