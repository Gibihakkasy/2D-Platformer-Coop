extends Node2D
class_name JumpComponent

var can_coyote_jump: bool = false
var jump_buffered: bool = false
var was_on_floor: bool

@export var jump_force : float = 250.0
@export var gravity : float = 900.0
@export_range(1, 2) var gravity_modifier : float = 1.2

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var controllable_character: CharacterBody2D

func _physics_process(delta):
	if not controllable_character.in_use:
		return
	
	if controllable_character.is_on_floor() == false:
		if controllable_character.velocity.y < 0:
			controllable_character.velocity.y += gravity * delta
		else:
			controllable_character.velocity.y += gravity * delta * gravity_modifier
	
	if controllable_character.my_active_num == 0:
		if Input.is_action_just_pressed("ui_select"):
			jump(delta)
	elif controllable_character.my_active_num == 1:
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			jump(delta)
	
	controllable_character.move_and_slide()
	if was_on_floor and !controllable_character.is_on_floor() and controllable_character.velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	if !was_on_floor and controllable_character.is_on_floor():
		if jump_buffered:  
			jump(delta)
			
func jump(delta):
	if controllable_character.is_on_floor() or can_coyote_jump:
		controllable_character.velocity.y = -jump_force
		if can_coyote_jump:
			can_coyote_jump = false
	else:
		if !jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false
