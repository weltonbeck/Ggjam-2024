extends Node2D

@onready var click_sound = $ClickSound

func _on_start_game():
	await click_sound_play()
	GameControler.change_scene("res://scenes/commons/StoryScene.tscn")

func _on_quit_game():
	await click_sound_play()
	get_tree().quit()
	
func _on_back_menu():
	await click_sound_play()
	GameControler.change_scene("res://scenes/commons/StartScene.tscn")

func _on_go_to_credits():
	await click_sound_play()
	GameControler.change_scene("res://scenes/commons/CreditsScene.tscn")

func click_sound_play():
	click_sound.play()
	await click_sound.finished
