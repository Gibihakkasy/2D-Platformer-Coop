extends CharacterBody2D

var in_use: bool = true

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var jump_component: JumpComponent = $JumpComponent

@export var my_active_num : int
@export var my_name: String
@export_file("*.png") var my_sprite = "res://Sprites/Characters/character_0000.png"

#weapon
@onready var weapon: Node2D = $Weapon
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	add_to_group("Player")
	set_name(my_name)
	jump_component.controllable_character = self
	movement_component.controllable_character = self
	movement_component.sprite_2d = sprite_2d
	movement_component.weapon = weapon
	sprite_2d.texture = load(my_sprite)

func _process(delta):
	collision_shape_2d.disabled = not in_use
	
	#check if previous frame the character was on floor for jump buffering
	jump_component.was_on_floor = is_on_floor()
	
	if Input.is_action_just_pressed("attack"+str(my_active_num)):
		attack()
	
	if global_position.y > 500:
		game_over()

func attack():
	animation_player.play("Attack")

func game_over():
	var players = get_tree().get_nodes_in_group("Player")
	
	if players.size() > 1:
		queue_free()
	elif players.size() == 1:
		get_tree().reload_current_scene()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play("Idle")
