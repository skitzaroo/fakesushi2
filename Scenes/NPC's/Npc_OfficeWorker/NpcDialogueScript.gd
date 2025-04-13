extends Area2D

# 💬 Text Bubble System
var talking = false

@export var speech: Label
@export var line1: Array[String]

@export var show_text_duration: float = 1.0
@export var silence_duration: float = 1.0

# 🧾 Contract will be assigned by GameManager
var contract

func _ready():
	speech.text = ""

func _on_body_entered(body):
	if body.is_in_group("Player") and not talking:
		talk_tween()

		var line = ""

		# Get a random flavor line if one exists
		if line1.size() > 0:
			line = line1[randi() % line1.size()]

		# Append contract flavor and execute it
		if contract != null:
			line += "\n" + contract.flavor_text
			GameManager.execute_contract(contract)
			contract = null  # 🔁 Prevent repeat execution

		# Set the full dialog
		speech.text = line
		talking = true

func _on_body_exited(body):
	if body.is_in_group("Player") and talking:
		await get_tree().create_timer(show_text_duration).timeout
		speech.text = "*murmur*"
		await get_tree().create_timer(silence_duration).timeout
		speech.text = ""
		talking = false

func talk_tween():
	talking = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.2)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
