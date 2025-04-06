# Attach to your Camera2D
extends Camera2D

func _ready():
	make_current()  # 🔥 This replaces the old "Current" checkbox
