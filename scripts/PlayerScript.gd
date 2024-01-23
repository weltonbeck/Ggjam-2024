extends CharacterBody2D

const AIR_FRICTION = 0.5

var gravity
var jump_strength
@export var speed = 150.0
@export var jump_height = 16 * 3
@export var max_time_to_peak = 0.3

var can_jump = false
var wait_jump = false
@export var coyote_time = 0.1
@export var jump_buffering_time = 0.1

func _ready():
	jump_strength = -((jump_height * 2) / max_time_to_peak)
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)

func _physics_process(delta):
	velocity.y += gravity * delta
	walk()
	move_and_slide()
	jump()
	
	#faz o shader cinza seguir
	$GrayscaleCanvas/ColorRect.material.set("shader_parameter/holeCenter", get_global_transform_with_canvas().origin)	
	
func walk():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, AIR_FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func jump():
	# coyote time
	if is_on_floor() && can_jump == false:
		can_jump = true
	elif !is_on_floor() && can_jump == false && $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyote_time)
		
	#jump
	if Input.is_action_just_pressed("jump"):
		wait_jump = true
		$JumpBufferingTimer.start(jump_buffering_time)
	
	if $JumpBufferingTimer.is_stopped():
		wait_jump = false
		
	if wait_jump && can_jump:
		velocity.y = jump_strength
		can_jump = false
		wait_jump = false
		
	# cancel jump
	if Input.is_action_just_released("jump") && !is_on_floor() && velocity.y < 0.0:
		velocity.y = 0.0
