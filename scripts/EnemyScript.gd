extends CharacterBody2D
@onready var ray_cast = $RayCast
@export var jump_height = 16 * 3
@export var max_time_to_peak = 0.3
@export var speed = 70
@export var walking = true
@export var flipped = true
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var looking = $Looking

@onready var collision_shape_2d = $CollisionShape2D
@onready var hit_box_collision = $HitBox/CollisionShape2D


var gravity
var direction = 1
var dead = false

func _ready():
	set_walking(walking)
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	if flipped:
		scale.x = -1
		direction = -1


func _physics_process(delta):
	if (ray_cast.enabled and !ray_cast.is_colliding() or is_on_wall()) and walking and !dead:
		direction *= -1
		scale.x *= -1 

	if walking and !dead:
		velocity.x = direction * speed
		animated_sprite_2d.play("walk")

	velocity.y += gravity * delta

	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Bullet") and !dead:
		set_collision_mask_value(1, false)
		die()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") && body.has_method("takeDamage") and !dead:
		body.takeDamage()
		set_collision_mask_value(1, false)
		die()

func set_walking(value):
	walking = value

func die():
	velocity.x = 0
	dead = true
	animated_sprite_2d.play("clowning")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("clown_idle")


func _on_looking_body_entered(body):
	if !walking and !dead:
		animated_sprite_2d.play("scared")
		await animated_sprite_2d.animation_finished
		set_walking(true)
