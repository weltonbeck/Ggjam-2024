extends Node2D

func _on_start_game():
	GameControler.changeScenne("res://scennes/levels/Level1Scenne.tscn")

func _on_quit_game():
	get_tree().quit()
	
func _on_back_menu():
	GameControler.changeScenne("res://scennes/levels/MenuScenne.tscn")

func _on_go_to_credits():
	GameControler.changeScenne("res://scennes/levels/CreditsScenne.tscn")
