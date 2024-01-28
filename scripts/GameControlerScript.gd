extends Node2D

signal hudGetTicketSignal
signal hudGetLifeSignal
signal hudTakeDamageSignal
signal hudAddHappySignal
signal hudDieSignal


func _input(event):
	if event.is_action_pressed("full_screen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func changeScenne(newScenne):
	$TransitionCanvas/AnimationPlayer.play("fade_out")
	await $TransitionCanvas/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(newScenne)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	$TransitionCanvas/AnimationPlayer.play("fade_in")
	
func hudGetTicket():
	emit_signal("hudGetTicketSignal")
	
func hudGetLife():
	emit_signal("hudGetLifeSignal")
	
func hudTakeDamage():
	emit_signal("hudTakeDamageSignal")
	
func hudAddHappy():
	emit_signal("hudAddHappySignal")
	
func hudDie():
	emit_signal("hudDieSignal")
