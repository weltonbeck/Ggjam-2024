extends Node2D


func _on_start_game():
	GameControler.changeScenne("res://scennes/levels/Level1Scenne.tscn")

func _on_quit_game():
	get_tree().quit()
