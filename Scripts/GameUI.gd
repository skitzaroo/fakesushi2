extends Control

@export var money_label: Label

var previous_money: int = -1
var coin_sound := AudioStreamPlayer.new()
var bounce_tween := Tween.new()

func _ready():
	add_child(coin_sound)
	coin_sound.stream = preload("res://Art/Audio/Effects/coin_pick.ogg")



func _process(_delta: float) -> void:
	var current_money = GameManager.money
	if current_money != previous_money:
		money_label.text = "Coins: %d" % current_money

		if current_money > previous_money:
			coin_sound.play()
			# Quick scale bounce
			money_label.scale = Vector2(1.2, 1.2)
			#bounce_tween.kill_all()
			#bounce_tween.tween_property(money_label, "scale", Vector2(1, 1), 0.15)

		previous_money = current_money
