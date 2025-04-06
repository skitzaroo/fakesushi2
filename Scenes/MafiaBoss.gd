extends CharacterBody2D
#extends CharacterBase
#class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")

#All of our logic is either in the CharacterBase class
#or spread out over our states in the finite-state-manager, this class is almost empty 
const SPEED = 120.0
var can_exit := false

#func _ready():
	
	#$Camera2D.make_current()
	#Global.return_position = Vector2(800, 200)  # ← Where you want him to land on street
	#Global.came_from_scene = "ItalianRestaurant"
func _ready():
	Global.spawn_point_name = "from_start"		#Global.came_from_scene = "ItalianRestaurant"
	print("Camera is: ", $Camera2D)
	print("MafiaBoss is alive in this scene.")  # 👈 Add this
	if has_node("Camera2D"):
		$Camera2D.make_current()
	else:
		print("⚠️ Warning: No Camera2D found on", name)

	if Global.spawn_point_name != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(Global.spawn_point_name)
		if spawn_point:
			global_position = spawn_point.global_position
			await get_tree().create_timer(0.5).timeout
			can_exit = true
		else:
			print("⚠️ Spawn point not found: ", Global.spawn_point_name)
			global_position = Vector2(200, 200)  # ← safe fallback
		
func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	velocity = input_dir.normalized() * SPEED
	move_and_slide()
