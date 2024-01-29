extends Area2D

var direction = 1
var playerHover = false
var collected = false
var hurled = false
var followPlayer = false
@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	if player:
		player.pick_item.connect(pick_item)
		player.drop_item.connect(drop_item)

func _physics_process(delta):
	if collected && player && player.get_node("PickMarker2D"):
		if !followPlayer:
			var tween = create_tween().set_loops(1)
			tween.tween_property(self, "global_position",  player.get_node("PickMarker2D").global_position, 0.3)
			await get_tree().create_timer(0.3).timeout
			tween.stop()
			followPlayer = true
		elif followPlayer:
			if player.get_node("AnimatedSprite2D").flip_h :
				direction = -1
			else:
				direction = 1
			set_global_position( player.get_node("PickMarker2D").global_position)
	if hurled:
		onHurled(delta)

func onHurled(_delta):
	pass

func pick_item():
	if player && player.get_node("PickMarker2D") && playerHover && !hurled:
		collected = true
		player.holdItem = true
		
func drop_item():
	if collected && playerHover:
		collected = false
		playerHover = false
		hurled = true
		$ThrowingSound.play()

func _on_body_entered(body):
	if body.is_in_group("Floor") && hurled:
		queue_free()
	if body.is_in_group("Enemy") && !body.dead:
		queue_free()
	if body.is_in_group("Player"):
		playerHover = true

func _on_body_exited(body):
	if body.is_in_group("Player")  && !collected:
		playerHover = false
