extends Node2D

var tickets = 0

var heart_on = preload("res://sprites/hud/hud-heart-on.png")
var heart_off = preload("res://sprites/hud/hud-heart-off.png")

var max_life = 4
var life = 4

func _ready():
	life = max_life
	tickets = 0
	$CanvasLayer/RichTextLabel.text = str(tickets).pad_zeros(4)
	GameControler.hudGetTicketSignal.connect(onGetTicket)
	GameControler.hudTakeDamageSignal.connect(takeDamage)
	renderHearts()

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
		await get_tree().create_timer(1).timeout
		GameControler.changeScenne("res://scennes/levels/MenuScenne.tscn")
