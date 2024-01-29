extends Node2D

signal hud_get_ticket_signal
signal hud_get_life_signal
signal hud_take_damage_signal
signal hud_add_happy_signal
signal hud_die_signal

@onready var animation_player = $TransitionCanvas/AnimationPlayer


func _input(event):
	if event.is_action_pressed("full_screen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func change_scene(new_scene):
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(new_scene)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	animation_player.play("fade_in")
	
func hud_get_ticket():
	emit_signal("hud_get_ticket_signal")
	
func hud_get_life():
	emit_signal("hud_get_life_signal")
	
func hud_take_damage():
	emit_signal("hud_take_damage_signal")
	
func hud_add_happy():
	emit_signal("hud_add_happy_signal")
	
func hud_die():
	emit_signal("hud_die_signal")
