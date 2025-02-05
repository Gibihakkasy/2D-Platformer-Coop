extends CharacterBody2D

var gravity : float = 900.0
var in_use: bool = false
var rider_number: int
var can_coyote_jump: bool = false
var jump_buffered = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rider_container: Node2D = $RiderContainer
@onready var rider_position: Marker2D = $RiderPosition
@onready var sprite: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var pcam: PhantomCamera2D = get_tree().current_scene.get_node("Camera2D").get_node("PhantomCamera2D")

@export_group("Mount Properties")
@export var mount_name: String
@export var move_speed : float = 100.0
@export var jump_force : float = 200.0
@export_enum("Fly", "Fast", "Swim", "Dig") var mount_type: String

func _ready() -> void:
	add_to_group("Mount")
	set_name(mount_name)

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = 0
	if in_use:
		if rider_number == 0:
			if Input.is_key_pressed(KEY_A):
				velocity.x -= move_speed
				sprite.flip_h = false
			if Input.is_key_pressed(KEY_D):
				velocity.x += move_speed
				sprite.flip_h = true
			if Input.is_key_pressed(KEY_SPACE):
				jump()
			if Input.is_key_pressed(KEY_Q):
				_dismount()
		elif rider_number == 1:
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):
				velocity.x -= move_speed
				sprite.flip_h = false
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):
				velocity.x += move_speed
				sprite.flip_h = true
			if Input.is_joy_button_pressed(0, JOY_BUTTON_A):
				jump()
			if Input.is_joy_button_pressed(0, JOY_BUTTON_X):
				_dismount()
		
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	if global_position.y > 500:
		game_over()

#damp to make smaller jump for variable jump height, e.g. tap vs hold
func jump(damp: float = 1):
	if mount_type == "Fly":
		velocity.y = -jump_force
	elif mount_type != "Fly":
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and in_use == false:
		body.in_use = false
		rider_number = body.my_active_num
		call_deferred("do_ride", body)

func do_ride(rider):
	in_use = true
	rider.reparent(rider_container)
	rider.global_position = rider_position.global_position
	pcam.append_follow_targets(self)

func _dismount():
	in_use = false
	#rider_container.scale.x = 1
	
	var rider = rider_container.get_children()[0]
	rider.reparent(get_tree().current_scene)
	rider.in_use = true
	pcam.erase_follow_targets(self)
	
	if sprite.flip_h:
		rider.position.x -=50
	elif !sprite.flip_h:
		rider.position.x +=50
		


func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
