extends CharacterBody2D

const AIR_FRICTION = 0.5

var gravity
var jump_strength
@export var speed = 100.0
@export var jump_height = 16 * 3
@export var max_time_to_peak = 0.3

var can_move = true
var can_jump = false
var wait_jump = false
var coyote = false
@export var coyote_time = 0.1
@export var jump_buffering_time = 0.1

@export_flags_2d_physics var pass_through_layers = 3

var holdItem = false
signal pickItem
signal dropItem

var intangible = false
var intangibleTime = 1.5

enum {
	IDLE, WALK, JUMP, FALL, PICK
}

var status = IDLE

func _ready():
	jump_strength = -((jump_height * 2) / max_time_to_peak)
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)

func _physics_process(delta):
	velocity.y += gravity * delta
	if can_move:
		walk()
		jump()
	
	pass_through()
	pick()
	
	move_and_slide()
	
	animation()
	
	#faz o shader cinza seguir
	$GrayscaleCanvas/ColorRect.material.set("shader_parameter/holeCenter", get_global_transform_with_canvas().origin)	
	
func walk():
		var direction = Input.get_axis("ui_left", "ui_right")
		#flip
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction == -1
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
		$CoyoteTimer.stop()
		$CoyoteTimer.start(coyote_time)
		
	elif !is_on_floor() && coyote && $CoyoteTimer.is_stopped():
		can_jump = false
		
	#jump
	if Input.is_action_just_pressed("ui_jump"):
		wait_jump = true
		$JumpBufferingTimer.start(jump_buffering_time)
	if $JumpBufferingTimer.is_stopped():
		wait_jump = false
		
	if wait_jump && can_jump:
		forceJump(jump_strength)
		
	# cancel jump
	if Input.is_action_just_released("ui_jump") && !is_on_floor() && velocity.y < 0.0:
		velocity.y = 0.0
	
	if !is_on_floor() && velocity.y > 0:
		status = FALL
		
func forceJump(strength):
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
		can_move = false
		velocity.x = 0
		status = PICK
		emit_signal("pickItem")
	if status == PICK && !is_on_floor():
		status = FALL
		
	if Input.is_action_just_released("ui_pick"):
		emit_signal("dropItem")
		holdItem = false

func animation():
	if status == IDLE:
		$AnimatedSprite2D.play("idle")
	elif status == WALK:
		$AnimatedSprite2D.play("walk")
	elif status == JUMP && $AnimatedSprite2D.animation != "jump":
		$AnimatedSprite2D.play("jump")
	elif status == FALL && is_on_floor():
		$AnimatedSprite2D.play("grounded")
		await $AnimatedSprite2D.animation_finished
		status = IDLE
	elif status == FALL:
		if $AnimatedSprite2D.animation == "jump":
			await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("fall")
	elif status == PICK:
		$AnimatedSprite2D.play("pick")
		await $AnimatedSprite2D.animation_finished
		can_move = true
		status = IDLE

func takeDamage():
	if !intangible:
		GameControler.hudTakeDamage()
		intangible = true
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property($AnimatedSprite2D, "modulate", Color(0.89, 0.267, 0), 0.3)
		tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1, 1), 0.3)
		await get_tree().create_timer(intangibleTime).timeout
		tween.stop()
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
		intangible = false
