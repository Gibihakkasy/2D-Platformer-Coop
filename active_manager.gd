extends Node

@export var active : int = 1
@onready var players: Array = get_tree().get_nodes_in_group("Player")
var player_count: int = 0
var is_coop: bool = false
@onready var player_scene: PackedScene = preload("res://GeneralPlayer.tscn")
@onready var pcam = get_tree().current_scene.get_node("PhantomCamera2D")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	for player in players:
		player_count += 1
		player.set_my_active_num(player_count)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_player_2"):
		spawn_player()
		
func spawn_player():
	players = get_tree().get_nodes_in_group("Player")
	if players.size() == 1:
		var temp_player_scene = player_scene.instantiate()
		temp_player_scene.sprite_file = "res://Sprites/Characters/character_0004.png"
		temp_player_scene.name = "Pinkman"
		temp_player_scene.global_position = Vector2(players[0].position.x -25, players[0].position.y -25)
		player_count += 1
		temp_player_scene.set_my_active_num(player_count)
		add_child(temp_player_scene)
		is_coop = true
		get_tree().call_group("Player", "set_is_coop")
		
	
	
