extends CharacterBody2D

var move_speed : float = 100.0
var jump_force : float = 250.0
var gravity : float = 900.0
var can_coyote_jump: bool = false
var in_use: bool = true

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export_file("*.png") var sprite_file

@export var my_active_num : int
@export var my_name: String

func _ready() -> void:
	sprite.texture = load(sprite_file)
	add_to_group("Player")
	set_name(my_name)

func _physics_process(delta):

	collision_shape_2d.disabled = not in_use
	
	if not in_use:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = 0
	
	if my_active_num == 0:
		if Input.is_key_pressed(KEY_A):
			velocity.x -= move_speed
			sprite_2d.flip_h = false
		if Input.is_key_pressed(KEY_D):
			velocity.x += move_speed
			sprite_2d.flip_h = true
		if Input.is_key_pressed(KEY_S):
			position.y += 1
		if Input.is_action_just_pressed("ui_select"):
			if is_on_floor() or can_coyote_jump:
				velocity.y = -jump_force
				if can_coyote_jump:
					can_coyote_jump = false
	elif my_active_num == 1:
		if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):
			velocity.x -= move_speed
			sprite_2d.flip_h = false
		if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):
			velocity.x += move_speed
			sprite_2d.flip_h = true
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			if is_on_floor() or can_coyote_jump:
				velocity.y = -jump_force
				if can_coyote_jump:
					can_coyote_jump = false
			
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	if global_position.y > 500:
		game_over()

func game_over():
	get_tree().reload_current_scene()

func set_my_active_num(num: int):
	my_active_num = num
	


func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
