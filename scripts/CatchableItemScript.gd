extends Area2D

var velocity = 150

var playerHover = false
var collected = false
var hurled = false
@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	if player:
		player.pickItem.connect(pickItem)
		player.dropItem.connect(dropItem)

func _physics_process(delta):
	if playerHover && collected && player && player.get_node("PickMarker2D"):
		set_global_position( player.get_node("PickMarker2D").global_position)
	if hurled:
		position += transform.x * velocity * delta

func pickItem():
	if player && player.get_node("PickMarker2D"):
		collected = true
		player.holdItem = true
		
func dropItem():
	if collected && playerHover:
		collected = false
		playerHover = false
		hurled = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		playerHover = true

func _on_body_exited(body):
	if body.is_in_group("Player") && !collected:
		playerHover = false
