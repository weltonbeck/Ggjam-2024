extends Node2D

signal hudGetTicketSignal
signal hudTakeDamageSignal
signal hudAddHappySignal

func changeScenne(newScenne):
	$TransitionCanvas/AnimationPlayer.play("fade_out")
	await $TransitionCanvas/AnimationPlayer.animation_finished
	assert(get_tree().change_scene_to_file(newScenne) == OK)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	$TransitionCanvas/AnimationPlayer.play("fade_in")
	
func hudGetTicket():
	emit_signal("hudGetTicketSignal")
	
func hudTakeDamage():
	emit_signal("hudTakeDamageSignal")
	
func hudAddHappy():
	emit_signal("hudAddHappySignal")
