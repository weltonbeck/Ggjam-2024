extends Node2D

var tickets = 0
var level_musics = [preload("res://sounds/level1_music.mp3")]
var heart_on = preload("res://sprites/hud/hud-heart-on.png")
var heart_off = preload("res://sprites/hud/hud-heart-off.png")

var max_life = 4
var life = 4

var max_happy = 5
var happy = 0
@onready var happyTween
@onready var music_level = $MusicLevel
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var music_index = int(get_parent().get_parent().name.split("Level")[1]) 
@onready var full_bar_sound = $FullBarSound
@onready var get_life_sound = $GetLifeSound
@onready var happiness_progress = $CanvasLayer/HappinessBar/HappinessProgress
@onready var points_label = $CanvasLayer/PointsLabel
@onready var hearts = $CanvasLayer/Hearts
@onready var gray_scale = $GrayscaleCanvas/GrayScale




func _ready():

	if music_index and music_index != 0 and len(level_musics) >= music_index:
		music_level.stream = level_musics[music_index-1]
	else:
		music_level.stream = level_musics[0]

	music_level.play()

	life = max_life
	tickets = 0
	points_label.text = str(tickets).pad_zeros(4)
	GameControler.hud_get_ticket_signal.connect(on_get_ticket)
	GameControler.hud_get_life_signal.connect(add_life)
	GameControler.hud_take_damage_signal.connect(take_damage)
	GameControler.hud_add_happy_signal.connect(add_appy)
	GameControler.hud_die_signal.connect(game_over)
	renderHearts()

	update_grayscale_values()

	happiness_progress.max_value = max_happy
	happiness_progress.value = happy

func renderHearts() :
	for i in range(hearts.get_child_count()):
		if i >= life :
			hearts.get_child(i).set_texture(heart_off)
		else :
			hearts.get_child(i).set_texture(heart_on)

func on_get_ticket(value = 1):
	tickets += value
	points_label.text = str(tickets).pad_zeros(4)
	
func take_damage():
	life -= 1
	renderHearts()
	if life <= 0:
		game_over()

func game_over():
	if player:
		player.die()
		await get_tree().create_timer(0.2).timeout
		GameControler.change_scene("res://scenes/commons/CreditsScene.tscn")

func _process(_delta):
	gray_scale.material.set("shader_parameter/holeCenter", player.get_global_transform_with_canvas().origin)

func add_life():
	get_life_sound.play()
	if life < max_life:
		life += 1
	renderHearts()

func add_appy():
	if happy >= max_happy:
		on_get_ticket(10)
		add_life()
	else:
		happy += 1
		if happy >= max_happy:
			full_bar_sound.play()
		happiness_progress.value = happy
		update_grayscale_values()
	
func update_grayscale_values():
	var max_value = (230 * (happy + 1)) / max_happy
	var min_value = (200 * (happy + 1)) / max_happy
	if happyTween:
		happyTween.kill()
	happyTween = get_tree().create_tween()
	happyTween.set_loops()
	happyTween.tween_property(gray_scale.material, "shader_parameter/holeRadius", max_value, 1)
	happyTween.tween_property(gray_scale.material, "shader_parameter/holeRadius", min_value, 1)
