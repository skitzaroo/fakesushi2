extends State
class_name PlayerIdle

@export var animator: AnimationPlayer
@onready var player = get_parent()  # Assuming the parent is the player

func Enter():
	if animator and not animator.is_playing():
		animator.play("Idle")
	print("🎮 Entered Idle State")

func Update(_delta: float):
	#if Global.has("menu_open") and Global.menu_open:
	pass
	var move_input = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")

	if move_input.length() > 0:
		print("➡️ Transitioning to Moving")
		state_transition.emit(self, "Moving")
		return

	if Input.is_action_just_pressed("Punch") or Input.is_action_just_pressed("Kick"):
		print("👊 Transitioning to Attacking")
		state_transition.emit(self, "Attacking")
