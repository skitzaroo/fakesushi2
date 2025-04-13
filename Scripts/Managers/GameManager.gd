extends Node2D

@export var upgrade_cost := 100
@export var upgraded_texture: Texture2D
@onready var sprite = $Sprite2D
var money = 0
var upgraded := false

func _on_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_accept") and not upgraded:
		if GameManager.money >= upgrade_cost:
			GameManager.add_money(-upgrade_cost)
			sprite.texture = upgraded_texture
			upgraded = true
			print("🪑 Table upgraded!")
		else:
			print("❌ Not enough money")


#NOTE This class is our game manager and handles the players money and loading scenes
#These functions can be called globally from anywhere

func reset_money():
	money = 0

func add_money(addmoney : int):
	money += addmoney

func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	get_tree().reload_current_scene()
