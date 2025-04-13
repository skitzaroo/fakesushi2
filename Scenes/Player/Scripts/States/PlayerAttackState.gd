extends State
class_name PlayerAttacking

@export var animator : AnimationPlayer
var current_attack : Attack_Data
@export var attacks : Array[Attack_Data]
@onready var hit_particles = $"../../AnimatedSprite2D/HitParticles"

func Enter():
	print("🔁 Entering PlayerAttacking state...")
	
	AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.3, 1)
	DetermineAttack()

	if current_attack == null:
		print("⚠️ No attack input detected!")
		state_transition.emit(self, "Idle")
		return
	
	print("▶️ Playing animation:", current_attack.anim)
	animator.play(current_attack.anim)

	await animator.animation_finished
	print("✅ Animation finished, returning to Idle.")
	state_transition.emit(self, "Idle")

func DetermineAttack():
	if Input.is_action_just_pressed("Punch"):
		current_attack = attacks[0]
		print("👊 Punch triggered!")
	elif Input.is_action_just_pressed("Kick"):
		current_attack = attacks[1]
		print("🦵 Kick triggered!")
	else:
		current_attack = null
		print("😐 No attack pressed.")

func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		print("💥 Hitbox collided with enemy:", body.name)
		deal_damage(body)
		AudioManager.play_sound(AudioManager.PLAYER_ATTACK_HIT, 0, 1)

func deal_damage(enemy : EnemyMain):
	print("🔥 Dealing damage:", current_attack.damage, "to", enemy.name)
	hit_particles.emitting = true
	enemy._take_damage(current_attack.damage)
