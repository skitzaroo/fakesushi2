extends Area2D

@onready var label = $Label
@export var next_scene: PackedScene

func _ready():
	label.visible = false
	print("[DEBUG] Area2D is ready. Label hidden.")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("[DEBUG] 'Enter' (ui_accept) was just pressed.")
		if label.visible:
			print("[DEBUG] Label is visible. Loading next scene...")
			GameManager.load_next_level(next_scene)
		else:
			print("[DEBUG] Label is not visible. Not loading scene.")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		label.visible = true
		print("[DEBUG] Player entered the area. Label shown.")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
		print("[DEBUG] Player exited the area. Label hidden.")
