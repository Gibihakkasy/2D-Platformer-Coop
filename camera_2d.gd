extends Camera2D

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	var pcam = get_node("PhantomCamera2D")
		
	if players.size() > 1:
		pcam.follow_mode = 3
		pcam.set_auto_zoom(true)
		pcam.set_auto_zoom_margin(Vector4(200, 50, 200, 50))
		pcam.set_auto_zoom_max(3.0)
		pcam.set_auto_zoom_min(0.5)
		pcam.set_follow_damping(true)
		pcam.set_follow_damping_value(Vector2(0.3, 0.3))
		
		for player in players:
			pcam.append_follow_targets(player)
	elif players.size() == 1:
		pcam.follow_mode = 2
		var player: CharacterBody2D = players[0]
		pcam.set_follow_target(player)
