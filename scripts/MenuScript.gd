extends Node2D

@onready var click_sound = $ClickSound

func _on_start_game():
	await click_sound_play()
	GameControler.changeScenne("res://scennes/levels/Level1Scenne.tscn")

func _on_quit_game():
	await click_sound_play()
	get_tree().quit()
	
func _on_back_menu():
	await click_sound_play()
	GameControler.changeScenne("res://scennes/levels/MenuScenne.tscn")

func _on_go_to_credits():
	await click_sound_play()
	GameControler.changeScenne("res://scennes/levels/CreditsScenne.tscn")

func click_sound_play():
	click_sound.play()
	await click_sound.finished
