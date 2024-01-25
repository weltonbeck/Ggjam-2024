extends CharacterBody2D

@export var jump_height = 16 * 3
@export var max_time_to_peak = 0.3
var gravity

func _ready():
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Bullet"):
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") && body.has_method("takeDamage"):
		body.takeDamage()
		queue_free()
