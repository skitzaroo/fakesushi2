extends CharacterBase
class_name PlayerMain

const SPEED = 120.0
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")
const INTERACT_COOLDOWN = 0.6

@onready var fsm = $FSM as FiniteStateMachine
@onready var interact_area: Area2D = $InteractArea
@onready var footsteps_audio = $FootstepsAudio  # Add AudioStreamPlayer2D to your scene
@onready var camera = $Camera2D

var can_exit := false
var last_interact_time := -1.0  # For cooldown timing

func _ready():
	print("🟢 [PlayerMain] Ready.")

	if camera:
		camera.make_current()
		print("🎥 [PlayerMain] Camera2D set.")
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 3.0
	else:
		print("⚠️ [PlayerMain] No Camera2D found!")

	if Global.spawn_point_name != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(Global.spawn_point_name)
		if spawn_point:
			global_position = spawn_point.global_position
			print("📍 [PlayerMain] Spawned at:", global_position)
			await get_tree().create_timer(0.5).timeout
			can_exit = true
			print("✅ [PlayerMain] Player can now exit.")
		else:
			print("❌ [PlayerMain] Spawn point not found:", Global.spawn_point_name)
			Global.spawn_point_name = "from_start"

func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_dir != Vector2.ZERO:
		print("🕹️ [PlayerMain] Moving:", input_dir)
		


	velocity = input_dir.normalized() * SPEED
	move_and_slide()

func _die():
	print("💀 [PlayerMain] Died.")
	super()
	fsm.force_change_state("Die")
	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)
	print("⚰️ [PlayerMain] Death screen shown.")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("🔘 [PlayerMain] Interact key pressed.")

		if interact_area == null:
			print("❌ [PlayerMain] InteractArea is null!")
			return

		# Cooldown check
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_interact_time < INTERACT_COOLDOWN:
			print("🕰️ [PlayerMain] Still cooling down.")
			return

		last_interact_time = now

		var found = false
		for body in interact_area.get_overlapping_bodies():
			print("🔍 [PlayerMain] Found body:", body.name)
			if body.has_method("on_player_interact"):
				print("✅ [PlayerMain] Interacting with:", body.name)
				body.on_player_interact()
				found = true
				break

		if not found:
			print("🚫 [PlayerMain] No valid target.")
