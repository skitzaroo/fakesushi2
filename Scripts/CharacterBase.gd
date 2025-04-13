extends CharacterBody2D
class_name CharacterBase

@export var sprite : AnimatedSprite2D
@export var healthbar : ProgressBar
@export var health : int
@export var flipped_horizontal : bool
@export var hit_particles : GPUParticles2D
var invincible : bool = false
var is_dead : bool = false

func _ready():
	print("[DEBUG] Character ready. Initializing...")
	init_character()

func _process(_delta):
	pass  # Uncomment Turn() if needed
	# Turn()

# Initialize healthbar and other values
func init_character():
	healthbar.max_value = health
	healthbar.value = health
	print("[DEBUG] Character initialized with health:", health)

# Flip character sprite depending on movement
func Turn():
	var direction = -1 if flipped_horizontal else 1
	if velocity.x < 0:
		sprite.scale.x = -direction
		print("[DEBUG] Character turned left. sprite.scale.x =", sprite.scale.x)
	elif velocity.x > 0:
		sprite.scale.x = direction
		print("[DEBUG] Character turned right. sprite.scale.x =", sprite.scale.x)

#region Taking Damage

# Universal damage effect handler
func damage_effects():
	print("[DEBUG] Playing damage effects (sound + flash + particles)")
	AudioManager.play_sound(AudioManager.BLOODY_HIT, 0, -3)
	after_damage_iframes()
	if hit_particles:
		hit_particles.emitting = true
		print("[DEBUG] Hit particles emitting.")

# Temporarily invincible and visual feedback
func after_damage_iframes():
	invincible = true
	print("[DEBUG] Character is now invincible.")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.DARK_RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tween.finished
	invincible = true
	print("[DEBUG] Character invincibility ended.")

# Main damage handler
func _take_damage(amount):
	if invincible or is_dead:
		print("[DEBUG] Damage ignored. invincible:", invincible, "| is_dead:", is_dead)
		return

	health -= amount
	healthbar.value = health
	print("[DEBUG] Character took damage:", amount, "| Current health:", health)
	damage_effects()

	if health <= 0:
		print("[DEBUG] Health is 0 or less. Character will die.")
		_die()

# Death handler
func _die():
	if is_dead:
		print("[DEBUG] _die() called but character is already dead.")
		return

	is_dead = true
	print("[DEBUG] Character marked as dead. Cleaning up in 1 second...")
	await get_tree().create_timer(1.0).timeout

	if is_instance_valid(self) and not is_in_group("Player"):
		print("[DEBUG] Character is not player. Freeing node.")
		queue_free()
	else:
		print("[DEBUG] Character is a player. Not freeing node.")

#endregion
