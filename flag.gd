extends Area2D

@export_file("*.tscn") var next_scene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player_count: int
		var players: Array = get_tree().get_nodes_in_group("Player")
		for player in players:
			player_count += 1
			
		body.queue_free()
		player_count -= 1
		
		if player_count <= 0:		
			get_tree().reload_current_scene()
