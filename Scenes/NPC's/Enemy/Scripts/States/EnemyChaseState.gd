extends State
class_name enemy_chase_state

@export var attack_range: float = 50.0
@export var move_speed: float = 30.0
@export var animator: AnimationPlayer

@onready var body := $"../.."

func Enter() -> void:
	if animator:
		animator.play("Chasing")

func Update(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	if not player:
		return  # Player not found, skip update

	var chase_direction: Vector2 = player.global_position - body.global_position
	body.velocity = chase_direction.normalized() * move_speed
	body.move_and_slide()

	if chase_direction.length() <= attack_range:
		state_transition.emit(self, "enemy_attack_state")
