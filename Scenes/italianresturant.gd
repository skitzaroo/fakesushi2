extends CollisionShape2D


func _on_body_entered(body):
	if body.name == "MafiaBoss":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
