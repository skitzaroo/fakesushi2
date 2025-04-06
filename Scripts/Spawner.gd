extends Node

var visitor_scene = preload("res://Scenes/Visitor.tscn")
var spawn_point : Node2D

func setup(spawn_node):
	spawn_point = spawn_node
	spawn_visitor()
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = false
	timer.timeout.connect(spawn_visitor)
	add_child(timer)
	timer.start()

func spawn_visitor():
	var v = visitor_scene.instantiate()
	v.position = spawn_point.global_position
	v.visitor_type = "client" if randf() < 0.7 else "enemy"
	v.visitor_clicked.connect(_on_visitor_clicked)
	#get_tree().current_scene.add_child(v)

func _on_visitor_clicked(type):
	if type == "client":
		print("💼 Client hired us. +$100")
		# Later: Add money, mission log, favor, etc.
	elif type == "enemy":
		print("💥 Enemy attacked! -1 HQ Health")
		# Later: Damage logic, animations, retaliation
