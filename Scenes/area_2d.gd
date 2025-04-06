extends Area2D

@onready var label = $Label
@export var next_scene = "res://Scenes/ItalianRestaurant.tscn" #PackedScene

func _ready():
	label.visible = false

#Load the next selected scene as the player presses 'Enter'
func _process(_delta):
	if(Input.is_action_just_pressed("Enter") and label.visible == true):
		get_tree().change_scene_to_packed(next_scene)

#Show or hide the label as the player enters and exits the area
func _on_body_entered(body):
	print("ENTERED:", body.name)  # ✅ Debug this
	if body.name == "MafiaBoss":
		Global.spawn_point_name = "from_street"
		get_tree().change_scene_to_file("res://Scenes/ItalianRestaurant.tscn")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
