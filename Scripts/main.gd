# Scripts/Main.gd
extends Node2D

@onready var spawn_point = $CanvasLayer/SpawnPoint
@onready var spawner = preload("res://Scripts/Spawner.gd").new()

func _ready():
	#add_child(spawner)
	await get_tree().process_frame  # Wait one frame to ensure all nodes are ready
	spawner.setup(spawn_point)
	print("SPAWN POINT:", spawn_point)
