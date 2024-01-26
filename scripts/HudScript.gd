extends Node2D

var tickets = 0

var heart_on = preload("res://sprites/hud/hud-heart-on.png")
var heart_off = preload("res://sprites/hud/hud-heart-off.png")

var max_life = 4
var life = 4

var max_happy = 10
var happy = 1
@onready var happyTween = get_tree().create_tween().set_loops()

@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	life = max_life
	tickets = 0
	$CanvasLayer/RichTextLabel.text = str(tickets).pad_zeros(4)
	GameControler.hudGetTicketSignal.connect(onGetTicket)
	GameControler.hudTakeDamageSignal.connect(takeDamage)
	renderHearts()
	
	updateGrayscaleValues()

func renderHearts() :
	for i in range($CanvasLayer/Hearts.get_child_count()):
		if i >= life :
			$CanvasLayer/Hearts.get_child(i).set_texture(heart_off)
		else :
			$CanvasLayer/Hearts.get_child(i).set_texture(heart_on)

func onGetTicket():
	tickets += 1
	$CanvasLayer/RichTextLabel.text = str(tickets).pad_zeros(4)
	
func takeDamage():
	life -= 1
	renderHearts()
	if life <= 0:
		if player:
			player.die()
		await get_tree().create_timer(1).timeout
		GameControler.changeScenne("res://scennes/levels/MenuScenne.tscn")

func _process(delta):
	$GrayscaleCanvas/ColorRect.material.set("shader_parameter/holeCenter", player.get_global_transform_with_canvas().origin)
	
func updateGrayscaleValues():
	var max_value = (300 * happy) / max_happy
	var min_value = (250 * happy) / max_happy
	happyTween.set_loops()
	happyTween.tween_property($GrayscaleCanvas/ColorRect.material, "shader_parameter/holeRadius", max_value, 1)
	happyTween.tween_property($GrayscaleCanvas/ColorRect.material, "shader_parameter/holeRadius", min_value, 1)
