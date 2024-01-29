extends CharacterBody2D

const AIR_FRICTION = 0.5

var gravity
var jump_strength
@export var speed = 100.0
@export var jump_height = 16 * 3
@export var max_time_to_peak = 0.3
@onready var jump_sound = $JumpSound
@onready var damage_sound = $DamageSound
@onready var catch_sound = $CatchSound
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffering_timer = $JumpBufferingTimer
@onready var collision_shape_2d = $CollisionShape2D


var can_move = true
var can_jump = false
var wait_jump = false
var coyote = false
@export var coyote_time = 0.1
@export var jump_buffering_time = 0.1

@export_flags_2d_physics var pass_through_layers = 3

var holdItem = false
signal pick_item
signal drop_item

var intangible = false
var intangible_time = 1

enum {
	IDLE, WALK, JUMP, FALL, PICK
}

var status = IDLE
var is_dead = false


func _ready():
	jump_strength = -((jump_height * 2) / max_time_to_peak)
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)

func _physics_process(delta):
	if !is_dead:
		velocity.y += gravity * delta
		if can_move:
			walk()
			jump()
		pass_through()
		pick()
	
		move_and_slide()
	
	animation()
	fall_death()
	
func walk():
		var direction = Input.get_axis("ui_left", "ui_right")
		#flip
		if direction != 0:
			animated_sprite_2d.flip_h = direction == -1
		if direction:
			velocity.x = lerp(velocity.x, direction * speed, AIR_FRICTION)
			if is_on_floor() && status != JUMP && status != FALL:
				status = WALK
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor() && status != JUMP && status != FALL:
				status = IDLE

func jump():
	# coyote time
	if is_on_floor() && can_jump == false:
		can_jump = true
		coyote = false
	elif !is_on_floor() && can_jump && !coyote:
		coyote = true
		coyote_timer.stop()
		coyote_timer.start(coyote_time)
		
	elif !is_on_floor() && coyote && coyote_timer.is_stopped():
		can_jump = false
		
	#jump
	if Input.is_action_just_pressed("ui_jump"):
		jump_sound.play()
		wait_jump = true
		jump_buffering_timer.start(jump_buffering_time)
	if jump_buffering_timer.is_stopped():
		wait_jump = false
		
	if wait_jump && can_jump:
		force_jump(jump_strength)
		
	# cancel jump
	if Input.is_action_just_released("ui_jump") && !is_on_floor() && velocity.y < 0.0:
		velocity.y = 0.0
	
	if !is_on_floor() && velocity.y > 0:
		status = FALL
		
func force_jump(strength):
	status = JUMP
	velocity.y = strength
	can_jump = false
	wait_jump = false
	coyote = false

func pass_through():
	var layer_number = (log(pass_through_layers) / log(2)) + 1
	if Input.is_action_just_pressed("ui_down"):
		set_collision_mask_value(layer_number, false)
	elif Input.is_action_just_released("ui_down"):
		set_collision_mask_value(layer_number, true)

func pick():
	if Input.is_action_just_pressed("ui_pick") && is_on_floor():
		catch_sound.play()
		can_move = false
		velocity.x = 0
		status = PICK
		emit_signal("pick_item")
	if status == PICK && !is_on_floor():
		status = FALL
		
	if Input.is_action_just_released("ui_pick"):
		emit_signal("drop_item")
		holdItem = false

func animation():
	if status == IDLE:
		if holdItem:
			animated_sprite_2d.play("hold_idle")
		else:
			animated_sprite_2d.play("idle")
	elif status == WALK:
		if holdItem:
			animated_sprite_2d.play("hold_walk")
		else:
			animated_sprite_2d.play("walk")
	elif status == JUMP && animated_sprite_2d.animation != "jump":
		if holdItem:
			animated_sprite_2d.play("hold_jump")
		else:
			animated_sprite_2d.play("jump")
	elif status == FALL && is_on_floor():
		if holdItem:
			animated_sprite_2d.play("hold_grounded")
		else:
			animated_sprite_2d.play("grounded")
		await animated_sprite_2d.animation_finished
		status = IDLE
	elif status == FALL:
		if animated_sprite_2d.animation == "jump" || animated_sprite_2d.animation == "hold_jump":
			await animated_sprite_2d.animation_finished
		if holdItem:
			animated_sprite_2d.play("hold_fall")
		else:
			animated_sprite_2d.play("fall")
	elif status == PICK:
		animated_sprite_2d.play("pick")
		await animated_sprite_2d.animation_finished
		can_move = true
		status = IDLE

func take_damage():
	if can_move:
		damage_sound.play()
	if !intangible:
		GameControler.hud_take_damage()
		intangible = true
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(animated_sprite_2d, "modulate", Color(0.89, 0.267, 0), 0.3)
		tween.tween_property(animated_sprite_2d, "modulate", Color(1,1, 1), 0.3)
		await get_tree().create_timer(intangible_time).timeout
		tween.stop()
		collision_shape_2d.disabled = true
		collision_shape_2d.disabled = false
		animated_sprite_2d.modulate = Color(1, 1, 1)
		intangible = false

func die():
	status = IDLE
	velocity.x = 0
	can_move = false
	
func fall_death():
	if position.y > 160 && !is_dead:
		is_dead = true
		GameControler.hud_die()
