extends Area2D

@onready var label = $Label
@export var next_scene = "res://Scenes/Main.tscn" #PackedScene

func _ready():
	pass
	#label.visible = false

#Load the next selected scene as the player presses 'Enter'

#Show or hide the label as the player enters and exits the area
func _on_body_entered(body):
	print("ENTERED:", body.name)  # ✅ Debug this
	if body.name == "MafiaBoss":
		#Global.spawn_point = Vector2(-242.4735, -83.94291)	#Global.came_from_scene = "ItalianRestaurant"
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
func _on_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
