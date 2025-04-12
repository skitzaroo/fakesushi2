extends CharacterBase
class_name PlayerMain

# Constants
const SPEED = 120.0
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")

# State machine & interaction collider
@onready var fsm = $FSM as FiniteStateMachine
@onready var interact_area = $CollisionShape2D
var can_exit := false

func _ready():
	print("🟢 [PlayerMain] Ready.")

	if has_node("Camera2D"):
		$Camera2D.make_current()
		print("🎥 [PlayerMain] Camera2D set as current.")
	else:
		print("⚠️ [PlayerMain] No Camera2D found on:", name)

	print("🔎 [PlayerMain] Checking Global.spawn_point_name:", Global.spawn_point_name)

	if Global.spawn_point_name != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(Global.spawn_point_name)
		if spawn_point:
			global_position = spawn_point.global_position
			print("📍 [PlayerMain] Spawned at:", global_position)
			await get_tree().create_timer(0.5).timeout
			can_exit = true
			print("✅ [PlayerMain] Player can now exit the scene.")
		else:
			print("❌ [PlayerMain] Spawn point not found:", Global.spawn_point_name)
			Global.spawn_point_name = "from_start"

func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_dir != Vector2.ZERO:
		print("🕹️ [PlayerMain] Input direction:", input_dir)

	velocity = input_dir.normalized() * SPEED
	move_and_slide()

# Custom death logic for player
func _die():
	print("💀 [PlayerMain] Player has died. Triggering FSM and death screen.")
	super()  # Calls CharacterBase._die()
	fsm.force_change_state("Die")

	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)
	print("⚰️ [PlayerMain] Death screen instantiated.")

# Handles player interaction with NPCs or objects
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("🔘 [PlayerMain] Interact key pressed.")
		var found = false

		for body in interact_area.get_overlapping_bodies():
			print("🔍 [PlayerMain] Checking body:", body.name)
			if body.has_method("on_player_interact"):
				print("✅ [PlayerMain] Interacting with:", body.name)
				body.on_player_interact()
				found = true
				break

		if not found:
			print("🚫 [PlayerMain] No interactable found.")
