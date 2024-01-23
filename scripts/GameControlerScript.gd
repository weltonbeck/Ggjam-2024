extends Node2D

func changeScenne(newScenne):
	$TransitionCanvas/AnimationPlayer.play("fade_out")
	await $TransitionCanvas/AnimationPlayer.animation_finished
	assert(get_tree().change_scene_to_file(newScenne) == OK)
	await get_tree().process_frame
	#await get_tree().create_timer(0.5).timeout
	$TransitionCanvas/AnimationPlayer.play("fade_in")
	
