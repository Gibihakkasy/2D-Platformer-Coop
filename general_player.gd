extends CharacterBody2D

var move_speed : float = 100.0
@export var jump_force : float = 250.0
var gravity : float = 900.0
var can_coyote_jump: bool = false
var jump_buffered = false
var in_use: bool = true

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var pcam: PhantomCamera2D = get_tree().current_scene.get_node("Camera2D/PhantomCamera2D")

@export var my_active_num : int
@export var my_name: String
@export_range(1, 2) var gravity_modifier : float = 1.2
@export_file("*.png") var my_sprite

#weapon
@onready var weapon: Node2D = $Weapon
@onready var weapon_marker: Marker2D = $Weapon/WeaponMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	add_to_group("Player")
	set_name(my_name)
	sprite_2d.texture = load(my_sprite)
	pcam.append_follow_targets(self)

func _physics_process(delta):

	collision_shape_2d.disabled = not in_use
	
	if not in_use:
		return

	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta * gravity_modifier			
		else:
			velocity.y += gravity * delta
		
	velocity.x = 0
	
	if my_active_num == 0:
		if Input.is_key_pressed(KEY_A):
			velocity.x -= move_speed
			sprite_2d.flip_h = false
			if weapon.position.x > 0:
				weapon.position.x *= -1
				weapon.scale.x *= -1
		if Input.is_key_pressed(KEY_D):
			velocity.x += move_speed
			sprite_2d.flip_h = true
			if weapon.position.x < 0:
				weapon.position.x *=-1
				weapon.scale.x *= -1
		if Input.is_key_pressed(KEY_S):
			position.y += 1
		if Input.is_action_just_pressed("ui_select"):
			jump(delta)
		if Input.is_action_just_pressed("attack"):
			attack()
	elif my_active_num == 1:
		if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):
			velocity.x -= move_speed
			sprite_2d.flip_h = false
		if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):
			velocity.x += move_speed
			sprite_2d.flip_h = true
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			jump(delta)
			
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and !is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	if !was_on_floor and is_on_floor():
		if jump_buffered:
			jump(delta)
		
	
	if global_position.y > 500:
		game_over()

func attack():
	animation_player.play("Attack")

func jump(delta):
	if is_on_floor() or can_coyote_jump:
		velocity.y = -jump_force
		if can_coyote_jump:
			can_coyote_jump = false
	else:
		if !jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()

func game_over():
	get_tree().reload_current_scene()

func set_my_active_num(num: int):
	my_active_num = num
	

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play("Idle")
