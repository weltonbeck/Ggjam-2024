extends Node2D

var tickets = 0

func _ready():
	tickets = 0
	$CanvasLayer/RichTextLabel.text = str(tickets).pad_zeros(4)
	GameControler.hudGetTicketSignal.connect(onGetTicket)

func onGetTicket():
	tickets += 1
	$CanvasLayer/RichTextLabel.text = str(tickets).pad_zeros(4)
