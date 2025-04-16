extends CharacterBase
class_name PlayerMain

const SPEED = -90
const DEATH_SCREEN = preload("res://Scenes/Misc/DeathScreen.tscn")
const INTERACT_COOLDOWN = 0.6

#const PAUSE_SFX = AudioManager.PAUSE_SFX
#const UNPAUSE_SFX = AudioManager.UNPAUSE_SFX


const PAUSE_MENU_SCENE = preload("res://PauseMenu.tscn") # 👈 Adjust path if needed

var menu_open := false
var pause_menu_instance: CanvasLayer = null

@onready var fsm = $FSM as FiniteStateMachine
@onready var interact_area: Area2D = $InteractArea
@onready var camera = $Camera2D

var can_exit := false
var last_interact_time := -1.0  # For cooldown timing


func _ready():
	
	if Engine.is_editor_hint(): return  # Optional: disable in editor
	print("📍", global_position.round())
	print("🟢 [PlayerMain] Ready.")

	if camera:
		camera.make_current()
		print("🎥 [PlayerMain] Camera2D set.")
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 3.0
	else:
		print("⚠️ [PlayerMain] No Camera2D found!")

	if Global.spawn_point != Vector2(224.0, 94.0):
		var spawn_point = Vector2(-242.4735, -83.94291)
		if spawn_point:
			print("📍 [PlayerMain] Spawned at:", Vector2(-242.4735, -83.94291))
			await get_tree().create_timer(0.5).timeout
			can_exit = true
			print("✅ [PlayerMain] Player can now exit.")
		else:
			print("❌ [PlayerMain] Spawn point not found:", Global.spawn_point_name)
			Global.spawn_point_name = "from_start"



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
			

	elif event.is_action_pressed("pause_menu_toggle"):
		_toggle_menu()



func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	#print("📍 Player Position:", global_position)
	move_and_slide()
	
	



func _toggle_menu():
	if menu_open:
		get_tree().paused = false
#		AudioManager.play_sound(UNPAUSE_SFX, -0000.0, 0.0)
		print("📕 Closing pause menu")
		if pause_menu_instance:
			pause_menu_instance.queue_free()
			pause_menu_instance = null
		menu_open = false
	else:
#		AudioManager.play_sound(PAUSE_SFX, 0.0, 0.0)
		print("📖 Opening pause menu")
		pause_menu_instance = PAUSE_MENU_SCENE.instantiate()
		get_tree().current_scene.add_child(pause_menu_instance)
		get_tree().paused = true
		menu_open = true
