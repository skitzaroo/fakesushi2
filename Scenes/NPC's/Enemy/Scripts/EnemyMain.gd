extends CharacterBase
class_name EnemyMain

@onready var fsm := $FSM as FiniteStateMachine
var player_in_range: bool = false

@export var attack_node: Node
@export var chase_node: Node

# Called when this enemy finishes its attack animation or logic
func finished_attacking() -> void:
	if player_in_range:
		fsm.change_state(attack_node, "enemy_chase_state")
	else:
		fsm.change_state(attack_node, "enemy_idle_state")

# Called when the player enters this enemy's detection area
func _on_detection_area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

		# Only chase if currently idle (prevents interrupting other states)
		if fsm.current_state.name == "enemy_idle_state":
			fsm.force_change_state("enemy_chase_state")

# Called when the player exits the detection area
func _on_detection_area_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

		# Return to idle if we were chasing
		if fsm.current_state.name == "enemy_chase_state":
			fsm.change_state(chase_node, "enemy_idle_state")

# Called when the enemy dies
func _die() -> void:
	super()  # Call base class death logic
	fsm.force_change_state("enemy_death_state")
