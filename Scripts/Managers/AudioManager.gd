extends Node

# This class preloads all of our sound effects so that they can be played at a moment's notice
#region Preloaded Sounds
const PLAYER_ATTACK_HIT = preload("res://Art/Audio/Effects/AttackHit.ogg")
const PLAYER_ATTACK_SWING = preload("res://Art/Audio/Effects/AttackSwing.ogg")
const ENEMY_HIT = preload("res://Art/Audio/thelizardis1_gmail_com - gun.ogg")
const BLOODY_HIT = preload("res://Art/Audio/thelizardis1_gmail_com - gun.ogg")
const COIN_PICK = preload("res://Art/Audio/Effects/coin_pick.ogg")
const QUEST_SOUND = preload("res://Art/Audio/Effects/QuestSound.ogg")
const FootstepsAudio = preload("res://Scenes/Player/Sprite/concrete-footsteps-6752.mp3")

#endregion

var audio_players = []
var max_players = 8
var starting_players = 3

func _ready() -> void:
	print("[DEBUG] AudioManager is ready. Initializing audio streams...")
	initiate_audio_stream()

# Play a sound. Call this function from anywhere
# Arguments: (audio_clip, offset, volume)
# Example: AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.25, 1)
func play_sound(audiostream : AudioStreamOggVorbis, offset : float, volume : float):
	#print("[DEBUG] Request to play sound received.")
	var available_player = null

	# Find a free audio player
	for player in audio_players:
		if not player.is_playing():
			available_player = player
			#print("[DEBUG] Found available audio player.")
			break

	# If no player is available, create a new one if we haven't hit the max
	if available_player == null:
		if audio_players.size() < max_players:
			#print("[DEBUG] No available player found. Creating new AudioStreamPlayer.")
			available_player = AudioStreamPlayer.new()
			audio_players.append(available_player)
			add_child(available_player)
		else:
			#print("[DEBUG] Max audio player limit reached. Reusing first player.")
			available_player = audio_players[0]

	# Set up and play the audio
	available_player.stream = audiostream
	available_player.pitch_scale = randf_range(0.9, 1.1)
	available_player.volume_db = volume
	#print("[DEBUG] Playing sound with pitch_scale %.2f, volume %.2f, offset %.2f" % [available_player.pitch_scale, volume, offset])
	available_player.play(offset)

# Instantiate initial AudioStreamPlayers into the scene
func initiate_audio_stream():
	for i in range(starting_players):
		var player = AudioStreamPlayer.new()
		audio_players.append(player)
		add_child(player)
		#print("[DEBUG] Created AudioStreamPlayer #%d" % i)
	#print("[DEBUG] Audio stream initialization complete. Total players: %d" % audio_players.size())
