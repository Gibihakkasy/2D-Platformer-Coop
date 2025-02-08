extends Node2D
class_name MovementComponent

@export var move_speed : float = 100.0

@onready var controllable_character: CharacterBody2D
@onready var sprite_2d: Sprite2D
@onready var weapon: Node2D

func _physics_process(delta):
	if not controllable_character.in_use:
		return
	
	controllable_character.velocity.x = 0
	
	if Input.is_action_pressed("left"+str(controllable_character.my_active_num)):
		controllable_character.velocity.x -= move_speed
		sprite_2d.flip_h = false
		if weapon.position.x > 0:
			weapon.position.x *= -1
			weapon.scale.x *= -1
	if Input.is_action_pressed("right"+str(controllable_character.my_active_num)):
		controllable_character.velocity.x += move_speed
		sprite_2d.flip_h = true
		if weapon.position.x < 0:
			weapon.position.x *=-1
			weapon.scale.x *= -1
	if Input.is_action_pressed("down"+str(controllable_character.my_active_num)):
		controllable_character.position.y += 1
	
	controllable_character.move_and_slide()
