extends Node2D

var can_pause = true
@onready var click_sound = $ClickSound

func _ready():
	$CanvasLayer.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") && get_tree().paused == false && can_pause:
		can_pause = false
		$CanvasLayer.visible = true
		get_tree().paused = true

func _on_unpause_game():
	click_sound.play()
	get_tree().paused = false
	$CanvasLayer.visible = false
	await get_tree().create_timer(0.2).timeout
	can_pause = true

func _on_quit_game():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()
