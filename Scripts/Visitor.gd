extends CharacterBody2D

signal visitor_clicked(visitor_type)

@export var visitor_type = "client" # or "enemy"
@onready var label = $Label

func _ready():
	label.text = visitor_type.capitalize()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("visitor_clicked", visitor_type)
		queue_free()  # Remove after interaction
